#!/usr/bin/env npx tsx
import { readFileSync, writeFileSync, mkdirSync, readdirSync, unlinkSync } from 'fs';
import { join, dirname, basename } from 'path';
import { parse } from 'yaml';

const ROOT = join(dirname(new URL(import.meta.url).pathname), '..');
const COMMONS_SWAGGER = join(ROOT, '..', '..', 'commons', 'swagger');

interface Spec {
  file: string;
  pkg: string;
  product: string;
}

const SPECS: Record<string, Spec> = {
  entreprise: {
    file: join(COMMONS_SWAGGER, 'openapi-entreprise.yaml'),
    pkg: 'api-entreprise',
    product: 'entreprise',
  },
  particulier: {
    file: join(COMMONS_SWAGGER, 'openapi-particulier.yaml'),
    pkg: 'api-particulier',
    product: 'particulier',
  },
};

const VERSION_PATH_RE = /^\/v(\d+)\//;
const MIN_SUPPORTED_VERSION = 3;
const STOP_WORDS = ['identite', 'identifiant', 'france_connect'];
const SIRET_PARAMS = ['siret'];
const SIREN_PARAMS = ['siren'];

function snake(str: string): string {
  return str
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .replace(/([a-z\d])([A-Z])/g, '$1_$2')
    .replace(/-/g, '_')
    .toLowerCase();
}

function camel(str: string): string {
  return str
    .split('_')
    .map((s) => s.charAt(0).toUpperCase() + s.slice(1))
    .join('');
}

function kwargName(raw: string): string {
  return snake(raw.replace(/\[\]$/, ''));
}

function pathSegments(path: string): string[] {
  return path.split('/').filter(Boolean);
}

function providerFromPath(path: string): string {
  const segs = pathSegments(path);
  return segs[1] || segs[0];
}

function logicalPath(path: string): string {
  return path.replace(VERSION_PATH_RE, '/');
}

function versionOf(path: string): number | null {
  const m = path.match(VERSION_PATH_RE);
  return m ? parseInt(m[1], 10) : null;
}

function methodNameFor(path: string, existing: Set<string>): string {
  let segs = pathSegments(path);
  if (segs[0]?.match(/^v\d+$/)) segs = segs.slice(1);
  segs = segs.slice(1);

  const usable = segs.map((s) => (s.startsWith('{') ? null : s));
  const nonTemplated = usable.filter((s): s is string => s !== null);

  let candidate = nonTemplated[nonTemplated.length - 1];
  if (
    STOP_WORDS.includes(candidate) &&
    nonTemplated.length > 1
  ) {
    candidate = nonTemplated[nonTemplated.length - 2];
  }

  let name = snake(candidate || '');
  if (name && !existing.has(name)) return name;

  const tail = nonTemplated.slice(-3);
  let fullName = snake(tail.join('_'));
  if (!fullName) fullName = `endpoint_${existing.size + 1}`;
  return fullName;
}

interface Parameter {
  name: string;
  in: string;
  required?: boolean;
  schema?: { type?: string; items?: unknown };
}

interface Operation {
  summary?: string;
  deprecated?: boolean;
  parameters?: Parameter[];
}

interface Variant {
  path: string;
  operation: Operation;
}

function getPathParams(op: Operation): Parameter[] {
  return (op.parameters || []).filter((p) => p.in === 'path');
}

function getQueryParams(op: Operation): Parameter[] {
  return (op.parameters || []).filter((p) => p.in === 'query');
}

const AUDIT_PARAMS = ['recipient', 'context', 'object'];

