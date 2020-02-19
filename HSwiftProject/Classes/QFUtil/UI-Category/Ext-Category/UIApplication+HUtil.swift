//
//  UIApplication+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/19.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

enum HANetworkStatus: Int {
    case Unknown = -1
    case Not     = 0
    case Via2G   = 1
    case Via3G   = 2
    case Via4G   = 3
    case ViaLTE  = 4
    case ViaWiFi = 5
}

extension UIApplication {

    ///AppDelegate
    static var appDel: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
        
    ///get Window 0
    static var getKeyWindow: UIWindow? {
        return UIApplication.shared.getKeyWindow
    }

    ///get Window 0
    var getKeyWindow: UIWindow? {
        return self.windows.first
    }
    
    ///get root VC of window 0
    static var getKeyWindowRootController: UIViewController? {
        return UIApplication.shared.getKeyWindowRootController
    }

    ///get root VC of window 0
    var getKeyWindowRootController: UIViewController? {
        return self.getKeyWindow?.rootViewController
    }

    ///get root navigation controller
    static var navi: UINavigationController? {
        let navi = UIApplication.getKeyWindowRootController as? UINavigationController
        if navi?.isKind(of: UINavigationController.self) ?? false {
            return navi
        }
        return nil
    }

    ///get root navigation controller top
    static var naviTop: UIViewController? {
        let navi = UIApplication.getKeyWindowRootController as? UINavigationController
        if navi?.isKind(of: UINavigationController.self) ?? false {
            return navi?.topViewController
        }
        return nil
    }

    ///get root tabbar vc
    static var tabbarVC: UITabBarController? {
        let tabVC: UIViewController? = UIApplication.getKeyWindowRootController
        if tabVC?.isKind(of: UITabBarController.self) ?? false {
            return tabVC as? UITabBarController
        }else if tabVC?.isKind(of: UINavigationController.self) ?? false {
            let navi = tabVC as! UINavigationController
            if navi.topViewController?.isKind(of: UITabBarController.self) ?? false {
                return navi.topViewController as? UITabBarController
            }
        }
        return nil
    }
    
    /**
    *  status bar orientation
    */
    static func statusBarOrientation() -> UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
//    static var statusBarOrientation2: UIInterfaceOrientation? {
//        get {
//            if #available(iOS 13.0, *) {
//                return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
//            } else {
//                return UIApplication.shared.statusBarOrientation
//            }
//        }
//    }

    /**
    *  Bundle Name
    */
    static var appBundleName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }

    /**
    *  Bundle Display Name
    */
    static var appBundleDisplayName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }

    /**
    *  Bundle ID
    */
    static var appBundleID: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    
    /**
    *  版本名称，例如：1.2.0
    */
    static var appVersionName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    /**
    *  版本号，例如：123
    */
    static var appShortVersionString: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    /**
    *  app启动图
    */
    static var appLaunchImage: UIImage? {

        var viewOrientation: String  = "Portrait"
        if UIApplication.statusBarOrientation()?.isLandscape ?? false {
            viewOrientation = "Landscape"
        }

        var launchImageName: String = ""
        let imagesDict: Array = Bundle.main.value(forKey: "UILaunchImages") as! Array<Any>
        let viewSize: CGSize = UIScreen.main.bounds.size
        
        for item in imagesDict {
            let dict: NSDictionary = item as! NSDictionary
            let imageSize: CGSize = NSCoder.cgSize(for: dict["UILaunchImageSize"] as! String)
            if imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"] as! String {
                launchImageName = dict["UILaunchImageName"] as! String
            }
        }
        
        return UIImage(named: launchImageName)
    }

    /**
    *  获取当前语言
    */
    static var currentLanguage: String {
        return NSLocale.preferredLanguages.first!
    }

    /**
    *  根据app状态栏获取网络状态
    */
    static var networkStatusFromStateBar: HANetworkStatus {
        let objc = UIApplication.shared.value(forKey: "statusBar") as AnyObject
        let arr: Array<UIView> = objc.value(forKeyPath: "foregroundView") as! Array
        for item in arr {
            let view: UIView = item
            if view.isKind(of:NSClassFromString("UIStatusBarDataNetworkItemView")!.self) {
                let value: String = view.value(forKeyPath: "dataNetworkType") as! String
                let status: HANetworkStatus = HANetworkStatus(rawValue: Int(value)!)!
                return status
            }
        }
        return .Unknown
    }
    /**
    *  判断程序是否为从AppStore安装
    */
    static var isPirated: Bool {
        if UIDevice.isSimulator { return true } // Simulator is not from appstore
        
        if getgid() <= 10 { return true } // process ID shouldn't be root
        
        if Bundle.main.infoDictionary!["SignerIdentity"] != nil { return true }
        
        if self.fileExistInMainBundle("_CodeSignature") == false { return true }
        
        if self.fileExistInMainBundle("SC_Info") == false { return true }
        
        return false
    }

    static private func fileExistInMainBundle(_ name: String) -> Bool {
        return FileManager.default.fileExists(atPath: Bundle.main.bundlePath+"/"+name)
    }
    
     /// 判断是否在测试环境下
    static var isBeingDebugged: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static func hideKeyboard() -> Void {
        UIApplication.shared.getKeyWindow?.endEditing(true)
    }

    static func call(_ phone: String) -> Void {
        if UIApplication.shared.canOpenURL(URL(string: "tel://\(String(describing: phone))")!) {
            UIApplication.shared.open(URL(string: "tel://\(String(describing: phone))")!)
        }
    }

    static func openURLString(_ urlString: String) -> Void {
        if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }

//    ///根据颜色动态设置状态栏样式
//    static func setStatusBarStyleWithColor(_ color: UIColor) -> Void {
//        if color.isLighterColor {
//            if #available(iOS 13.0, *) {
//                UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.darkContent, animated: false)
//            }else {
//                // Fallback on earlier versions
//                UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
//            }
//        }else {
//            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
//        }
//    }
    
}
