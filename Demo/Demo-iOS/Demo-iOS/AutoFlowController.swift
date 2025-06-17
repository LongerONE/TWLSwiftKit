//
//  AutoFlowController.swift
//  Demo-iOS
//
//  Created by 唐万龙 on 2025/6/17.
//

import UIKit
import TWLSwiftKit
import SnapKit

@objc(AutoFlowController)
class AutoFlowController: UIViewController {
    
    var autoFlowView: TWLAutoFlowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(300)
        }

        
        autoFlowView = TWLAutoFlowView()
        autoFlowView.backgroundColor = "059151".twl.color
        autoFlowView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        autoFlowView.innerSpace = 15
        autoFlowView.lineSpace = 12
        autoFlowView.colCount = 3
        scrollView.addSubview(autoFlowView)
        autoFlowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(300)
//            make.height.equalTo(0)
        }
        
        for index in 0..<49 {
            let lbl = UILabel()
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = "\(index)\(index)\(index)"
            autoFlowView.addArrangedSubview(lbl)
            print("\(lbl.text ?? "")")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        autoFlowView.layoutIfNeeded()
        autoFlowView.updateSubviewsLayout()
//        autoFlowView.snp.updateConstraints { make in
//            make.height.equalTo(autoFlowView.showHeight)
//        }
    }
}
