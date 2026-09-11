//
//  TWLSwiftKit.swift
//

import UIKit

@MainActor
public let TWLScreenWidth = UIScreen.main.bounds.size.width
@MainActor
public let TWLScreenHeight = UIScreen.main.bounds.size.height
@MainActor
public let TWLScreenScale = UIScreen.main.scale
@MainActor
public let TWLOnePixelHeight = 1.0 / UIScreen.main.scale


public func TWLDPrint(_ item: Any) {
    #if DEBUG
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
    let dateString = formatter.string(from: Date())
    print("\(dateString) [TWLSwiftKit]\n\(item)")
    #endif
}

@MainActor
public extension UIApplication {
    var twlKeyWindow: UIWindow? {
        let windowScenes = connectedScenes.compactMap { $0 as? UIWindowScene }
        let foregroundScenes = windowScenes.filter {
            $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
        }

        return foregroundScenes.lazy.compactMap {
            $0.windows.first(where: \.isKeyWindow)
        }.first ?? windowScenes.lazy.compactMap {
            $0.windows.first(where: \.isKeyWindow)
        }.first
    }
}


@MainActor
public var twlWindowWidth: CGFloat {
    UIApplication.shared.twlKeyWindow?.bounds.width ?? 0
}

@MainActor
public var twlWindowHeight: CGFloat {
    UIApplication.shared.twlKeyWindow?.bounds.height ?? 0
}

@MainActor
public var twlWindowSafeLeft: CGFloat {
    UIApplication.shared.twlKeyWindow?.safeAreaInsets.left ?? 0
}

@MainActor
public var twlWindowSafeRight: CGFloat {
    UIApplication.shared.twlKeyWindow?.safeAreaInsets.right ?? 0
}

@MainActor
public var twlWindowSafeTop: CGFloat {
    UIApplication.shared.twlKeyWindow?.safeAreaInsets.top ?? 0
}

@MainActor
public var twlWindowSafeBottom: CGFloat {
    UIApplication.shared.twlKeyWindow?.safeAreaInsets.bottom ?? 0
}




@MainActor
public var twlStatusBarHeight: CGFloat {
    guard let window = UIApplication.shared.twlKeyWindow,
          let statusBarManager = window.windowScene?.statusBarManager else {
        return 0
    }

    return statusBarManager.statusBarFrame.height
}


public func twlTaskSleep(seconds: Float) async {
    guard seconds.isFinite, seconds > 0 else { return }

    let nanoseconds = Double(seconds) * 1_000_000_000
    guard nanoseconds < Double(UInt64.max) else { return }

    try? await Task.sleep(nanoseconds: UInt64(nanoseconds))
}
