//
//  TWLAlertView.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/21.
//

import UIKit

public class TWLAlertView: TWLView {

    var maskBtn: TWLButton = TWLButton(type: .custom)
    
    var maskAlpha = 0.72
    
    var canTapMaskDismss = false
    
    public func showCenterFade() {
        let window: UIWindow? = UIApplication.shared.twlKeyWindow
        self.maskBtn.alpha = 0.0
        self.maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
        window?.addSubview(self.maskBtn)
        self.maskBtn.frame = window?.bounds ?? .zero
        
        maskBtn.addSubview(self)
        self.center = maskBtn.center
        
        UIView.animate(withDuration: 0.3) {
            self.maskBtn.alpha = 1.0
        } completion: { _ in
            
        }
        
        self.maskBtn.touchUpInSideClosure = {[unowned self] _ in
            if self.canTapMaskDismss {
                self.dismiss()
            }
        }
    }
    
    
    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.maskBtn.alpha = 0.0
        } completion: { _ in
            self.maskBtn.removeFromSuperview()
        }
    }
    
    
    
    
}
