//
//  TWLBaseAlertView.swift
//  Temby
//
//  Created by 唐万龙 on 2023/8/1.
//

import UIKit

open class TWLBaseAlertView: TWLView {

    public var maskAlpha: CGFloat = 0.0
    public var touchDismiss = false
    public var cancelClosure:() -> Void = {}
    
    func show(from: UIView?, on: UIView? = nil) {
        let maskBtn = TWLButton(type: .custom)
        let window = on != nil ? on : UIApplication.shared.twlKeyWindow
        if on != nil {
            window?.transform = on!.transform
        }
        window?.addSubview(maskBtn)
        maskBtn.alpha = 0.0
        maskBtn.frame = window?.bounds ?? CGRect.zero
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
        maskBtn.touchUpInSideClosure = {[weak self] btn in
            if self?.touchDismiss == true {
                self?.cancelClosure()
                self?.dismiss()
            }
        }
        
        if from != nil {
            let postion = maskBtn.convert(from!.frame, from: from!.superview)
            
            self.twl.x = postion.origin.x + postion.size.width * 0.5 - self.twl.width * 0.5
            
            self.twl.x = max(self.twl.x, 10.0)
            let maxRight = maskBtn.twl.width - twlWindowSafeRight - self.twl.width - 10
            self.twl.x = min(maxRight, self.twl.x)
            
            if postion.origin.y + postion.size.height + self.twl.height + 10 > maskBtn.frame.size.height {
                // 超出下边界
                self.twl.y = postion.origin.y - self.twl.height - 10
            } else {
                self.twl.y = postion.origin.y + postion.size.height + 10
            }
        } else {
            self.center = maskBtn.center
        }

        
        maskBtn.addSubview(self)
        UIView.animate(withDuration: 0.3, delay: 0) {
            maskBtn.alpha = 1.0
        }
    }
    
    
    func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.superview?.alpha = 0.0
        } completion: { _ in
            self.superview?.removeFromSuperview()
        }
    }
}
