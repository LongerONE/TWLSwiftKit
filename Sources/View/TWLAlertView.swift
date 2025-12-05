//
//  TWLAlertView.swift
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
    public var keyboardTopSpace: CGFloat = 20.0
    public var bottomOffset: CGFloat = 0
    
    private var pendingKeyboardAdjustment: DispatchWorkItem?
    private var lastKeyboardHeight: CGFloat = 0
    
    public var dismissing = false
    
    public var dismissClosure: () -> Void = {}
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
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
        self.updateFrame()
        
        UIView.animate(withDuration: 0.3) {
            maskBtn.alpha = 1.0
        }
    }
    
    public func showBottom(on: UIView? = nil, animate: Bool = true) {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return }
        position = .bottom
        animateType = .move
        
        let maskBtn = TWLMaskBtn(type: .custom)
        maskBtn.addTarget(self, action: #selector(maskTapAction), for: .touchUpInside)
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        showView.addSubview(maskBtn)
        maskBtn.frame = showView.bounds
        
        maskBtn.addSubview(self)
        self.updateFrame(animate: animate)
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
        self.updateFrame()
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
                self.transform = .identity
            },
            completion: nil
        )
  
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
        UIView.animate(withDuration: 0.3) {
            maskBtn.alpha = 1
        }
    }
    
    public func updateFrame(animate: Bool = true) {
        guard let maskBtn = self.superview else { return }
        switch position {
        case .center:
            self.center = maskBtn.center
        case .bottom:
            self.twl.x = (maskBtn.twl.width - self.twl.width) * 0.5
            self.twl.y = maskBtn.twl.height
            
            if animate {
                UIView.animate(withDuration: 0.3) {
                    maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
                    self.twl.y = maskBtn.twl.height - self.twl.height + self.layer.cornerRadius - self.bottomOffset
                }
            } else {
                maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
                self.twl.y = maskBtn.twl.height - self.twl.height + self.layer.cornerRadius - self.bottomOffset
            }
        case .top:
            self.twl.x = (maskBtn.twl.width - self.twl.width) * 0.5
            self.twl.y = -self.twl.height
            
            UIView.animate(withDuration: 0.3) {
                maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
                self.twl.y = 0
            }
        }
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
                    self.dismissClosure()
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
            self.dismissClosure()
            self.superview?.removeFromSuperview()
        }
    }
    
    @objc open func maskTapAction() {
        if canTapMaskDismss {
            dismiss()
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard adoptKeyboard else { return }
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let convertedFrame = self.convert(keyboardFrame, from: nil)
        let keyboardHeight = convertedFrame.size.height
        TWLDPrint("键盘高度：\(keyboardHeight)")
        
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
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve << 16),
            animations: {
                // 获取主窗体和当前焦点控件
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                if keyboardHeight == 0 {
                    // 键盘收起，恢复到初始位置
                    if self.position == .center {
                        self.center = self.superview!.center
                    } else {
                        self.twl.y = TWLScreenHeight - self.twl.height + self.layer.cornerRadius - self.bottomOffset
                    }
                } else {
                    if let responder = self.findFirstResponder(in: self) {
                        let frameOfScreen = responder.convert(responder.bounds, to: window)
                        let overlap = frameOfScreen.maxY + self.keyboardTopSpace - (window.bounds.height - keyboardHeight)
                        var newY: CGFloat
                        if self.position == .center {
                            // 计算上移后的位置，并防止越界到屏幕顶部
                            newY = (TWLScreenHeight - self.twl.height) * 0.5 - overlap
                            newY = max(0, newY)
                            self.twl.y = newY
                        } else {
                            newY = self.twl.y - overlap
                            // 也不要越界到屏幕顶部
                            self.twl.y = max(0, newY)
                        }
                    } else {
                        // 没有焦点控件，恢复
                        if self.position == .center {
                            self.center = self.superview!.center
                        } else {
                            self.twl.y = TWLScreenHeight - self.twl.height + self.layer.cornerRadius - self.bottomOffset
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
