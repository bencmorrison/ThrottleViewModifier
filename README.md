# ThrottleViewModifier

Prevents repeated taps on a SwiftUI view by temporarily disabling hit testing after the first tap. Useful for buttons that trigger async work, network requests, or navigation where double-tapping causes problems.

## Requirements

| Platform | Minimum Version |
|---|---|
| iOS / macCatalyst | 16.0 |
| macOS | 15.0 |
| watchOS | 9.0 |
| tvOS | 16.0 |
| visionOS | 1.0 |

Swift 6 (`swiftLanguageModes: [.v6]`)

## Installation

In Xcode: **File → Add Package Dependencies** and enter:

```
https://github.com/YOUR_USERNAME/ThrottleViewModifier
```

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/bencmorrison/ThrottleViewModifier", from: "1.0.0")
]
```

Then add `"ThrottleViewModifier"` to your target's dependencies.

## Usage

### `.throttled(delay:)`

Apply the modifier to any view. After the first tap, hit testing is disabled for the duration of the delay, then re-enables automatically.

```swift
Button("Save") {
    save()
}
.throttled(delay: .medium)
```

### `Delay`

| Case | Duration |
|---|---|
| `.short` | 100ms |
| `.medium` | 250ms |
| `.long` | 500ms |
| `.custom(Duration)` | Any `Duration` |

```swift
.throttled(delay: .short)
.throttled(delay: .long)
.throttled(delay: .custom(.milliseconds(750)))
```

### `isThrottled` environment value

`ThrottleViewModifier` sets `isThrottled` in the environment while the throttle window is active. Child views can read it to react — for example, dimming a label or showing a progress indicator.

```swift
struct SubmitLabel: View {
    @Environment(\.isThrottled) private var isThrottled

    var body: some View {
        Text("Submit")
            .opacity(isThrottled ? 0.5 : 1.0)
    }
}

Button { submit() } label: { SubmitLabel() }
    .throttled(delay: .medium)
```

This works at any depth in the view hierarchy beneath the modified view.

## How it works

On the first tap, the modifier fires a `TapGesture` via `simultaneousGesture`, sets `isThrottled = true`, and calls `allowsHitTesting(false)` on the view. A `Task` sleeps for the delay duration then resets the state. If the view disappears before the delay elapses the task is cancelled.
