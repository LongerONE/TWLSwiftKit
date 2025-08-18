//
//  ViewController.swift
//  Demo-iOS
//
//  Created by dev on 2024/10/10.
//

import UIKit
import TWLSwiftKit


class ViewController: UIViewController {

    var confs: [String: String] = [
        "AutoFlow": "AutoFlowController",
        "Field": "FieldController",
        "String": "StringController",
        "TextView": "TextViewController",
        "Buttons": "ButtonsController"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confs.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let keys = confs.keys.sorted()
        cell?.textLabel?.text = keys[twl: indexPath.row]
        
        return cell!
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keys = confs.keys.sorted()
        guard let key = keys[twl: indexPath.row] else { return }
        guard let value = confs[key] else { return }
        guard let vcClass = Bundle.main.classNamed(value) as? UIViewController.Type else {
            TWLDPrint("Class not found: \(value)")
            return
        }
        
        let vc = vcClass.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
