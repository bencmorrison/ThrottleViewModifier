// Copyright © 2026 Ben Morrison. All rights reserved.

import SwiftUI

extension View {

  /// Throttles tap input on this view by temporarily disabling hit testing after each tap.
  ///
  /// Applies a ``ThrottleViewModifier`` that suppresses further taps for the duration
  /// of `delay` each time the view is tapped. The current throttle state is available
  /// to descendant views via `EnvironmentValues.isThrottled`.
  ///
  /// - Parameter delay: How long hit testing is disabled after a tap.
  /// - Returns: A view that ignores taps during the throttle window.
  public func throttled(delay: Delay) -> some View {
    modifier(ThrottleViewModifier(delay: delay))
  }
}
