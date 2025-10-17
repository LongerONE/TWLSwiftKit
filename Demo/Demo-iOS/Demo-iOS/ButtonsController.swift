//
//  ButtonsController.swift
//  Demo-iOS
//

import UIKit
import TWLSwiftKit

@objc(ButtonsController)
class ButtonsController: UIViewController {
    
    
    var flexView: TWLFlexStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        let btn = TWLButton()
        
        let confBtn = TWLConfButton()
        if #available(iOS 15.0, *) {
            confBtn.configurationUpdateHandler = { btn in
                
            }
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(confBtn)
        
    }
    
    
    
}









