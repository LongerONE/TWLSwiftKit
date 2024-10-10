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
    }


}

