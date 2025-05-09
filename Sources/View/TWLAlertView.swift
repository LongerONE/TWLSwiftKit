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

enum TWLAlertAnimateType: Int {
    case fade
    case zoom
    case move
}


open class TWLAlertView: TWLView {
    
    private var position: TWLAlertPositionType = .center
    private var animateType: TWLAlertAnimateType = .fade
    
    public var maskAlpha = 0.72
    public var canTapMaskDismss = false
    public var adoptKeyboard = false
    public var keybordTopSpace: CGFloat = 20.0
    
    private var pendingKeyboardAdjustment: DispatchWorkItem?
    private var lastKeyboardHeight: CGFloat = 0
    private var dismissing = false
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChange(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidBeginEditingNotification(_:)),
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )
    }
    
    @MainActor
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    public class func showing(on: UIView? = nil) -> Bool {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return false}
        for subview in showView.subviews {
            if subview.isKind(of: TWLMaskBtn.self), let alertView = subview.subviews.first as? TWLAlertView {
                if alertView is Self {
                    if alertView.dismissing {
                        return false
                    }
                    return true
                }
            }
        }
        
        return false
    }
    
    public func showCenterFade(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .center
        animateType = .fade
        
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
        animateType = .move
        
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
        animateType = .move
        
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
    
    public func showCenterZoom(on: UIView? = nil) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .center
        animateType = .zoom
        
        let maskBtn = TWLMaskBtn(type: .custom)
        maskBtn.addTarget(self, action: #selector(maskTapAction), for: .touchUpInside)
        maskBtn.alpha = 0.0
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
        showView.addSubview(maskBtn)
        maskBtn.frame = showView.bounds
        
        maskBtn.addSubview(self)
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.center = maskBtn.center
        
        UIView.animate(
            withDuration: 0.9,
            delay: 0,
            usingSpringWithDamping: 0.5,   // 阻尼系数（0-1，越小弹性越强）
            initialSpringVelocity: 0.6,   // 初始速度
            options: .curveEaseInOut,
            animations: {
                maskBtn.alpha = 1
                self.alpha = 1
                self.transform = .identity
            },
            completion: nil
        )
    }
    
    @objc public func dismiss() {
        dismissing = true
        if position == .center, animateType == .zoom {
            UIView.animate(
                withDuration: 1.0,
                delay: 0,
                usingSpringWithDamping: 0.5,  // 更小的阻尼系数（弹性更强）
                initialSpringVelocity: 0.7,   // 更高的初始速度
                options: .curveEaseIn,
                animations: {
                    self.alpha = 0
                    self.superview?.alpha = 0
                    self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                },
                completion: { _ in
                    self.superview?.removeFromSuperview()
                }
            )
            return
        }
        
        
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
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        guard adoptKeyboard else { return }
        
        pendingKeyboardAdjustment?.cancel()
        
        let adjustmentTask = DispatchWorkItem { [weak self] in
            self?.adjustLayoutWithKeyboard(notification)
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1,
            execute: adjustmentTask
        )
        pendingKeyboardAdjustment = adjustmentTask
    }
    
    @objc private func textFieldDidBeginEditingNotification(_ note: Notification) {
        guard adoptKeyboard else { return }
        
        self.adjustScrollViewForKeyboard(duration: 0.3, curve: 3, keyboardHeight: lastKeyboardHeight)
    }
    
    private func adjustLayoutWithKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let convertedFrame = self.convert(keyboardFrame, from: nil)
        let keyboardHeight = max(self.bounds.maxY - convertedFrame.minY, 0)
        TWLDPrint("键盘高度：\(keyboardHeight)")
        guard abs(keyboardHeight - lastKeyboardHeight) > 1 else { return }
        self.adjustScrollViewForKeyboard(duration: duration, curve: curve, keyboardHeight: keyboardHeight)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard adoptKeyboard else { return }
        
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        self.adjustScrollViewForKeyboard(duration: duration, curve: curve, keyboardHeight: 0)
    }
    
    func adjustScrollViewForKeyboard(duration: TimeInterval, curve: UInt, keyboardHeight: CGFloat) {
        lastKeyboardHeight = keyboardHeight

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve << 16),
            animations: {
                if keyboardHeight == 0 {
                    if self.position == .center {
                        self.center = self.superview!.center
                    } else {
                        self.twl.y = TWLScreenHeight - self.twl.height + self.layer.cornerRadius
                    }
                } else {
                    if let responder = self.findFirstResponder(in: self), let window = UIApplication.shared.twlKeyWindow {
                        let frameOfScreen = responder.convert(responder.bounds, to: window)
                        if frameOfScreen.origin.y + frameOfScreen.size.height + self.keybordTopSpace > window.bounds.size.height - keyboardHeight {
                            let offSet = frameOfScreen.origin.y - (window.bounds.size.height - keyboardHeight - frameOfScreen.size.height  - self.keybordTopSpace)
                            if self.position == .center {
                                self.twl.y = (TWLScreenHeight - self.twl.height) * 0.5 - offSet
                            } else {
                                self.twl.y = TWLScreenHeight - self.twl.height + self.layer.cornerRadius - offSet
                            }
                        }
                    }
                }
            }
        )
    }
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        
        return nil
    }
    
    // 移除监听器
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
