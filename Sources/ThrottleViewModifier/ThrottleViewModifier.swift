// Copyright © 2026 Ben Morrison. All rights reserved.

import SwiftUI

/// A `ViewModifier` that prevents repeated tap input by temporarily disabling hit testing.
///
/// On the first tap, `ThrottleViewModifier` disables hit testing on the modified view for
/// the duration specified by `delay`. Once the delay elapses the view accepts taps again.
/// The current throttle state is also propagated via `EnvironmentValues.isThrottled` so
/// descendant views can react to it (e.g. to dim a button).
///
/// Any in-flight throttle task is cancelled when the view disappears, preventing stale
/// state updates after the view leaves the hierarchy.
///
/// Prefer the ``View/throttled(delay:)`` convenience modifier over constructing this type directly.
public struct ThrottleViewModifier: ViewModifier {
  /// The delay applied after each tap before the view accepts input again.
  public let delay: Delay
  @State private var isThrottled: Bool = false
  @State private var throttleTask: Task<Void, Never>?

  /// Creates a `ThrottleViewModifier` with the given delay.
  ///
  /// - Parameter delay: The throttle window duration. Hit testing is disabled for this
  ///   length of time after each tap.
  public init(delay: Delay) {
    self.delay = delay
  }

  public func body(content: Content) -> some View {
    content
      .environment(\.isThrottled, isThrottled)
      .allowsHitTesting(!isThrottled)
      .simultaneousGesture(
        TapGesture().onEnded {
          guard !isThrottled else { return }
          isThrottled = true
          throttleTask?.cancel()
          throttleTask = Task { @MainActor in
            try? await Task.sleep(for: delay.duration)
            guard !Task.isCancelled else { return }
            isThrottled = false
          }
        }
      )
      .onDisappear {
        throttleTask?.cancel()
      }
  }
}

// MARK: Preview

@available(iOS 17.0, *)
#Preview {
  @Previewable @State var count: Int = 0

  VStack {
    Text("Press Count: \(count)")
    Button("Test Button") {
      count += 1
    }
    .throttled(delay: .medium)
    .buttonStyle(.borderedProminent)
  }
  .padding()
}
