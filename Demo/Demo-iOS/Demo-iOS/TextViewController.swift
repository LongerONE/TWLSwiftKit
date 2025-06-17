//
//  TextViewController.swift
//  Demo-iOS
//
//  Created by 唐万龙 on 2025/6/17.
//

import UIKit
import TWLSwiftKit
import SnapKit

@objc(TextViewController)
class TextViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let textView = TWLTextView()
        textView.backgroundColor = "F0F0F0".twl.color
        textView.maxLength = 200
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(100)
        }
        
        textView.contentsUpdate = {twlTextView in
            TWLDPrint("\(twlTextView.text ?? "")")
        }
        
        textView.placeHolder = "请输入..."
        textView.placeHolderTop = 10
        textView.placeHolderLeft = 20
        textView.placeHolderColor = "999999".twl.color
        textView.placeHolderFont = UIFont.systemFont(ofSize: 12)
        
        textView.lineSpace = 5
        
        textView.font = UIFont.systemFont(ofSize: 14)
    }
}
