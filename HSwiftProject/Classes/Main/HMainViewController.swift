//
//  HMainViewController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var table: UITableView! = nil;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "主页"
        
        table = UITableView.init(frame: self.view.frame);
        table.delegate = self
        table.dataSource = self
        self.view .addSubview(table)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.textLabel?.text = "cell"
        cell?.textLabel?.textColor = UIColor.red
        return cell!
    }
}
