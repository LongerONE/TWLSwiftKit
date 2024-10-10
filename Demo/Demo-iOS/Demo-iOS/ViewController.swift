//
//  ViewController.swift
//  Demo-iOS
//
//  Created by dev on 2024/10/10.
//

import UIKit
import TWLSwiftKit

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
        flowView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        flowView.dataSource = self
        view.addSubview(flowView)
        flowView.twl.width  = 300
        flowView.twl.x = 50
        flowView.twl.y = 100
        flowView.reloadViews()
    }
    
}

extension ViewController: TWLFlowViewDataSouce {
    func numberOfViews() -> Int {
        
        return 10
    }
    
    func viewForIndex(index: Int) -> UIView {
        let lbl = UILabel()
        lbl.text = "\(index) \(index) \(index) \(index) \(index)"
        lbl.backgroundColor = "795579".twl.color?.withAlphaComponent(0.4)
        return lbl
    }
    
    
}
