//
//  TWLBaseAlertView.swift
//

import UIKit

open class TWLBaseAlertView: TWLView {

    public var maskAlpha: CGFloat = 0.0
    public var touchDismiss = false
    public var cancelClosure:() -> Void = {}

    /// 定位锚点：弹窗围绕它摆放。手动拖动等自由摆放后由子类置为 nil，
    /// 旋转重算时只做安全区收拢，不再弹回锚点附近。
    public weak var placementAnchor: UIView?

    /// show(from:) 传入锚点时为 true，用于区分“围绕锚点”与“居中”两种默认摆放。
    private var anchoredPlacement = false

    public static let placementMargin: CGFloat = 10.0

    open func show(from: UIView?, on: UIView? = nil) {
        let maskBtn = TWLButton(type: .custom)
        let window = on != nil ? on : UIApplication.shared.twlKeyWindow
        window?.layoutIfNeeded()
        window?.addSubview(maskBtn)
        maskBtn.alpha = 0.0
        maskBtn.frame = window?.bounds ?? CGRect.zero
        maskBtn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(self.maskAlpha)
        maskBtn.touchUpInSideClosure = {[weak self] btn in
            if self?.touchDismiss == true {
                self?.cancelClosure()
                self?.dismiss()
            }
        }

        placementAnchor = from
        anchoredPlacement = from != nil

        maskBtn.addSubview(self)
        reposition()

        UIView.animate(withDuration: 0.3, delay: 0) {
            maskBtn.alpha = 1.0
        }
    }

    /// 按当前几何与屏幕安全区重算位置：
    /// 锚定弹窗围绕锚点（下方放不下则翻到上方）；居中弹窗保持居中；
    /// 自由摆放（如已拖动）保持原位；三种结果统一收拢进安全边界。
    public func reposition() {
        guard let container = superview else { return }
        let size = bounds.size
        let insets = container.safeAreaInsets
        let margin = Self.placementMargin

        let xBounds = Self.positionBounds(extent: container.bounds.width,
                                          insetLow: insets.left,
                                          insetHigh: insets.right,
                                          length: size.width,
                                          margin: margin)
        let yBounds = Self.positionBounds(extent: container.bounds.height,
                                          insetLow: insets.top,
                                          insetHigh: insets.bottom,
                                          length: size.height,
                                          margin: margin)

        var origin = frame.origin
        if anchoredPlacement, let anchor = placementAnchor, let anchorParent = anchor.superview {
            let position = container.convert(anchor.frame, from: anchorParent)
            origin.x = position.midX - size.width * 0.5
            origin.y = position.maxY + margin
            if origin.y > yBounds.max {
                origin.y = position.minY - size.height - margin
            }
        } else if anchoredPlacement == false {
            origin = CGPoint(x: (container.bounds.width - size.width) * 0.5,
                             y: (container.bounds.height - size.height) * 0.5)
        }

        origin.x = min(max(origin.x, xBounds.min), xBounds.max)
        origin.y = min(max(origin.y, yBounds.min), yBounds.max)
        frame = CGRect(origin: origin, size: size)
    }

    /// 单轴可摆放区间；内容放不进安全区时退化为居中，两侧等量溢出。
    public static func positionBounds(extent: CGFloat, insetLow: CGFloat, insetHigh: CGFloat,
                                      length: CGFloat, margin: CGFloat) -> (min: CGFloat, max: CGFloat) {
        let low = insetLow + margin
        let high = extent - insetHigh - length - margin
        if high < low {
            let center = (extent - length) * 0.5
            return (center, center)
        }
        return (low, high)
    }

    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.superview?.alpha = 0.0
        } completion: { _ in
            self.superview?.removeFromSuperview()
        }
    }
}
