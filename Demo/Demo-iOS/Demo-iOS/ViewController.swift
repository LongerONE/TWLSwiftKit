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
        
        let colorHex = "#336599"
        self.view.backgroundColor = colorHex.twl.color
        
        let flowView = TWLFlowView()
        flowView.backgroundColor = "C5feg6".twl.color
        flowView.innerSpace = 10
        flowView.lineSpace = 20
        flowView.colCount = 3
        flowView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        flowView.dataSource = self
        view.addSubview(flowView)
        flowView.twl.width  = 300
        flowView.twl.x = 50
        flowView.twl.y = 100
        flowView.reloadViews()
        
        
        let autoFlowView = TWLAutoFlowView()
        autoFlowView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        autoFlowView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        autoFlowView.innerSpace = 15
        autoFlowView.lineSpace = 12
        autoFlowView.colCount = 4
        autoFlowView.useAutoLayout = true
        autoFlowView.useContentsHeight = true
        
        view.addSubview(autoFlowView)
        autoFlowView.twl.width  = 350
        autoFlowView.twl.x = 50
        autoFlowView.twl.y = 400
        
        for index in 0..<19 {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.text = "\(index)\(index)\(index)"
//            lbl.sizeToFit()
            autoFlowView.addArrangedSubview(lbl)
            print("\(lbl.text ?? "")")
        }
    }
    
}

extension ViewController: TWLFlowViewDataSouce {
    func numberOfViews(flowView: TWLSwiftKit.TWLFlowView) -> Int {
        return 10
    }
    
    func viewForIndex(flowView: TWLSwiftKit.TWLFlowView, index: Int) -> UIView {
        let lbl = UILabel()
        lbl.text = "\(index) \(index) \(index) \(index) \(index)"
        lbl.backgroundColor = "795579".twl.color?.withAlphaComponent(0.4)
        lbl.sizeToFit()
        return lbl
    }
}
