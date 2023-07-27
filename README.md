# SwiftUI Window Reader

`SwiftUIWindowReader` adds the `WindowReader` module and `View` to your SwiftUI macOS app project — enabling functional access to the `NSWindow` in which your SwiftUI `View` is drawn. Access is provided prior to the first draw — ensuring that any visual changes you may apply to `NSWindow` do not cause a _flash of unstyled content_ (FOUC).

## Install

Add the package using Swift Package Manager:

```plaintext
https://github.com/stephancasas/SwiftUIWindowReader
```

## Usage

`WindowReader` uses syntax that is nearly identical to that of SwiftUI's built-in `GeometryReader`. Its implementation is most easily achieved by accepting an `NSWindow` in your `Scene`'s uppermost `View` initializer, and then wrapping that `View` in `WindowReader` to pass-in the `NSWindow` instance:

```swift
import SwiftUI;
import WindowReader;

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WindowReader {
                ContentView($0)
            }
        }
    }
}
```

### Auxiliary Callback

If your SwiftUI `View` doesn't require access to `NSWindow` but your application still needs to perform window-aware logic, you can provide an auxiliary callback to `WindowReader` in one of two ways:

#### Initializer

Provide the `using:` argument label to the `WindowReader` initializer:

```swift
import SwiftUI;
import WindowReader;

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WindowReader(using: { window in
                // Remove the window's full-screen button.
                window.standardWindowButton(
                    .zoomButton
                )?.isHidden = true;
            }) {
                ContentView()
            }
        }
    }
}
```

#### Modifier Function

Pin a call to `WindowReader.using(:)` immediately after the `WindowReader` initializer:

```swift
import SwiftUI;
import WindowReader;

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WindowReader {
                ContentView()
            }.using { window in
                // Remove the window's full-screen button.
                window.standardWindowButton(
                    .zoomButton
                )?.isHidden = true;
            }
        }
    }
}
```

## Contact

[Follow Stephan on Twitter](https://twitter.com/stephancasas)

## License

MIT
