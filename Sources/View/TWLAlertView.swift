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
    case top
}


open class TWLAlertView: TWLView {
    
    private var position: TWLAlertPositionType = .center
    
    public var maskAlpha = 0.72
    public var canTapMaskDismss = false
    public var adoptKeyboard = false
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @MainActor
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    public class func showing(on: UIView? = nil) -> Bool {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return false}
        for subview in showView.subviews {
            if subview.isKind(of: TWLMaskBtn.self), let alertView = subview.subviews.first {
                if alertView is Self {
                    return true
                }
            }
        }
        
        return false
    }
    
    public func showCenterFade(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .center
        
        let maskBtn = TWLMaskBtn(type: .custom)
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
        
        let maskBtn = TWLMaskBtn(type: .custom)
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
    
    public func showTop(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .top
        
        let maskBtn = TWLMaskBtn(type: .custom)
        maskBtn.addTarget(self, action: #selector(maskTapAction), for: .touchUpInside)
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        showView.addSubview(maskBtn)
        maskBtn.frame = showView.bounds
        
        maskBtn.addSubview(self)
        self.twl.x = (maskBtn.twl.width - self.twl.width) * 0.5
        self.twl.y = -self.twl.height
        
        UIView.animate(withDuration: 0.3) {
            maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
            self.twl.y = 0
        }
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            if self.position == .center {
                self.superview?.alpha = 0.0
            } else if self.position == .bottom {
                self.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.twl.y = self.superview?.twl.height ?? TWLScreenHeight
            } else {
                self.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.twl.y = -self.twl.height
            }
        } completion: { _ in
            self.superview?.removeFromSuperview()
        }
    }
    
    
    @objc open func maskTapAction() {
        if canTapMaskDismss {
            dismiss()
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            adjustScrollViewForKeyboard(show: true, keyboardHeight: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        adjustScrollViewForKeyboard(show: false, keyboardHeight: 0)
    }
    
    func adjustScrollViewForKeyboard(show: Bool, keyboardHeight: CGFloat) {
        guard adoptKeyboard else { return }
        UIView.animate(withDuration: 0.5) {
            if keyboardHeight == 0 {
                if self.position == .center {
                    self.center = self.superview!.center
                } else {
                    self.twl.y = (self.superview?.twl.height ?? 0.0) - self.twl.height + self.layer.cornerRadius
                }
            } else {
                if (TWLScreenHeight - self.twl.height) * 0.5 < keyboardHeight {
                    let offset = keyboardHeight - (TWLScreenHeight - self.twl.height) * 0.5
                    self.twl.y = (TWLScreenHeight - self.twl.height) * 0.5  - offset - 10
                }
            }
        }
    }
    
    // 移除监听器
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