function buildMethod(
  logical: string,
  variants: Map<number, Variant>,
  existing: Set<string>,
): string {
  const sortedVersions = [...variants.keys()].sort((a, b) => a - b);
  const defaultVersion = Math.max(...sortedVersions);
  const reference = variants.get(defaultVersion)!;
  const operation = reference.operation;

  const pathVars = getPathParams(operation).map((p) => p.name);
  const methodName = methodNameFor(logical, existing);
  existing.add(methodName);

  const positional = pathVars.map((v) => snake(v));

  const validations: string[] = [];
  for (const name of pathVars) {
    const sn = snake(name);
    if (SIRET_PARAMS.includes(sn)) {
      validations.push(
        `    validateSiret(${sn}, '${sn}');`,
      );
    } else if (SIREN_PARAMS.includes(sn)) {
      validations.push(
        `    validateSiren(${sn}, '${sn}');`,
      );
    }
  }

  const qparams = getQueryParams(operation);
  const typedPositional = positional.map((p) => `${p}: string`);
  const optionsFields: string[] = [];
  optionsFields.push('version?: number');
  let anyRequired = false;
  for (const p of qparams) {
    const kn = kwargName(p.name);
    const isArray =
      p.name.endsWith('[]') ||
      p.schema?.type === 'array';
    const type = isArray ? 'string[]' : 'string';
    const required = p.required === true && !AUDIT_PARAMS.includes(p.name);
    if (required) anyRequired = true;
    optionsFields.push(`${kn}${required ? '' : '?'}: ${type}`);
  }

  const hasOptions = optionsFields.length > 0;
  const optionsSuffix = anyRequired ? '' : ' = {}';
  const signature = hasOptions
    ? `${typedPositional.join(', ')}${typedPositional.length > 0 ? ', ' : ''}options: { ${optionsFields.join('; ')} }${optionsSuffix}`
    : typedPositional.join(', ');

  const paramEntries: string[] = [];
  for (const p of qparams) {
    const wireName = p.name.replace(/\[\]$/, '');
    const kn = kwargName(p.name);
    paramEntries.push(`'${wireName}': options.${kn}`);
  }

  const caseLines: string[] = [];
  for (const v of sortedVersions) {
    const info = variants.get(v)!;
    const interpolated = info.path.replace(
      /\{(\w+)\}/g,
      (_, name) => `\${${snake(name)}}`,
    );
    if (info.operation.deprecated) {
      caseLines.push(`      case ${v}:`);
      caseLines.push(
        `        process.emitWarning('[DEPRECATED] ${info.path} (#${methodName}): marked deprecated in the OpenAPI spec.', 'DeprecationWarning');`,
      );
      caseLines.push(`        return \`${interpolated}\`;`);
    } else {
      caseLines.push(`      case ${v}:`);
      caseLines.push(`        return \`${interpolated}\`;`);
    }
  }

  const lines: string[] = [];
  const summary = operation.summary ? `  /** ${operation.summary} */` : '';
  if (summary) lines.push(summary);
  lines.push(`  async ${methodName}(${signature}) {`);
  for (const v of validations) lines.push(v);

  lines.push(`    const resolvedVersion = ${hasOptions ? 'options.version' : 'undefined'} ?? ${defaultVersion};`);
  lines.push('    const path = (() => {');
  lines.push('      switch (resolvedVersion) {');
  for (const cl of caseLines) lines.push(cl);
  lines.push('        default:');
  lines.push(
    `          throw new Error(\`version \${resolvedVersion} not available for ${logical}; supported: ${JSON.stringify(sortedVersions)}\`);`,
  );
  lines.push('      }');
  lines.push('    })();');

  if (paramEntries.length > 0) {
    lines.push(
      `    return this.client.get(path, { params: { ${paramEntries.join(', ')} } });`,
    );
  } else {
    lines.push('    return this.client.get(path);');
  }
  lines.push('  }');

  return lines.join('\n');
}

function renderResource(
  provider: string,
  endpoints: [string, Map<number, Variant>][],
): string {
  const className = camel(provider);
  const existing = new Set<string>();

  const needsSiret = endpoints.some(([, variants]) => {
    const defaultV = Math.max(...variants.keys());
    const op = variants.get(defaultV)!.operation;
    return getPathParams(op).some((p) => SIRET_PARAMS.includes(snake(p.name)));
  });

  const needsSiren = endpoints.some(([, variants]) => {
    const defaultV = Math.max(...variants.keys());
    const op = variants.get(defaultV)!.operation;
    return getPathParams(op).some((p) => SIREN_PARAMS.includes(snake(p.name)));
  });

  const imports: string[] = [];
  if (needsSiret) imports.push("import { validateSiret } from '../commons/siret.js';");
  if (needsSiren) imports.push("import { validateSiren } from '../commons/siren.js';");
  imports.push("import type { ClientBase } from '../commons/client-base.js';");

  const methods = endpoints.map(([logical, variants]) =>
    buildMethod(logical, variants, existing),
  );

  return [
    '// DO NOT EDIT — generated from commons/swagger/openapi-*.yaml by',
    '// clients/node/bin/scaffold-resources.ts',
    '',
    ...imports,
    '',
    `export class ${className} {`,
    '  private readonly client: ClientBase;',
    '',
    '  constructor(client: ClientBase) {',
    '    this.client = client;',
    '  }',
    '',
    methods.join('\n\n'),
    '}',
    '',
  ].join('\n');
}

