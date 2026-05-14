export interface AuthStrategy {
  apply(headers: Record<string, string>): void;
}
