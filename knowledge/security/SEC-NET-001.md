# SEC-NET-001: TLS/SSL Certificate Verification Bypass

## Rule
Never override standard TLS/SSL certificate verification protocols to bypass certificate errors in production environments.

## Description
Overriding badCertificateCallback to return true instructs the HTTP client to trust any certificate provided by the server, regardless of signature validity, hostname matches, or expiry date.

## Why It Matters
This bypass completely defeats the security of HTTPS, leaving the application highly vulnerable to Man-In-The-Middle (MITM) attacks where attackers can hijack API requests, intercept auth tokens, or execute malicious endpoints.

## Recommended Fix
Remove any assignments overriding badCertificateCallback in your Dio or HttpClient instances before deploying to production, or guard them strictly behind kDebugMode.

## Severity Guidance
- Critical: Bypassing transport layer certificate verification in production environments.
