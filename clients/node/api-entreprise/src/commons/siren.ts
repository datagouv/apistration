// DO NOT EDIT — generated from clients/node/commons/src/ (source digest: 0e0562f6390b0271a673ad0215dabe7c7443c19d).
// Regenerate via clients/node/bin/sync-commons.ts

import { InvalidSirenError } from './errors.js';

const DIGITS_9 = /^\d{9}$/;
const LA_POSTE_PATTERN = /^356000000$/;

export function isValidSiren(value: string | null | undefined): boolean {
  if (value == null) return false;
  const str = String(value);
  if (!DIGITS_9.test(str)) return false;
  if (LA_POSTE_PATTERN.test(str)) return true;
  return luhnChecksum(str) % 10 === 0;
}

export function validateSiren(
  value: string | null | undefined,
  parameter: string,
): void {
  if (isValidSiren(value)) return;
  throw new InvalidSirenError(
    `${parameter} must be a 9-digit SIREN passing the Luhn checksum; got ${JSON.stringify(value)}`,
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
