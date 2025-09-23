//
//  TWLConfButton.swift
//  TWLSwiftKit
//
//

import UIKit


@IBDesignable
open class TWLConfButton: UIButton {

    public var uuid: String?
    
    public var obj: Any?
    
    public var touchUpInSideClosure:((_ btn: TWLConfButton) -> Void)?
    
    public var isChecked: Bool = false {
        didSet {
            updateView()
        }
    }
    
    
    public var isDisabled: Bool = false {
        didSet {
            updateView()
        }
    }
    
    
    
    public var normalImage: UIImage?
    public var normalBgImage: UIImage?
    public var normalBgColor: UIColor?
    public var normalTitle: String?
    public var normalTitleColor: UIColor?
    public var normalTitleFont: UIFont?
    
    public var checkedImage: UIImage?
    public var checkedBgImage: UIImage?
    public var checkedBgColor: UIColor?
    public var checkedTitle: String?
    public var checkedTitleColor: UIColor?
    public var checkedTitleFont: UIFont?
    
    public var disabledAlpha = 0.5
    public var disabledImage: UIImage?
    public var disabledBgColor: UIColor?
    public var disabledBgImage: UIImage?
    public var disabledTitle: String?
    public var disabledTitleColor: UIColor?
    public var disabledTitleFont: UIFont?
    
