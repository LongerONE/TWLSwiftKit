//
//  TWLButton.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/31.
//

import UIKit

@IBDesignable
class TWLButton: UIButton {

    var uuid: String?
    
    var obj: Any?
    
    var touchUpInSideClosure:((_ btn: TWLButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addTarget(self, action: #selector(touchUpInSideAction), for: .touchUpInside)
    }
    
    @objc func touchUpInSideAction() {
        if (self.touchUpInSideClosure != nil) {
            self.touchUpInSideClosure!(self)
        }
    }

    
    @IBInspectable var onePixelBorder: Bool {
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
    
    @IBInspectable var cornerRadius: Double {
         get {
           return Double(self.layer.cornerRadius)
         }set {
           self.layer.cornerRadius = CGFloat(newValue)
         }
    }

    @IBInspectable var borderWidth: Double {
          get {
            return Double(self.layer.borderWidth)
          }
          set {
           self.layer.borderWidth = CGFloat(newValue)
          }
    }
    @IBInspectable var borderColor: UIColor? {
         get {
            return UIColor(cgColor: self.layer.borderColor!)
         }
         set {
            self.layer.borderColor = newValue?.cgColor
         }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
           return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
           self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
           return self.layer.shadowOpacity
        }
        set {
           self.layer.shadowOpacity = newValue
       }
    }
    
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
       }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat {
        get {
            return self.layer.shadowOffset.height
        }
        set {
            self.layer.shadowOffset = CGSize(width: 0.0, height: newValue)
       }
    }

}
