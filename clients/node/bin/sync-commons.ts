#!/usr/bin/env npx tsx
import { readFileSync, writeFileSync, mkdirSync, readdirSync, rmSync, existsSync, statSync } from 'fs';
import { join, dirname, relative } from 'path';
import { createHash } from 'crypto';

const ROOT = join(dirname(new URL(import.meta.url).pathname), '..');
const COMMONS_SRC = join(ROOT, 'commons', 'src');

const TARGETS = ['api-entreprise', 'api-particulier'];

function getAllFiles(dir: string): string[] {
  const files: string[] = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...getAllFiles(full));
    } else if (entry.name.endsWith('.ts')) {
      files.push(full);
    }
  }
  return files.sort();
}

function sourceDigest(): string {
  const files = getAllFiles(COMMONS_SRC);
  const hash = createHash('sha1');
  for (const f of files) {
    hash.update(readFileSync(f));
  }
  return hash.digest('hex');
}

function syncTarget(pkg: string, digest: string, check: boolean): boolean {
  const targetDir = join(ROOT, pkg, 'src', 'commons');
  let drift = false;

  if (!check) {
    if (existsSync(targetDir)) rmSync(targetDir, { recursive: true });
    mkdirSync(targetDir, { recursive: true });
  }

  const header = `// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: ${digest}).\n// Regenerate via clients/node/bin/sync-commons.ts\n\n`;

  for (const srcFile of getAllFiles(COMMONS_SRC)) {
    const rel = relative(COMMONS_SRC, srcFile);
    const destFile = join(targetDir, rel);
    const content = header + readFileSync(srcFile, 'utf-8');

    if (check) {
      let existing = '';
      try {
        existing = readFileSync(destFile, 'utf-8');
      } catch {}
      if (existing !== content) drift = true;
    } else {
      mkdirSync(dirname(destFile), { recursive: true });
      writeFileSync(destFile, content);
    }
  }

  return drift;
}

// --- CLI ---
const args = process.argv.slice(2);
const check = args.includes('--check');

const digest = sourceDigest();
let drift = false;

for (const pkg of TARGETS) {
  drift = syncTarget(pkg, digest, check) || drift;
}

if (check) {
  if (drift) {
    console.error('sync-commons: vendored copies are stale — run clients/node/bin/sync-commons.ts');
    process.exit(1);
  }
  console.log('sync-commons: vendored copies are up to date.');
} else {
  console.log(`sync-commons: synced commons@${digest.slice(0, 10)} to ${TARGETS.join(', ')}`);
}
