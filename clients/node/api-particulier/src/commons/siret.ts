// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: c39093e4bc410efcbe528a7b462142c8c4d7f0a6).
// Regenerate via clients/node/bin/sync-commons.ts

import { InvalidSiretError } from './errors.js';

const DIGITS_14 = /^\d{14}$/;
const LA_POSTE_PATTERN = /^356000000\d{5}$/;

export function isValidSiret(value: string | null | undefined): boolean {
  if (value == null) return false;
  const str = String(value);
  if (!DIGITS_14.test(str)) return false;
  if (LA_POSTE_PATTERN.test(str)) return true;
  return luhnChecksum(str) % 10 === 0;
}

export function validateSiret(
  value: string | null | undefined,
  parameter: string,
): void {
  if (isValidSiret(value)) return;
  throw new InvalidSiretError(
    `${parameter} must be a 14-digit SIRET passing the Luhn checksum (or a La Poste SIRET); got ${JSON.stringify(value)}`,
  );
}

function luhnChecksum(value: string): number {
  let accum = 0;
  const digits = value.split('').reverse();
  for (let i = 0; i < digits.length; i++) {
    let t = Number(digits[i]);
    if (i % 2 !== 0) t *= 2;
    if (t >= 10) t -= 9;
    accum += t;
  }
  return accum;
}
