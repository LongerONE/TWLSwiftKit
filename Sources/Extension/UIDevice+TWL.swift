//
//  UIDevice+TWL.swift
//  TWLSwiftKit
//
//  Created by 唐万龙 on 2026/5/31.
//

import UIKit


public extension UIDevice {
    public struct TWLUIDeviceClassExStruct {
        public static var statusHeight: CGFloat {
            if #available(iOS 15.0, *) {
                // 1. 获取当前活跃的 WindowScene
                let activeScene = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first as? UIWindowScene
                
                // 2. 扩大查找范围，优先获取真正的 keyWindow
                let window = activeScene?.windows.first(where: { $0.isKeyWindow })
                    ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                    ?? activeScene?.windows.first
                
                let topPadding = window?.safeAreaInsets.top ?? 0
                
                // 3. 如果安全区域没好，或者拿到了非刘海屏的 0，尝试用 statusBarManager 兜底
                if topPadding == 0 {
                    let managerHeight = activeScene?.statusBarManager?.statusBarFrame.height ?? 0
                    // 如果 managerHeight 也是 0，返回常见默认高度（非刘海屏 20，刘海屏一般由 safeArea 决定）
                    return managerHeight > 0 ? managerHeight : 20
                }
                return topPadding
            } else if #available(iOS 13.0, *) {
                let activeScene = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first as? UIWindowScene
                return activeScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
    }
    
    static var twl: TWLUIDeviceClassExStruct.Type { return TWLUIDeviceClassExStruct.self }
}
