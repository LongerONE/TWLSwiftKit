//
//  TWLSwiftKit.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/31.
//

import UIKit

let TWL_ScreenWidth = UIScreen.main.bounds.size.width
let TWL_ScreenHeight = UIScreen.main.bounds.size.height


func TWLDPrint(_ item: Any) {
    #if DEBUG
    print(item)
    #endif
}


var twlWindowWidth: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.width ?? 0.0
    }
    
    set {
        
    }
}

var twlWindowHeight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.bounds.size.height ?? 0.0
    }
    
    set {
        
    }
}


var twlWindowSafeLeft: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.left ?? 0.0
    }
    
    set {
        
    }
}

var twlWindowSafeRight: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.right ?? 0.0
    }
    
    set {
        
    }
}

var twlWindowSafeTop: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.top ?? 0.0
    }
    
    set {
        
    }
}

var twlWindowSafeBottom: CGFloat {
    get {
        return UIApplication.shared.twlKeyWindow?.safeAreaInsets.bottom ?? 0.0
    }
    
    set {
        
    }
}


extension UIApplication {
    var twlKeyWindow: UIWindow? {
        let scenes = connectedScenes
        return scenes.compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
}



