//
//  NSUserDefaults+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let KUserDefaultsKey      = "ud_user_defaults_id"
private let KFirstLaunchKey       = "ud_first_launch"
private let KUserFirstLaunchKey   = "ud_user_first_launch"
private let KUserLoginKey         = "ud_user_login"

extension UserDefaults {

    static var userDefaultsId: String {
        get {
            return UserDefaults.standard.object(forKey: KUserDefaultsKey) as! String
        }
        set {
            UserDefaults.saveStandardDefaults { theStandardDefaults in
                theStandardDefaults.set(newValue, forKey: KUserDefaultsKey)
            }
        }
    }
    
    static var theUserDefaults: UserDefaults? {
        let userKey: String? = UserDefaults.standard.object(forKey: KUserDefaultsKey) as? String
        if userKey != nil {
            return UserDefaults(suiteName: userKey)
        }
        return nil
    }

    static var theStandardDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static func saveUserDefaults(block : (_ theUserDefaults: UserDefaults) -> ()) -> Void {
        if UserDefaults.theUserDefaults != nil {
            block(UserDefaults.theUserDefaults!)
            UserDefaults.theUserDefaults?.synchronize()
        }
    }

    static func saveStandardDefaults(block : (_ theStandardDefaults: UserDefaults) -> ()) -> Void {
        block(UserDefaults.standard)
        UserDefaults.standard.synchronize()
    }

    static func setAPPFirstLaunch() -> Void {
        UserDefaults.saveStandardDefaults { theStandardDefaults in
            theStandardDefaults.set(true, forKey: KFirstLaunchKey)
        }
    }

    static func isAPPFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: KFirstLaunchKey)
    }

    static func setUserFirstLaunch() -> Void {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(true, forKey: KUserFirstLaunchKey)
        }
    }

    static func isUserFirstLaunch() -> Bool {
        return UserDefaults.theUserDefaults?.bool(forKey: KUserFirstLaunchKey) ?? false
    }

    static func setUserLogin() -> Void {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(true, forKey: KUserLoginKey)
        }
    }

    static func setUserLogout() -> Void {
        UserDefaults.saveUserDefaults { theUserDefaults in
            theUserDefaults.set(false, forKey: KUserLoginKey)
        }
    }

    static func isUserLogin() -> Bool {
        return UserDefaults.theUserDefaults?.bool(forKey: KUserLoginKey) ?? false
    }
    
}
