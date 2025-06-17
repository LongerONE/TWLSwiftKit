//
//  StringController.swift
//  Demo-iOS
//
//  Created by 唐万龙 on 2025/6/17.
//

import UIKit
import TWLSwiftKit

@objc(StringController)
class StringController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
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
    }
    
}
