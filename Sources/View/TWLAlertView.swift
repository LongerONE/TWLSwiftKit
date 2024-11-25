//
//  TWLAlertView.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/21.
//

import UIKit

open class TWLAlertView: TWLView {
    
    public var maskAlpha = 0.72
    
    public var canTapMaskDismss = false
    
    public func showCenterFade(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        
        let maskBtn = UIButton(type: .custom)
        maskBtn.addTarget(self, action: #selector(maskTapAction), for: .touchUpInside)
        maskBtn.alpha = 0.0
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
        showView.addSubview(maskBtn)
        maskBtn.frame = showView.bounds
        
        maskBtn.addSubview(self)
        self.center = maskBtn.center
        
        UIView.animate(withDuration: 0.3) {
            maskBtn.alpha = 1.0
        }
    }
    
    
    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.superview?.alpha = 0.0
        } completion: { _ in
            self.superview?.removeFromSuperview()
        }
    }
    
    
    @objc func maskTapAction() {
        if canTapMaskDismss {
            dismiss()
        }
    }
    
}
