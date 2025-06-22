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
        get {
            if #available(iOS 13.0, *) {
                let scenes = connectedScenes
                if scenes.count > 0 {
                    return scenes.compactMap { $0 as? UIWindowScene }
                        .first?.windows
                        .filter { $0.isKeyWindow }
                        .first
                } else {
                    return self.keyWindow
                }
            } else {
                return self.keyWindow
            }
        }
    }
}


@MainActor
public var twlWindowWidth: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.width ?? 0.0
    }
}

@MainActor
public var twlWindowHeight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.height ?? 0.0
    }
}

@MainActor
public var twlWindowSafeLeft: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.left ?? 0.0
    }
}

@MainActor
public var twlWindowSafeRight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.right ?? 0.0
    }
}

@MainActor
public var twlWindowSafeTop: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.top ?? 0.0
    }
}

@MainActor
public var twlWindowSafeBottom: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.bottom ?? 0.0
    }
}




@MainActor
public var twlStatusBarHeight: CGFloat {
    get {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            return statusBarHeight
        }
        
        return UIApplication.shared.statusBarFrame.height
    }
}
