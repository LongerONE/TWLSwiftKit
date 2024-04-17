//
//  TWLSwiftKit.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/31.
//

import UIKit

public let TWL_ScreenWidth = UIScreen.main.bounds.size.width
public let TWL_ScreenHeight = UIScreen.main.bounds.size.height


public func TWLDPrint(_ item: Any) {
    #if DEBUG
    print(item)
    #endif
}


public var twlWindowWidth: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.width ?? 0.0
    }
    
    set {
        
    }
}

public var twlWindowHeight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.height ?? 0.0
    }
    
    set {
        
    }
}


public var twlWindowSafeLeft: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.left ?? 0.0
    }
    
    set {
        
    }
}

public var twlWindowSafeRight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.right ?? 0.0
    }
    
    set {
        
    }
}

public var twlWindowSafeTop: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.top ?? 0.0
    }
    
    set {
        
    }
}

public var twlWindowSafeBottom: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.bottom ?? 0.0
    }
    
    set {
        
    }
}


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



