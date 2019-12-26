//
//  HMenuViewController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import SwizzleSwift
import SwiftyLoad

let kTabBarHeight: CGFloat = 50.0

//class HMenuViewController: UITabBarController {
class HMenuViewController: HTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initViewControllers()
        self.setupFrameOfTabBarAndContentView()
    }
    
    func initViewControllers() {
//        let mainVC = HMainViewController.init()
//        mainVC.tabBarItem.title = "主页"
//        mainVC.tabBarItem.image = UIImage.init(named: "di_index")
//        mainVC.tabBarItem.selectedImage = UIImage.init(named: "di_index_h")
//
//        let gameCategoryVC = HGameCategoryVC.init()
//        gameCategoryVC.tabBarItem.title = "分类"
//        gameCategoryVC.tabBarItem.image = UIImage.init(named: "di_more")
//        gameCategoryVC.tabBarItem.selectedImage = UIImage.init(named: "di_more_h")
//
//        let serviceVC = HCServiceViewController.init()
//        serviceVC.tabBarItem.title = "客服"
//        serviceVC.tabBarItem.image = UIImage.init(named: "di_kf")
//        serviceVC.tabBarItem.selectedImage = UIImage.init(named: "di_kf_h")
//
//        let centerVC = HCenterViewController.init()
//        centerVC.tabBarItem.title = "会员中心"
//        centerVC.tabBarItem.image = UIImage.init(named: "di_login")
//        centerVC.tabBarItem.selectedImage = UIImage.init(named: "di_login_h")
//
//        self.viewControllers = NSMutableArray.init(objects: mainVC, gameCategoryVC, serviceVC, centerVC) as? [UIViewController]
        
        let mainVC1 = HMainController1()
        mainVC1.h_tabItemTitle = "第一页"
        mainVC1.h_tabItemImage = UIImage.init(named: "di_index")
        mainVC1.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        
        let mainVC2 = HMainController2()
        mainVC2.h_tabItemTitle = "第二页"
        mainVC2.h_tabItemImage = UIImage.init(named: "di_index")
        mainVC2.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        let mainVC3 = HMainController3()
        mainVC3.h_tabItemTitle = "第三页"
        mainVC3.h_tabItemImage = UIImage.init(named: "di_index")
        mainVC3.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        let mainVC4 = HMainController4()
        mainVC4.h_tabItemTitle = "第四页"
        mainVC4.h_tabItemImage = UIImage.init(named: "di_index")
        mainVC4.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        let loginVC = HLoginController()
        loginVC.h_tabItemTitle = "登录"
        loginVC.h_tabItemImage = UIImage.init(named: "di_index")
        loginVC.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        let registerVC = HRegisterController()
        registerVC.h_tabItemTitle = "注册"
        registerVC.h_tabItemImage = UIImage.init(named: "di_index")
        registerVC.h_tabItemSelectedImage = UIImage.init(named: "di_index_h")
        
        self.viewControllers = NSMutableArray.init(objects: mainVC1, mainVC2, mainVC3, mainVC4, loginVC, registerVC)
    }
    
    func setupFrameOfTabBarAndContentView() {

        // 设置默认的tabBar的frame和contentViewFrame
        let screenSize = UIScreen.main.bounds.size
        
        var contentViewY: CGFloat = 0.0
        var tabBarY: CGFloat = screenSize.height - kTabBarHeight
        tabBarY -= UIDevice.bottomBarHeight
        
        var contentViewHeight: CGFloat = tabBarY
        // 如果parentViewController为UINavigationController及其子类
        if self.parent != nil && self.navigationController != nil {
            if self.parent!.isKind(of: UINavigationController.self) && !self.navigationController!.isNavigationBarHidden && !self.navigationController!.navigationBar.isHidden {
                let navMaxY: CGFloat = self.navigationController!.navigationBar.frame.maxY
                if (!self.navigationController!.navigationBar.isTranslucent ||
                    self.edgesForExtendedLayout == Optional.none ||
                    self.edgesForExtendedLayout == .top) {
                    tabBarY = screenSize.height - kTabBarHeight - navMaxY
                    contentViewHeight = tabBarY
                } else {
                    contentViewY = navMaxY
                    contentViewHeight = screenSize.height - kTabBarHeight - contentViewY
                }
            }
        }
        
        self.setTabBarFrame(CGRectMake(0, tabBarY, screenSize.width, kTabBarHeight),
                            contentViewFrame: CGRectMake(0, contentViewY, screenSize.width, contentViewHeight))
        
        self.tabBar.itemTitleColor = UIColor(hex: "#535353")
        self.tabBar.itemTitleSelectedColor = UIColor(hex: "#CFA359")
        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 14)
        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 14)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.addTopLineViewWithColor(UIColor.gray)
        self.tabBar.addBottomBlankViewWithColor(UIColor.white)
    }
    
//    func testFunc() -> Void {
//        if self.isKind(of: UIViewController.self) {
//            NSLog("true")
//        }else {
//            NSLog("false")
//        }
//
////        if self.isKind(of: UIViewController.classForCoder()) {
//        if self.isKind(of: NSClassFromString("UIViewController")!) {
//            NSLog("true")
//        }else {
//            NSLog("false")
//        }
//    }
//
//    func testFunc2() -> Void {
//
//    // 返回内部类名
//
//    print("deinit: \(object_getClassName(self))")
//    print("deinit: \(self.className)")
//
////        let sing = Singleton.sharedInstance
//        print("address : \(Unmanaged.passUnretained(self).toOpaque())")
//
////        let str = "1234"
//        let address = String(format: "%p", self)
//        print(address)
//
//    // 返回应用程序名+类名
//
////    print("deinit: \(NSStringFromClass(self.dynamicType))")
//
//    // 返回应用程序名+类名，并去掉应用程序名
//
////    print("deinit: \(NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!)")
//
//    // 返回应用程序名+类名+内存地址
//
//    print("deinit: \(self)")
//
//    // 返回应用程序名+类名+内存地址
//
//    print("deinit: \(self.description)")
//
//    // 返回类名
//
////        self.dynami
////    print("deinit: \(self.dynamicType)")
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//extension HMenuViewController {
//
//    objc class func swizzle() -> Void {
//        Swizzle(HMenuViewController.self) {
//            #selector(viewDidLoad) <-> #selector(myViewDidLoad)
//            #selector(viewWillAppear(_:)) <-> #selector(myViewWillAppear(_:))
//        }
//    }
//
//    objc private func myViewDidLoad() {
//        print(#function)
//        myViewDidLoad()
//    }
//
//    objc private func myViewWillAppear(_ animated: Bool) {
//        print(#function)
//        myViewWillAppear(animated)
//    }
//
//}
//
//
//extension HMenuViewController : NSSwiftyLoadProtocol {
//    public static func swiftyLoad() {
//        print("UIViewController--->swiftyLoad")
//
////        static let share: HPrinterManager = {
////            let instance = HPrinterManager()
////            return instance
////        }()
//    }
//}
