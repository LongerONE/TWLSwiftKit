//
//  FieldController.swift
//  Demo-iOS
//
//  Created by 唐万龙 on 2025/6/22.
//

import UIKit
import TWLSwiftKit
import SnapKit

@objc(FieldController)
class FieldController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        
        let flexStackView = TWLFlexStackView(axis: .vertical)
        flexStackView.backgroundColor = "F4F4F4".twl.color
        flexStackView.stackView.spacing = 20
        view.addSubview(flexStackView)
        flexStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(300)
        }



        let integerField = TWLIntegerField()
        integerField.backgroundColor = "F0F0F0".twl.color
        integerField.placeholder = "TWLIntegerField"
        integerField.maxLength = 4
        flexStackView.addArrangedSubview(integerField)

        
        
        let currencyField = TWLCurrencyField()
        currencyField.maxIntegerLength = 5
        currencyField.backgroundColor = "F2F2F2".twl.color
        currencyField.placeholder = "TWLCurrencyField"
        flexStackView.addArrangedSubview(currencyField)
 
        
        
    }
    
    
    
    
    
    
    
    
    
}
