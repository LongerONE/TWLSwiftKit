//
//  UIView+TWL.swift
//  Temby
//
//  Created by 唐万龙 on 2023/5/31.
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
            return TWLUIViewExStruct(self)
        }
        set {
            
        }
    }
    
}
