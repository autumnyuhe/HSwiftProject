//
//  HMainController4.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

let KSidebar: CGFloat = 80

class HMainController4: HTabBarController {

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "第四页"
        
        let screenSize: CGSize = UIScreen.main.bounds.size
        self.setTabBarFrame(CGRectMake(0, 0, KSidebar, screenSize.height),
        contentViewFrame:CGRectMake(KSidebar, 0, screenSize.width - KSidebar, screenSize.height))
        
        self.tabBar.itemTitleColor = UIColor(hex: "#535353")
        self.tabBar.itemTitleSelectedColor = UIColor(hex: "#CFA359")
        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 17)
        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 17)
        
        self.tabBar.leadingSpace = UIDevice.topBarHeight
        self.tabBar.trailingSpace = screenSize.height-UIDevice.topBarHeight-2*45
        
        self.tabBar.layoutTabItemsVertical()
        self.tabBar.setItemSeparatorColor(UIColor.red, leading: 0, trailing: 0)
        self.tabBar.backgroundColor = UIColor.lightGray
        
        self.tabBar.indicatorColor = UIColor(hex: "#efeff4")
        
        self.tabContentView.delegate = self
        
        self.initViewControllers()
    }

    func initViewControllers() {
        
        let controller1: UIViewController = UIViewController()
        controller1.view.backgroundColor = UIColor.green
        controller1.h_tabItemTitle = "第一个"
        
        let controller2: UIViewController = UIViewController()
        controller2.view.backgroundColor = UIColor.red
        controller2.h_tabItemTitle = "第二个"
        
        self.viewControllers = NSMutableArray.init(objects: controller1, controller2)
    }

}
