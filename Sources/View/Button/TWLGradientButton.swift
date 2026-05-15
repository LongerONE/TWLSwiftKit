import UIKit

// MARK: - CornerRadii

/// 四个独立圆角半径配置
public struct TWLCornerRadii: Equatable {
    var topLeft:     CGFloat
    var topRight:    CGFloat
    var bottomLeft:  CGFloat
    var bottomRight: CGFloat

    // MARK: Init

    /// 逐一指定四个圆角（不传则默认 0）
    public init(
        topLeft:     CGFloat = 0,
        topRight:    CGFloat = 0,
        bottomLeft:  CGFloat = 0,
        bottomRight: CGFloat = 0
    ) {
        self.topLeft     = topLeft
        self.topRight    = topRight
        self.bottomLeft  = bottomLeft
        self.bottomRight = bottomRight
    }

    /// 四个圆角统一设为同一值
    public init(all radius: CGFloat) {
        self.init(topLeft: radius, topRight: radius,
                  bottomLeft: radius, bottomRight: radius)
    }

    // MARK: Presets

    @MainActor static let zero = TWLCornerRadii(all: 0)
}

// MARK: - CornerRadii + Path

extension TWLCornerRadii {

    /// 根据矩形生成对应的 Bezier 路径
    /// 每个圆角值会被自动限制在 min(width, height) / 2 以内，避免变形
    func path(in rect: CGRect) -> UIBezierPath {
        let maxR = min(rect.width, rect.height) / 2
        let tl = min(topLeft,     maxR)
        let tr = min(topRight,    maxR)
        let bl = min(bottomLeft,  maxR)
        let br = min(bottomRight, maxR)

        let path = UIBezierPath()
        let minX = rect.minX, minY = rect.minY
        let maxX = rect.maxX, maxY = rect.maxY

        // 左上圆弧起点 → 顺时针
        path.move(to: CGPoint(x: minX + tl, y: minY))

        // ── 上边 ──────────────────────────────────────────
        path.addLine(to: CGPoint(x: maxX - tr, y: minY))
        // 右上圆弧
        path.addArc(
            withCenter: CGPoint(x: maxX - tr, y: minY + tr),
            radius: tr,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: true
        )

        // ── 右边 ──────────────────────────────────────────
        path.addLine(to: CGPoint(x: maxX, y: maxY - br))
        // 右下圆弧
        path.addArc(
            withCenter: CGPoint(x: maxX - br, y: maxY - br),
            radius: br,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )

        // ── 下边 ──────────────────────────────────────────
        path.addLine(to: CGPoint(x: minX + bl, y: maxY))
        // 左下圆弧
        path.addArc(
            withCenter: CGPoint(x: minX + bl, y: maxY - bl),
            radius: bl,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )

        // ── 左边 ──────────────────────────────────────────
        path.addLine(to: CGPoint(x: minX, y: minY + tl))
        // 左上圆弧
        path.addArc(
            withCenter: CGPoint(x: minX + tl, y: minY + tl),
            radius: tl,
            startAngle: .pi,
            endAngle: -.pi / 2,
            clockwise: true
        )

        path.close()
        return path
    }
}

// MARK: - GradientConfig

/// 渐变色配置
public struct TWLGradientConfig {
    /// 渐变颜色数组（至少两个）
    var colors:     [UIColor]
    /// 渐变起点，默认从左向右
    var startPoint: CGPoint
    /// 渐变终点
    var endPoint:   CGPoint
    /// 各颜色在渐变轴上的位置，nil 则均匀分布
    var locations:  [NSNumber]?

    public init(
        colors:     [UIColor],
        startPoint: CGPoint    = CGPoint(x: 0, y: 0.5),
        endPoint:   CGPoint    = CGPoint(x: 1, y: 0.5),
        locations:  [NSNumber]? = nil
    ) {
        self.colors     = colors
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.locations  = locations
    }
}

// MARK: - GradientButton

/// 支持三态渐变背景 + 独立四角圆角的自定义按钮
///
/// **三态**
/// - 普通  (normal)
/// - 选中  (selected)
/// - 禁用  (disabled)
///
/// **圆角**
/// 通过 `cornerRadii` 属性或快捷方法独立控制每个角。
open class TWLGradientButton: TWLConfButton {

    // MARK: - Gradient Properties

    /// 普通状态渐变配置
    open var normalGradient: TWLGradientConfig? {
        didSet { updateGradient() }
    }

    /// 选中状态渐变配置（nil 降级为 normalGradient）
    open var checkedGradient: TWLGradientConfig? {
        didSet { updateGradient() }
    }

    /// 禁用状态渐变配置（nil 降级为 normalGradient）
    open var disabledGradient: TWLGradientConfig? {
        didSet { updateGradient() }
    }

    // MARK: - Corner Radius Properties

