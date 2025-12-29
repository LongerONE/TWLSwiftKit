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
    private var originalY: CGFloat?
    private var originalCenter: CGPoint?
    
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
    
    public class func showingAlertView(on: UIView? = nil) -> Self? {
        guard let showView = on != nil ? on : UIApplication.shared.twlKeyWindow else { return nil }
        for subview in showView.subviews {
            if subview.isKind(of: TWLMaskBtn.self), let alertView = subview.subviews.first as? Self {
                if alertView is Self {
                    return alertView
                }
            }
        }
        return nil
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
        
        self.adjustPositionForKeyboard(keyboardHeight: keyboardHeight, duration: duration, curve: curve)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard adoptKeyboard else { return }
        
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        self.adjustPositionForKeyboard(keyboardHeight: 0, duration: duration, curve: curve)
    }
    
    func adjustPositionForKeyboard(keyboardHeight: CGFloat, duration: TimeInterval, curve: UInt) {
        // 获取主窗体
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        if keyboardHeight > 0 {
            if self.position == .center {
                if originalCenter == nil { originalCenter = self.center }
            } else {
                if originalY == nil { originalY = self.twl.y }
            }
        }

        // 设置动画选项，增加 .beginFromCurrentState 以平滑衔接多次触发
        let animOptions = UIView.AnimationOptions(rawValue: (curve << 16) | UIView.AnimationOptions.beginFromCurrentState.rawValue)

        UIView.animate(withDuration: duration, delay: 0, options: animOptions, animations: {
            if keyboardHeight <= 0 {
                // --- 步骤 B: 恢复逻辑 ---
                if let orgCenter = self.originalCenter, self.position == .center {
                    self.center = orgCenter
                } else if let orgY = self.originalY {
                    self.twl.y = orgY
                }
                // 清减备份，以便下次弹出时重新计算（适配屏幕旋转等）
                self.originalCenter = nil
                self.originalY = nil
                
            } else {
                // --- 步骤 C: 计算位移 ---
                guard let responder = self.findFirstResponder(in: self) else { return }
                
                // 获取输入框在窗口中的当前位置
                let frameInWindow = responder.convert(responder.bounds, to: window)
                
                // 计算键盘顶部的 Y 坐标
                let keyboardTopY = window.bounds.height - keyboardHeight
                
                // 计算当前输入框底部距离键盘顶部的距离（加上间距）
                // 注意：这里需要考虑视图可能已经为了避让键盘移动了一部分
                let currentBottom = frameInWindow.maxY + self.keyboardTopSpace
                let overlap = currentBottom - keyboardTopY
                
                // 只有当遮挡了，或者已经处于偏移状态时才调整
                if overlap > 0 || self.isAlreadyOffset() {
                    var targetY: CGFloat
                    
                    if self.position == .center {
                        // 基于当前位置继续上移
                        targetY = self.twl.y - overlap
                    } else {
                        targetY = self.twl.y - overlap
                    }
                    
                    // 边界保护：不能超出屏幕顶部
                    self.twl.y = max(0, targetY)
                }
            }
        }, completion: nil)
    }

    // 辅助方法：判断当前是否已经发生了偏移
    private func isAlreadyOffset() -> Bool {
        if self.position == .center {
            return originalCenter != nil && self.center != originalCenter
        } else {
            return originalY != nil && self.twl.y != originalY
        }
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
