//
//  HGameCategoryVC.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HGameCategoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "分类"
        
        
//        let unmanagedValue = self.perform(#selector(testSelector))
        //        NSLog("%@", tmpString)
//                let value = unmanagedValue.takeRetainedValue()
        let size: CGSize = self.perform(#selector(testSelector)).takeRetainedValue().cgSizeValue
        let unmanagedValue:Unmanaged<AnyObject> = self.perform(#selector(testSelector))
//        NSLog("%@", tmpString)
        let value = unmanagedValue.takeRetainedValue()
//        value.cgSizeValue
        NSLog("sada")
    }
    
    @objc func testSelector() -> CGSize {
//        return "测试一下啦"
        return CGSize.init(width: 1, height: 2)
    }

}