function scaffold(api: string, check: boolean): [string[], boolean] {
  const spec = SPECS[api];
  const content = readFileSync(spec.file, 'utf-8');
  const doc = parse(content);

  const grouped = new Map<
    string,
    Map<string, Map<number, Variant>>
  >();

  for (const [path, node] of Object.entries(doc.paths || {})) {
    const v = versionOf(path);
    if (v === null || v < MIN_SUPPORTED_VERSION) continue;

    for (const [verb, operation] of Object.entries(
      node as Record<string, unknown>,
    )) {
      if (verb !== 'get') continue;
      if (typeof operation !== 'object' || operation === null) continue;

      const provider = providerFromPath(path);
      const logical = logicalPath(path);

      if (!grouped.has(provider)) grouped.set(provider, new Map());
      const providerMap = grouped.get(provider)!;
      if (!providerMap.has(logical)) providerMap.set(logical, new Map());
      providerMap.get(logical)!.set(v, {
        path,
        operation: operation as Operation,
      });
    }
  }

  const targetDir = join(ROOT, spec.pkg, 'src', 'resources');
  let drift = false;

  if (!check) {
    mkdirSync(targetDir, { recursive: true });
    for (const f of readdirSync(targetDir)) {
      if (f.endsWith('.ts')) unlinkSync(join(targetDir, f));
    }
  }

  const providers = [...grouped.keys()].sort();

  for (const provider of providers) {
    const providerMap = grouped.get(provider)!;
    const endpoints = [...providerMap.entries()].sort(([a], [b]) =>
      a.localeCompare(b),
    );
    const content = renderResource(provider, endpoints);
    const file = join(targetDir, `${snake(provider)}.ts`);

    if (check) {
      let existing = '';
      try {
        existing = readFileSync(file, 'utf-8');
      } catch {}
      if (existing !== content) drift = true;
    } else {
      writeFileSync(file, content);
    }
  }

  if (!check) {
    generateIndex(targetDir, providers);
    updateClient(spec, providers);
  }

  return [providers, drift];
}

function generateIndex(targetDir: string, providers: string[]): void {
  const lines = providers.map(
    (p) => `export { ${camel(p)} } from './${snake(p)}.js';`,
  );
  writeFileSync(join(targetDir, 'index.ts'), lines.join('\n') + '\n');
}

function updateClient(spec: Spec, providers: string[]): void {
  const clientPath = join(ROOT, spec.pkg, 'src', 'client.ts');
  let src: string;
  try {
    src = readFileSync(clientPath, 'utf-8');
  } catch {
    src = generateClientTemplate(spec, providers);
  }

  const importLines = providers.map(
    (p) => `import { ${camel(p)} } from './resources/${snake(p)}.js';`,
  );
  const importBlock = [
    '// <scaffold:imports:begin>',
    ...importLines,
    '// <scaffold:imports:end>',
  ].join('\n');

  const accessorLines = providers.map((p) => {
    const sn = snake(p);
    const cn = camel(p);
    return `  get ${sn}(): ${cn} {\n    if (!this._${sn}) this._${sn} = new ${cn}(this);\n    return this._${sn};\n  }`;
  });
  const fieldLines = providers.map(
    (p) => `  private _${snake(p)}?: ${camel(p)};`,
  );
  const accessorBlock = [
    '  // <scaffold:fields:begin>',
    ...fieldLines,
    '  // <scaffold:fields:end>',
    '',
    '  // <scaffold:resources:begin>',
    ...accessorLines,
    '  // <scaffold:resources:end>',
  ].join('\n');

  if (src.includes('// <scaffold:imports:begin>')) {
    src = src.replace(
      /\/\/ <scaffold:imports:begin>[\s\S]*?\/\/ <scaffold:imports:end>/,
      importBlock,
    );
  }

  if (src.includes('// <scaffold:fields:begin>')) {
    src = src.replace(
      /  \/\/ <scaffold:fields:begin>[\s\S]*?\/\/ <scaffold:resources:end>/,
      accessorBlock,
    );
  }

  writeFileSync(clientPath, src);
}

