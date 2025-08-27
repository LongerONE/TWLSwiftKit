//
//  UIView+TWL.swift
//

import UIKit


public extension UIView {
    
    // MARK: TWLUIViewExStruct
    @MainActor
    struct TWLUIViewExStruct {
        private let view: UIView
        
        init(_ view: UIView) {
            self.view = view
        }
        
        public var x: CGFloat {
            get {
                return self.view.frame.origin.x
            }
            
            set {
                var frame = self.view.frame
                frame.origin.x = newValue
                self.view.frame = frame
            }
        }
        
        
        public var y: CGFloat {
            get {
                return self.view.frame.origin.y
            }
                        
            set {
                var frame = self.view.frame
                frame.origin.y = newValue
                self.view.frame = frame
            }
        }
        
        
        public var width: CGFloat {
            get {
                return self.view.frame.size.width
            }
            
            set {
                var frame = self.view.frame
                frame.size.width = newValue
                self.view.frame = frame
            }
        }
        
        
        public var height: CGFloat {
            get {
                return self.view.frame.size.height
            }
            
            set {
                var frame = self.view.frame
                frame.size.height = newValue
                self.view.frame = frame
            }
        }
        
        
        public var centerX: CGFloat {
            get {
                return self.view.frame.origin.x + self.view.frame.size.width * 0.5
            }
            
            set {
                var frame = self.view.frame
                frame.origin.x = newValue - frame.size.width * 0.5
                self.view.frame = frame
            }
        }
        
        
        public var centerY: CGFloat {
            get {
                return self.view.frame.origin.y + self.view.frame.size.height * 0.5
            }
            
            set {
                var frame = self.view.frame
                frame.origin.y = newValue - frame.size.height * 0.5
                self.view.frame = frame
            }
        }
        
        

        
        
        public var pixelWidth: CGFloat {
            get {
                return self.view.frame.size.width * UIScreen.main.scale
            }
        }
        
        
        public var pixelHeight: CGFloat {
            get {
                return self.view.frame.size.height * UIScreen.main.scale
            }
        }
        
        
        public func removeSubviews() {
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
        }

        public func setCorners(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
            let path = UIBezierPath()
            let bounds = self.view.bounds

            // 依次描点
            path.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
            path.addArc(withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight), radius: topRight,
                        startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
            path.addArc(withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight), radius: bottomRight,
                        startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
            path.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
            path.addArc(withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft), radius: bottomLeft,
                        startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
            path.addArc(withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft), radius: topLeft,
                        startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
            path.close()

            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.view.bounds
            maskLayer.path = path.cgPath
            self.view.layer.mask = maskLayer
        }
    }
    
    // MARK: TWLUIViewClassExStruct
     struct TWLUIViewClassExStruct {
         public static func loadFromNib<T>() -> T where T: UIView {
            return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
        }
    }
    
    

    
    static var twl: TWLUIViewClassExStruct.Type {return TWLUIViewClassExStruct.self}
    

    var twl: TWLUIViewExStruct {
        get {
            weak var weakSelf = self
            return TWLUIViewExStruct(weakSelf!)
        }
        set {
            
        }
    }
    
}
