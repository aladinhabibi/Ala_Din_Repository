Step 1.4: Conditional compilation
=================================

**Estimated time**: 1 day

> Dart’s compiler technology lets you run code in different ways:
> - **Native platform**: For apps targeting mobile and desktop devices, Dart includes both a Dart VM with just-in-time (JIT) compilation and an ahead-of-time (AOT) compiler for producing machine code.
> - **Web platform**: For apps targeting the web, Dart can compile for development or production purposes. Its web compiler translates Dart into JavaScript.

When compiling [Dart] to web or natively, the following must be accounted:
1. Some libraries are unavailable when running either in browser or natively.  
   Examples:
    - [`dart:io`]: direct [I/O] operations are not supported in browser due to its [sandbox restrictions][1];
    - [`dart:html`]/[`dart:js`]: native platforms don't work with [HTML] or [JavaScript].
2. Some classes may have additional implementation notes and features.  
   Examples:
    - [`DateTime`] supports [no microseconds in browser][2], because the [`Date`] object in [JavaScript], used under-the-hood when compiling to web, doesn't provide them.

> If your library supports multiple platforms, then you might need to conditionally import or export library files. A common use case is a library that supports both web and native platforms.
>
> To conditionally import or export, you need to check for the presence of `dart:*` libraries. Here’s an example of conditional export code that checks for the presence of `dart:io` and `dart:html`:
> ```dart
> export 'src/hw_none.dart' // Stub implementation
>     if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
>     if (dart.library.html) 'src/hw_html.dart'; // dart:html implementation
> ```
> Here’s what that code does:
> - In an app that can use `dart:io` (for example, a command-line app), export `src/hw_io.dart`.
> - In an app that can use `dart:html` (a web app), export `src/hw_html.dart`.
> - Otherwise, export `src/hw_none.dart`.
>
> To conditionally import a file, use the same code as above, but change `export` to `import`.

The following files layout may be considered for separating code of different platforms:
```
lib/
├── src/
│   ├── interface.dart
│   ├── io.dart
│   └── web.dart
└── package.dart
```

To learn more about conditional compilation in [Dart], read through the following articles:
- [Dart overview][3]
- [Dart Docs: Web platform][4]
- [Dart Guides: Conditionally importing and exporting library files][5]
- [Gonçalo Palma: Conditional Importing - How to compile for all platforms in Flutter][6]
- [Vyacheslav Egorov: Introduction to Dart VM][7]




## Task

Create a native and web implementations for a custom `DateTime` type, supporting microseconds (unlike the standard [`DateTime`], which [doesn't on web][2]). Use conditional compilation to export the class for general use on any platform.




## Questions

After completing everything above, you should be able to answer (and understand why) the following questions:
- How [Dart] compiles to and works on native platforms? In web?
- What is [Dart] VM? How does it work?
- Why may some libraries be unavailable in web or natively?
- How to check whether [Dart] supports a library on the platform it compiles on?

## Answers

### How Dart compiles to and works on native platforms? In web?

**Native Platforms:**
- Dart uses **AOT (Ahead-of-Time) compilation** for production builds, compiling Dart code directly to native machine code
- During development, Dart uses **JIT (Just-in-Time) compilation** with the Dart VM for faster iteration and hot reload
- Native builds can access platform-specific APIs through libraries like `dart:io` for file system, networking, and process management
- The compiled code runs directly on the target platform (iOS, Android, Windows, macOS, Linux) without requiring a runtime environment

**Web Platform:**
- Dart compiles to **JavaScript** using the `dart2js` compiler for production builds
- For development, Dart uses **dartdevc** (Dart development compiler) which provides faster compilation and better debugging
- Web builds are constrained by browser security models and can only access web APIs through libraries like `dart:html` and `dart:js`
- The compiled JavaScript runs in the browser's JavaScript engine

### What is Dart VM? How does it work?

The **Dart VM** is a virtual machine that executes Dart code with the following characteristics:

- **JIT Compilation**: During development, it compiles Dart source code to bytecode and then to optimized machine code at runtime
- **Garbage Collection**: Manages memory automatically with a generational garbage collector
- **Isolates**: Provides lightweight, independent execution contexts that don't share memory (similar to threads but safer)
- **Hot Reload**: Allows code changes to be injected into running applications without losing state
- **Snapshots**: Can create snapshots of compiled code and application state for faster startup times

The VM works by:
1. Parsing Dart source code into an Abstract Syntax Tree (AST)
2. Converting AST to bytecode
3. Optimizing frequently executed code paths
4. Managing memory and isolates

### Why may some libraries be unavailable in web or natively?

**Security and Platform Constraints:**
- **Web**: Browser sandbox restrictions prevent direct file system access, process spawning, or raw socket connections
- **Native**: Cannot access browser-specific APIs like DOM manipulation or web storage

**Technical Limitations:**
- **Web**: Some native features have no web equivalent (e.g., direct file I/O, system processes)
- **Native**: Web APIs don't exist outside browsers (e.g., `dart:html`, `dart:js`)

**Implementation Differences:**
- Some features work differently across platforms (e.g., `DateTime` microseconds support)
- Performance characteristics may vary (e.g., JavaScript's single-threaded nature vs native multi-threading)

### How to check whether Dart supports a library on the platform it compiles on?

**Conditional Imports/Exports:**
```dart
// Check for dart:io availability (native platforms)
import 'implementation_stub.dart'
    if (dart.library.io) 'implementation_io.dart'
    if (dart.library.html) 'implementation_web.dart';
```

**Runtime Checks:**
```dart
import 'dart:io' if (dart.library.html) 'dart:html';

bool get isWeb => identical(0, 0.0); // Compile-time constant check
bool get isNative => !isWeb;
```

**Platform Detection Methods:**
- Use `dart.library.*` conditions for compile-time platform detection
- Use `kIsWeb` constant from `package:flutter/foundation.dart` in Flutter apps
- Check for specific library availability using conditional imports
- Use platform-specific feature detection rather than platform detection when possible