function generateClientTemplate(spec: Spec, providers: string[]): string {
  const isEntreprise = spec.product === 'entreprise';
  const required = isEntreprise
    ? "['recipient', 'context', 'object']"
    : "['recipient']";
  const envPrefix = isEntreprise ? 'API_ENTREPRISE' : 'API_PARTICULIER';
  const prodUrl = isEntreprise
    ? 'https://entreprise.api.gouv.fr'
    : 'https://particulier.api.gouv.fr';
  const stagingUrl = isEntreprise
    ? 'https://staging.entreprise.api.gouv.fr'
    : 'https://staging.particulier.api.gouv.fr';
  const uaProduct = isEntreprise
    ? 'api-entreprise-node'
    : 'api-particulier-node';

  const importLines = providers.map(
    (p) => `import { ${camel(p)} } from './resources/${snake(p)}.js';`,
  );
  const fieldLines = providers.map(
    (p) => `  private _${snake(p)}?: ${camel(p)};`,
  );
  const accessorLines = providers.map((p) => {
    const sn = snake(p);
    const cn = camel(p);
    return `  get ${sn}(): ${cn} {\n    if (!this._${sn}) this._${sn} = new ${cn}(this);\n    return this._${sn};\n  }`;
  });

  return [
    "import { ClientBase, type Product } from './commons/client-base.js';",
    "import { Configuration, type Environment, type RetryConfig, type Logger } from './commons/configuration.js';",
    "import { buildUserAgent } from './commons/user-agent.js';",
    "import { VERSION } from './version.js';",
    '',
    '// <scaffold:imports:begin>',
    ...importLines,
    '// <scaffold:imports:end>',
    '',
    'const BASE_URLS = {',
    `  production: '${prodUrl}',`,
    `  staging: '${stagingUrl}',`,
    '} as const;',
    '',
    'export interface ClientOptions {',
    '  token?: string;',
    '  environment?: Environment;',
    '  baseUrl?: string;',
    '  defaultParams?: Record<string, string>;',
    '  authStrategy?: { apply(headers: Record<string, string>): void };',
    '  openTimeout?: number;',
    '  readTimeout?: number;',
    '  retry?: RetryConfig;',
    '  logger?: Logger;',
    '  userAgent?: string;',
    '}',
    '',
    'export class Client extends ClientBase {',
    '  constructor(options: ClientOptions = {}) {',
    `    const token = options.token ?? process.env.${envPrefix}_TOKEN;`,
    `    const environment = (options.environment ?? process.env.${envPrefix}_ENV ?? 'production') as Environment;`,
    `    const baseUrl = options.baseUrl ?? process.env.${envPrefix}_BASE_URL;`,
    '',
    '    const config = new Configuration({',
    '      baseUrls: BASE_URLS,',
    '      token,',
    '      authStrategy: options.authStrategy,',
    '      environment,',
    '      baseUrl,',
    '      defaultParams: options.defaultParams,',
    `      userAgent: options.userAgent ?? buildUserAgent('${uaProduct}', VERSION),`,
    '      openTimeout: options.openTimeout,',
    '      readTimeout: options.readTimeout,',
    '      retry: options.retry,',
    '      logger: options.logger,',
    '    });',
    '',
    `    super(config, { product: '${spec.product}' as Product, requiredParams: ${required}, siretParams: ['recipient'] });`,
    '  }',
    '',
    '  // <scaffold:fields:begin>',
    ...fieldLines,
    '  // <scaffold:fields:end>',
    '',
    '  // <scaffold:resources:begin>',
    ...accessorLines,
    '  // <scaffold:resources:end>',
    '}',
    '',
  ].join('\n');
}

// --- CLI ---
const args = process.argv.slice(2);
let api = 'entreprise';
let check = false;

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--api') api = args[++i];
  if (args[i] === '--check') check = true;
}

const targets = api === 'all' ? ['entreprise', 'particulier'] : [api];
let drift = false;

for (const target of targets) {
  const [providers, d] = scaffold(target, check);
  drift = drift || d;
  console.log(`${target}: ${providers.length} providers (${providers.join(', ')})`);
}

if (check && drift) {
  console.error('scaffold-resources: generated files are stale');
  process.exit(1);
}
