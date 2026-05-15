import { describe, it, expect } from 'vitest';
import { isValidSiren, validateSiren } from '../src/siren.js';
import { InvalidSirenError } from '../src/errors.js';

describe('isValidSiren', () => {
  it('accepts a valid Luhn SIREN', () => {
    expect(isValidSiren('418166096')).toBe(true);
  });

  it('accepts a La Poste SIREN', () => {
    expect(isValidSiren('356000000')).toBe(true);
  });

  it('rejects wrong length', () => {
    expect(isValidSiren('1234')).toBe(false);
    expect(isValidSiren('1234567890')).toBe(false);
  });

  it('rejects non-digit characters', () => {
    expect(isValidSiren('41816609A')).toBe(false);
  });

  it('rejects Luhn mismatch', () => {
    expect(isValidSiren('418166097')).toBe(false);
  });

  it('rejects empty string', () => {
    expect(isValidSiren('')).toBe(false);
  });

  it('rejects null', () => {
    expect(isValidSiren(null)).toBe(false);
  });

  it('rejects undefined', () => {
    expect(isValidSiren(undefined)).toBe(false);
  });
});

describe('validateSiren', () => {
  it('does not throw for a valid SIREN', () => {
    expect(() => validateSiren('418166096', 'siren')).not.toThrow();
  });

  it('throws InvalidSirenError for invalid SIREN', () => {
    expect(() => validateSiren('invalid', 'siren')).toThrow(InvalidSirenError);
  });
});
