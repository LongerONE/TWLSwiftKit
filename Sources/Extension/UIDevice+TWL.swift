//
//  UIDevice+TWL.swift
//  TWLSwiftKit
//
//  Created by 唐万龙 on 2026/5/31.
//

import UIKit


@MainActor
public extension UIDevice {
    @MainActor
    struct TWLUIDeviceClassExStruct {
        public static var statusHeight: CGFloat {
            let activeScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first {
                    $0.activationState == .foregroundActive ||
                    $0.activationState == .foregroundInactive
                }

            let window = UIApplication.shared.twlKeyWindow ?? activeScene?.windows.first
            let safeAreaTop = window?.safeAreaInsets.top ?? 0
            if safeAreaTop > 0 {
                return safeAreaTop
            }

            return activeScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
    }
    
    static var twl: TWLUIDeviceClassExStruct.Type { TWLUIDeviceClassExStruct.self }
}
