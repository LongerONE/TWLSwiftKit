//
//  TWLAlertView.swift
//  Temby
//
//  Created by 唐万龙 on 2023/6/21.
//

import UIKit


enum TWLAlertPositionType: Int {
    case center
    case bottom
}


open class TWLAlertView: TWLView {
    
    private var position: TWLAlertPositionType = .center
    
    public var maskAlpha = 0.72
    
    public var canTapMaskDismss = false
    
    public func showCenterFade(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .center
        
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
    
    
    public func showBottom(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .bottom
        
        let maskBtn = UIButton(type: .custom)
        maskBtn.addTarget(self, action: #selector(maskTapAction), for: .touchUpInside)
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        showView.addSubview(maskBtn)
        maskBtn.frame = showView.bounds
        
        maskBtn.addSubview(self)
        self.twl.x = (maskBtn.twl.width - self.twl.width) * 0.5
        self.twl.y = maskBtn.twl.height
        
        UIView.animate(withDuration: 0.3) {
            maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
            self.twl.y = maskBtn.twl.height - self.twl.height + self.layer.cornerRadius
        }
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            if self.position == .center {
                self.superview?.alpha = 0.0
            } else {
                self.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.twl.y = self.superview?.twl.height ?? TWLScreenHeight
            }
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