    public convenience init(title: String? = nil,
                color: UIColor? = nil,
                font: UIFont? = nil,
                bgColor: UIColor? = nil,
                image: UIImage? = nil,
                imagePlacement: NSDirectionalRectEdge? = nil,
                imagePadding: CGFloat? = nil,
                insets: NSDirectionalEdgeInsets = .zero,
                cornerRadius: CGFloat? = nil,
                borderColor: UIColor? = nil,
                borderWidth: CGFloat? = nil) {
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.plain()
            if let title = title {
                conf.title = title
            }
            
            if let color = color {
                conf.baseForegroundColor = color
            }
            
            if let font = font {
                conf.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                    var outgoing = incoming
                    outgoing.font = font
                    return outgoing
                })
            }
            
            if let bgColor = bgColor {
                conf.background.backgroundColor = bgColor
            }
            
            if let image = image {
                conf.image = image
            }
            
            if let imagePlacement = imagePlacement {
                conf.imagePlacement = imagePlacement
            }
            
            if let imagePadding = imagePadding {
                conf.imagePadding = imagePadding
            }
            
            conf.contentInsets = insets
            
            self.init(configuration: conf)
               
            if let cornerRadius = cornerRadius {
                self.layer.cornerRadius = cornerRadius
            }
            
            if let borderColor = borderColor {
                self.layer.borderColor = borderColor.cgColor
                self.layer.borderWidth = 1
            }
            
            if let borderWidth = borderWidth {
                self.layer.borderWidth = borderWidth
            }
            
            self.configurationUpdateHandler = { btn in
                btn.alpha = btn.isHighlighted ? 0.4 : 1.0
            }
            
            self.normalTitle = title
            self.normalTitleFont = font
            self.normalTitleColor = color
            self.normalImage = image
            
        } else {
            if let image = image {
                self.init(type: .custom)
            } else {
                self.init(type: .system)
            }
            
            
            
        }
    }
    
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
    }
    
    @objc func touchUpInSideAction() {
        if (self.touchUpInSideClosure != nil) {
            self.touchUpInSideClosure!(self)
        }
    }

    
    @IBInspectable public var onePixelBorder: Bool {
        get {
            return self.layer.borderWidth == 1.0 / UIScreen.main.scale
        } set {
            if newValue {
                self.layer.borderWidth = 1.0 / UIScreen.main.scale
            } else {
                self.layer.borderWidth = 0.0
            }
        }
    }
    
    @IBInspectable public var cornerRadius: Double {
         get {
           return Double(self.layer.cornerRadius)
         }set {
           self.layer.cornerRadius = CGFloat(newValue)
         }
    }

    @IBInspectable public var borderWidth: Double {
          get {
            return Double(self.layer.borderWidth)
          }
          set {
           self.layer.borderWidth = CGFloat(newValue)
          }
    }
    @IBInspectable public var borderColor: UIColor? {
         get {
            return UIColor(cgColor: self.layer.borderColor!)
         }
         set {
            self.layer.borderColor = newValue?.cgColor
         }
    }
    @IBInspectable public var shadowColor: UIColor? {
        get {
           return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
           self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable public var shadowOpacity: Float {
        get {
           return self.layer.shadowOpacity
        }
        set {
           self.layer.shadowOpacity = newValue
       }
    }
    
    
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
       }
    }
    
    @IBInspectable public var shadowOffsetHeight: CGFloat {
        get {
            return self.layer.shadowOffset.height
        }
        set {
            self.layer.shadowOffset = CGSize(width: 0.0, height: newValue)
       }
    }

    
    public func updateView() {
        guard #available(iOS 15.0, *) else { return }

        if isDisabled {
            isUserInteractionEnabled = false
            alpha = disabledAlpha
            if let disabledTitle = disabledTitle {
                configuration?.title = disabledTitle
            } else {
                if isChecked {
                    if let checkedTitle = checkedTitle {
                        configuration?.title = checkedTitle
                    } else if let normalTitle = normalTitle {
                        configuration?.title = normalTitle
                    }
                } else {
                    if let normalTitle = normalTitle {
                        configuration?.title = normalTitle
                    }
                }
            }
            
            if let disabledTitleColor = disabledTitleColor {
                configuration?.baseForegroundColor = disabledTitleColor
            } else {
                if isChecked {
                    if let checkedTitleColor = checkedTitleColor {
                        configuration?.baseForegroundColor = checkedTitleColor
                    } else if let normalTitleColor = normalTitleColor {
                        configuration?.baseForegroundColor = normalTitleColor
                    }
                } else {
                    if let normalTitleColor = normalTitleColor {
                        configuration?.baseForegroundColor = normalTitleColor
                    }
                }
            }
            
            if let disabledBgColor = disabledBgColor {
                configuration?.background.backgroundColor = disabledBgColor
            } else {
                if isChecked {
                    if let checkedBgColor = checkedBgColor {
                        configuration?.background.backgroundColor = checkedBgColor
                    } else if let normalBgColor = normalBgColor {
                        configuration?.background.backgroundColor = normalBgColor
                    }
                } else {
                    if let normalBgColor = normalBgColor {
                        configuration?.background.backgroundColor = normalBgColor
                    }
                }
            }
            
            
            if let disabledTitleFont = disabledTitleFont {
                configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                    var outgoing = incoming
                    outgoing.font = disabledTitleFont
                    return outgoing
                })
            } else {
                if isChecked {
                    if let checkedTitleFont = checkedTitleFont {
                        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                            var outgoing = incoming
                            outgoing.font = checkedTitleFont
                            return outgoing
                        })
                    } else if let normalTitleFont = normalTitleFont {
                        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({incoming in
                            var outgoing = incoming
                            outgoing.font = normalTitleFont
                            return outgoing
                        })
                    }
                } else {
                    if let normalTitleFont = normalTitleFont {
                        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({incoming in
                            var outgoing = incoming
                            outgoing.font = normalTitleFont
                            return outgoing
                        })
                    }
                }
            }
            
            if let disabledImage = disabledImage {
                configuration?.image = disabledImage
            } else {
                if isChecked {
                    if let checkedImage = checkedImage {
                        configuration?.image = checkedImage
                    } else if let normalImage = normalImage {
                        configuration?.image = normalImage
                    }
                } else {
                    if let normalImage = normalImage {
                       configuration?.image = normalImage
                   }
                }
            }
            
            if let disabledBgImage = disabledBgImage {
                configuration?.background.image = disabledBgImage
            } else {
                if isChecked {
                    if let checkedBgImage = checkedBgImage {
                        configuration?.background.image = checkedBgImage
                    } else if let normalBgImage = normalBgImage {
                        configuration?.background.image = normalBgImage
                    }
                } else {
                    if let normalBgImage = normalBgImage {
                        configuration?.background.image = normalBgImage
                    }
                }
            }
        } else {
            isUserInteractionEnabled = true
            alpha = 1.0
            
            if isChecked {
                showCheckedView()
            } else {
                showNormalView()
            }
        }
    }
    
    func showCheckedView() {
        guard #available(iOS 15.0, *) else { return }
        
        if let checkedTitle = checkedTitle {
            configuration?.title = checkedTitle
        } else if let normalTitle = normalTitle {
            configuration?.title = normalTitle
        }
        
        if let checkedTitleColor = checkedTitleColor {
            configuration?.baseForegroundColor = checkedTitleColor
        } else if let normalTitleColor = normalTitleColor {
            configuration?.baseForegroundColor = normalTitleColor
        }
        
        if let checkedBgColor = checkedBgColor {
            configuration?.background.backgroundColor = checkedBgColor
        } else if let normalBgColor = normalBgColor {
            configuration?.background.backgroundColor = normalBgColor
        }
        
        if let checkedTitleFont = checkedTitleFont {
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
                var outgoing = incoming
                outgoing.font = checkedTitleFont
                return outgoing
            })
        } else if let normalTitleFont = normalTitleFont {
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({incoming in
                var outgoing = incoming
                outgoing.font = normalTitleFont
                return outgoing
            })
        }
        
        if let checkedImage = checkedImage {
            configuration?.image = checkedImage
        } else if let normalImage = normalImage {
            configuration?.image = normalImage
        }
        
        if let checkedBgImage = checkedBgImage {
            configuration?.background.image = checkedBgImage
        } else if let normalBgImage = normalBgImage {
            configuration?.background.image = normalBgImage
        }
    }
    
    func showNormalView() {
        guard #available(iOS 15.0, *) else { return }
        
        if let normalTitle = normalTitle {
            configuration?.title = normalTitle
        }
        if let normalTitleColor = normalTitleColor {
            configuration?.baseForegroundColor = normalTitleColor
        }
        if let normalBgColor = normalBgColor {
            configuration?.background.backgroundColor = normalBgColor
        }
        if let normalTitleFont = normalTitleFont {
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({incoming in
                var outgoing = incoming
                outgoing.font = normalTitleFont
                return outgoing
            })
        }
        if let normalImage = normalImage {
            configuration?.image = normalImage
        }
        if let normalBgImage = normalBgImage {
            configuration?.background.image = normalBgImage
        }
    }

}
