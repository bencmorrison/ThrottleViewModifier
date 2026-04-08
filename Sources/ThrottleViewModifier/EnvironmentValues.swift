// Copyright © 2026 Ben Morrison. All rights reserved.

import SwiftUI

extension EnvironmentValues {
  /// Indicates whether the nearest ancestor view is currently throttled.
  ///
  /// `ThrottleViewModifier` writes `true` to this key for the duration of the
  /// throttle window, then resets it to `false`. Child views can read this value
  /// to visually reflect the disabled state while taps are suppressed.
  ///
  /// Defaults to `false`.
  @Entry public var isThrottled: Bool = false
}
