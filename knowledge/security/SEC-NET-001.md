# SEC-NET-001: TLS/SSL Certificate Verification Bypass

## Rule
Never override standard TLS/SSL certificate verification protocols to bypass certificate errors in production environments.

## Description
Overriding `badCertificateCallback` to return `true` instructs the HTTP client to trust any certificate provided by the server, regardless of signature validity, hostname matches, or expiry date.

## Why It Matters
This bypass completely defeats the security of HTTPS, leaving the application highly vulnerable to Man-In-The-Middle (MITM) attacks where attackers can hijack api requests, intercept auth tokens, or execute malicious endpoints.

## Bad Example
```dart
final client = HttpClient();
client.badCertificateCallback = (cert, host, port) => true;
```

## Good Example
Ensure your server certificate is issued by a globally recognized Certificate Authority (CA) and let the default secure client validate it automatically.

## Recommended Fix
Remove any assignments overriding `badCertificateCallback` in your Dio or HttpClient instances before deploying to production.

## Severity Guidance
- Critical: Bypassing transport layer certificate verification in production environments.
