//
//  ViewController.swift
//  MyRefresh
//
//  Created by yyyzzq on 08/11/2019.
//  Copyright (c) 2019 yyyzzq. All rights reserved.
//

import UIKit
import MyRefresh

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(refreshHeader: MyRefreshTestHeader()) {
            
        }
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

