//
//  ViewController.swift
//  Demo-iOS
//
//  Created by dev on 2024/10/10.
//

import UIKit
import TWLSwiftKit
import SnapKit

class ViewController: UIViewController {

    
    var autoFlowView: TWLAutoFlowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = [
            ["a" : "000",
             "b" :111]
        ]
        TWLDPrint("\(arr.twl.JSONString ?? "")")
        
        let string = """
                        [
                            {
                                "key1" : "中文"
                            },
                            {
                                "key2" : 333
                            }
                        ]
                        """
        TWLDPrint("\(string.twl.trimmedLeadingWhitespace)")
        TWLDPrint("\(string.twl.addPercent)")
        TWLDPrint("\(string.twl.addPercentAllowLetters)")
        TWLDPrint("\(string.twl.trimmedLeadingWhitespace.twl.array?.debugDescription ?? "")")
        if let arr = string.twl.array {
            TWLDPrint("\(arr[twl: 3] ?? "空")")
        }
     
        
        let string2 = """
                    {
                        "key3" : {
                            "key31" : 0
                            }
                    }
                    """
        TWLDPrint("\(string2.twl.dict?.description ?? "")")
        

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
        }

        
        autoFlowView = TWLAutoFlowView()
        autoFlowView.backgroundColor = "059151".twl.color
        autoFlowView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        autoFlowView.innerSpace = 15
        autoFlowView.lineSpace = 12
        autoFlowView.colCount = 3
        autoFlowView.useAutoLayout = true
        autoFlowView.useContentsHeight = true
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

        let resizeBtn = UIButton(type: .system)
        resizeBtn.setTitle("Resize", for: .normal)
        resizeBtn.addTarget(self, action: #selector(resizeAction), for: .touchUpInside)
        resizeBtn.frame = CGRect(x: 100, y: 70, width: 60, height: 30)
        view.addSubview(resizeBtn)
    }
    
    
    @objc private func resizeAction() {
        autoFlowView.twl.width = autoFlowView.twl.width + 20
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        autoFlowView.updateSubviewsLayout()
//        autoFlowView.snp.updateConstraints { make in
//            make.height.equalTo(autoFlowView.showHeight)
//        }
    }
}

//extension ViewController: TWLFlowViewDataSouce {
//    func numberOfViews(flowView: TWLSwiftKit.TWLFlowView) -> Int {
//        return 10
//    }
//    
//    func viewForIndex(flowView: TWLSwiftKit.TWLFlowView, index: Int) -> UIView {
//        let lbl = UILabel()
//        lbl.text = "\(index) \(index) \(index) \(index) \(index)"
//        lbl.backgroundColor = "795579".twl.color?.withAlphaComponent(0.4)
//        lbl.sizeToFit()
//        return lbl
//    }
//}
