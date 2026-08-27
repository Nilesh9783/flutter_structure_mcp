# SEC-SEC-001: Hardcoded Secrets

## Rule
Do not store credentials, API keys, private keys, or passwords in plain text within source code files or configurations.

## Description
Hardcoded credentials are static values that get compiled directly into the application package. If someone decompiles or reverse-engineers the application, they can recover these secrets.

## Why It Matters
Exposing sensitive API keys or credentials can allow unauthorized access to backend databases, server integrations, cloud infrastructure, or user data, leading to severe security breaches and financial liabilities.

## Bad Example
```dart
const String stripeApiKey = "sk_live_51H...";
```

## Good Example
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
final stripeKey = await storage.read(key: 'stripe_api_key');
```

## Recommended Fix
Remove hardcoded credentials from code. Use environment variables during the build process, or retrieve keys dynamically from a secure vault or backend service at runtime.

## Severity Guidance
- High: If credentials allow write access or sensitive data read capabilities.
- Medium: If keys are restricted public keys (like Google Maps) but still hardcoded in clear text.
