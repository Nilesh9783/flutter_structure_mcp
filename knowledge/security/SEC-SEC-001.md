# SEC-SEC-001: Hardcoded Secrets

## Rule
Do not store credentials, API keys, private keys, or passwords in plain text within source code files or configurations.

## Description
Hardcoded credentials are static values compiled directly into the application package. If someone decompiles or reverse-engineers the application, they can extract and exploit these sensitive keys.

## Why It Matters
Exposing sensitive API keys or credentials can allow unauthorized access to backend databases, server integrations, cloud infrastructure, or user data, leading to severe security breaches and financial liabilities.

## Recommended Fix
Remove hardcoded credentials from code. Use environment variables (.env / --dart-define) during build, or retrieve keys dynamically from a secure vault or encrypted storage at runtime.

## Severity Guidance
- Critical / High: If credentials allow write access or sensitive data read capabilities.
- Medium: If keys are restricted public keys but still committed in clear text.
