import { describe, it, expect } from 'vitest';
import { isValidSiret, validateSiret } from '../src/siret.js';
import { InvalidSiretError } from '../src/errors.js';

describe('isValidSiret', () => {
  it('accepts a valid Luhn SIRET', () => {
    expect(isValidSiret('41816609600069')).toBe(true);
  });

  it('accepts a La Poste SIRET', () => {
    expect(isValidSiret('35600000012345')).toBe(true);
    expect(isValidSiret('35600000099999')).toBe(true);
  });

  it('rejects wrong length', () => {
    expect(isValidSiret('1234')).toBe(false);
    expect(isValidSiret('123456789012345')).toBe(false);
  });

  it('rejects non-digit characters', () => {
    expect(isValidSiret('4181660960006A')).toBe(false);
    expect(isValidSiret('abcdefghijklmn')).toBe(false);
  });

  it('rejects Luhn mismatch', () => {
    expect(isValidSiret('41816609600060')).toBe(false);
  });

  it('rejects empty string', () => {
    expect(isValidSiret('')).toBe(false);
  });

  it('rejects null', () => {
    expect(isValidSiret(null)).toBe(false);
  });

  it('rejects undefined', () => {
    expect(isValidSiret(undefined)).toBe(false);
  });
});

describe('validateSiret', () => {
  it('does not throw for a valid SIRET', () => {
    expect(() => validateSiret('41816609600069', 'recipient')).not.toThrow();
  });

  it('throws InvalidSiretError for invalid SIRET', () => {
    expect(() => validateSiret('invalid', 'recipient')).toThrow(
      InvalidSiretError,
    );
  });

  it('includes parameter name in message', () => {
    expect(() => validateSiret('1234', 'recipient')).toThrow(/recipient/);
  });
});
