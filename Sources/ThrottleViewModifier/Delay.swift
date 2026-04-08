// Copyright © 2026 Ben Morrison. All rights reserved.

/// Defines how long hit testing remains disabled after a throttled tap.
///
/// Use one of the preset cases for common durations, or `.custom` when you need
/// precise control over the throttle window.
public enum Delay: Sendable {
  /// 100 millisecond delay.
  case short
  /// 250 millisecond delay.
  case medium
  /// 500 millisecond delay.
  case long
  /// A custom delay duration.
  ///
  /// - Parameter duration: The exact `Duration` to use as the throttle window.
  case custom(Duration)

  /// The resolved `Duration` value for this delay case.
  ///
  /// Used internally by `ThrottleViewModifier` to drive `Task.sleep(for:)`.
  var duration: Duration {
    switch self {
    case .short: return .milliseconds(100)
    case .medium: return .milliseconds(250)
    case .long: return .milliseconds(500)
    case .custom(let duration): return duration
    }
  }
}
