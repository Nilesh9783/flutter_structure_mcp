# Custom Navigation Extensions

This project is configured to use custom navigation extensions defined on `BuildContext` instead of third-party routing packages like GoRouter or AutoRoute.

## How to Use

You can perform navigation directly using the `BuildContext` helper extensions:

```dart
// Navigate to a new screen
context.navigateTo(const DetailScreen());

// Navigate back
context.navigateBack();

// Navigate back with parameters
context.navigatorBackWithParam(value: 'result');

// Navigate to a screen and await result
final result = await context.navigateToWithReturn(const FilterScreen());
```

These extensions are defined in `lib/shared/utils/extensions/buildcontext_extension.dart`.