    /// 四个独立圆角配置，赋值后立即触发重新布局
    open var cornerRadii: TWLCornerRadii = .zero {
        didSet {
            guard cornerRadii != oldValue else { return }
            setNeedsLayout()
        }
    }

    /// 左上角圆角（等价于 cornerRadii.topLeft）
    open var cornerRadiusTopLeft: CGFloat {
        get { cornerRadii.topLeft }
        set { cornerRadii.topLeft = newValue }
    }

    /// 右上角圆角（等价于 cornerRadii.topRight）
    open var cornerRadiusTopRight: CGFloat {
        get { cornerRadii.topRight }
        set { cornerRadii.topRight = newValue }
    }

    /// 左下角圆角（等价于 cornerRadii.bottomLeft）
    open var cornerRadiusBottomLeft: CGFloat {
        get { cornerRadii.bottomLeft }
        set { cornerRadii.bottomLeft = newValue }
    }

    /// 右下角圆角（等价于 cornerRadii.bottomRight）
    open var cornerRadiusBottomRight: CGFloat {
        get { cornerRadii.bottomRight }
        set { cornerRadii.bottomRight = newValue }
    }

    // MARK: - Corner Radius Methods

    /// 一次性将四个圆角设为同一值
    open func setCornerRadius(_ radius: CGFloat) {
        cornerRadii = TWLCornerRadii(all: radius)
    }

    /// 分别设置四个圆角，不传的角保持为 0（覆盖旧值）
    func setCornerRadius(
        topLeft:     CGFloat = 0,
        topRight:    CGFloat = 0,
        bottomLeft:  CGFloat = 0,
        bottomRight: CGFloat = 0
    ) {
        cornerRadii = TWLCornerRadii(
            topLeft:     topLeft,
            topRight:    topRight,
            bottomLeft:  bottomLeft,
            bottomRight: bottomRight
        )
    }

    // MARK: - State Overrides
    
    open override var isChecked: Bool {
        didSet {
            super.updateView()
            updateGradient()
        }
    }

    open override var isDisabled: Bool {
        didSet {
            super.updateView()
            updateGradient()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: isHighlighted ? 0.08 : 0.25,
                delay: 0,
                usingSpringWithDamping: 0.65,
                initialSpringVelocity: 0.5,
                options: [.allowUserInteraction]
            ) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.96, y: 0.96)
                    : .identity
            }
        }
    }

    // MARK: - Private Layers

    /// 渐变层，始终置于 layer 最底层
    private let gradientLayer = CAGradientLayer()

    /// 统一裁切遮罩：同时裁切渐变层与按钮内容（文字、图片）
    private let maskLayer = CAShapeLayer()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // 渐变层插入最底层，文字/图片自动浮在上方
        layer.insertSublayer(gradientLayer, at: 0)
        // 以同一个 maskLayer 裁切整个 layer
        // （包含 gradientLayer 和 titleLabel / imageView）
        layer.mask = maskLayer
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        refreshMask()
    }

    // MARK: - Private: Mask

    private func refreshMask() {
        // 关闭 mask 路径的隐式动画，防止 bounds 变化时路径产生不必要的补间
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = bounds
        maskLayer.path  = cornerRadii.path(in: bounds).cgPath
        CATransaction.commit()
    }

    // MARK: - Private: Gradient

    private func updateGradient() {
        applyGradient(currentGradientConfig())
    }

    private func currentGradientConfig() -> TWLGradientConfig? {
        if isDisabled { return disabledGradient ?? normalGradient }
        if isChecked { return checkedGradient ?? normalGradient }
        return normalGradient
    }

    private func applyGradient(_ config: TWLGradientConfig?) {
        guard let config, config.colors.count >= 2 else {
            gradientLayer.colors = nil
            return
        }

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(
            CAMediaTimingFunction(name: .easeInEaseOut)
        )
        gradientLayer.colors     = config.colors.map { $0.cgColor }
        gradientLayer.startPoint = config.startPoint
        gradientLayer.endPoint   = config.endPoint
        gradientLayer.locations  = config.locations
        CATransaction.commit()
    }
}

// MARK: - GradientButton Factory

extension TWLGradientButton {

    /// 快捷工厂方法
    /// - Parameters:
    ///   - normal:      普通态渐变（必填）
    ///   - selected:    选中态渐变（nil 降级为普通态）
    ///   - disabled:    禁用态渐变（nil 降级为普通态）
    ///   - cornerRadii: 四角圆角，默认全部为 0
    @discardableResult
    static func make(
        normal:      TWLGradientConfig,
        selected:    TWLGradientConfig? = nil,
        disabled:    TWLGradientConfig? = nil,
        cornerRadii: TWLCornerRadii     = .zero
    ) -> TWLGradientButton {
        let btn = TWLGradientButton()
        btn.normalGradient   = normal
        btn.checkedGradient = selected
        btn.disabledGradient = disabled
        btn.cornerRadii      = cornerRadii
        return btn
    }
}
