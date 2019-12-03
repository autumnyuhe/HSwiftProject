//
//  HUserDefaults.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let KUSER = "H_USER_DEFAULTS"

//class HUserDefaults : NSObject {
//
//
//    /** 是否登录 */
//    var isLogin: Bool = false
//
//
//    /** 用户ID */
//    var userId: String?
//    var userName: String?
//    var realname: String?
//
//    /** 密码 */
//    var password: String?
//
//    private init?(coder aDecoder: NSCoder) {
//        super.init()
//        var count: UInt32 = 0;
//        //let propertys = class_copyPropertyList(self.classForCoder, &count)
//        let propertys = class_copyIvarList(self.classForCoder, &count)
//        if propertys != nil {
//            for i in 0..<count {
//                let property = propertys![Int(i)]
//                let name = ivar_getName(property)
//                if name != nil {
//                    let key = String(cString: name!)
//                    let value = aDecoder.decodeObject(forKey: key)
//                    self.setValue(value, forKey: key)
//                }
//            }
//            free(propertys)
//        }
//    }
//
//    private func encodeWithCoder(aCoder: NSCoder){
//        var count: UInt32 = 0;
//        //let propertys = class_copyPropertyList(self.classForCoder, &count)
//        let propertys = class_copyIvarList(self.classForCoder, &count)
//        if propertys != nil {
//            for i in 0..<count {
//                let property = propertys![Int(i)]
//                let name = ivar_getName(property)
//                if name != nil {
//                    let key = String(cString: name!)
//                    aCoder.encode(self.value(forKey: key), forKey: key)
//                }
//            }
//            free(propertys)
//        }
//    }
//
////    - (void)encodeWithCoder:(NSCoder *)coder {
////        unsigned int count = 0;
////        Ivar *ivars = class_copyIvarList([self class], &count);
////        for (int i=0; i<count; i++) {
////            Ivar ivar = ivars[i];
////            const char *name = ivar_getName(ivar);
////            NSString *key = [NSString stringWithUTF8String:name];
////            [coder encodeObject:[self valueForKey:key] forKey:key];
////        }
////        free(ivars);
////    }
//
////    - (instancetype)initWithCoder:(NSCoder *)coder {
////        self = [super init];
////        if (self) {
////            unsigned int count = 0;
////            Ivar *ivars = class_copyIvarList([self class], &count);
////            for (int i=0; i<count; i++) {
////                Ivar ivar = ivars[i];
////                const char *name = ivar_getName(ivar);
////                NSString *key = [NSString stringWithUTF8String:name];
////                id value = [coder decodeObjectForKey:key];
////                [self setValue:value forKey:key];
////            }
////            free(ivars);
////        }
////        return self;
////    }
//
//    static var defaults: HUserDefaults = {
////        HKeychainSwift
////        static HUserDefaults *share = nil;
////        static dispatch_once_t predicate;
////        dispatch_once(&predicate, ^{
////            NSString *defaultsUserId = [[HKeyChainStore keyChainStore] stringForKey:KUSER];
////            if (defaultsUserId.length > 0) {
////                NSData *data = [[HKeyChainStore keyChainStore] dataForKey:defaultsUserId];
////                if (data) share = [NSKeyedUnarchiver unarchiveObjectWithData:data];
////            }
////            if (!share || ![share respondsToSelector:@selector(initData)]) {
////                share = HUserDefaults.new;
////            }
////            [share initData];
////        });
////        return share;
//    }()
//
////    + (HUserDefaults *)defaults {
////        static HUserDefaults *share = nil;
////        static dispatch_once_t predicate;
////        dispatch_once(&predicate, ^{
////            NSString *defaultsUserId = [[HKeyChainStore keyChainStore] stringForKey:KUSER];
////            if (defaultsUserId.length > 0) {
////                NSData *data = [[HKeyChainStore keyChainStore] dataForKey:defaultsUserId];
////                if (data) share = [NSKeyedUnarchiver unarchiveObjectWithData:data];
////            }
////            if (!share || ![share respondsToSelector:@selector(initData)]) {
////                share = HUserDefaults.new;
////            }
////            [share initData];
////        });
////        return share;
////    }
//
//    static var defaultsUserId: String? = {
//        var userName = HUserDefaults.defaults.userName
//        if userName != nil {
//            userName = userName?.uppercased()
//        }
//        return userName
//    }()
//
////    + (NSString *)defaultsUserId {
////        NSString *userName = [HUserDefaults defaults].userName;
////        userName = [userName uppercaseString];
////        return userName;
////    }
//
//    //初始化数据
//    func initData() {
//        NotificationCenter.default.addObserver(self, selector: #selector(saveUser), name: UIApplicationWillTerminateNotification, object: nil)
//        [self h_addObserverBlockForKeyPath:@"isLogin" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
//                if ([newVal boolValue]) {
//                    [self saveUser];
//                }else {
//                    [self removeUser];
//                }
//            }];
//        //    [[RACObserve(share, isLogin) skip:1] subscribeNext:^(id  _Nullable x) {
//        //        if ([x boolValue]) {
//        //            [self saveUser];
//        //        }else {
//        //            [self removeUser];
//        //        }
//        //    }];
//    }
////    - (void)initData {
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUser) name:UIApplicationWillTerminateNotification object:nil];
////        [self h_addObserverBlockForKeyPath:@"isLogin" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
////            if ([newVal boolValue]) {
////                [self saveUser];
////            }else {
////                [self removeUser];
////            }
////        }];
////    //    [[RACObserve(share, isLogin) skip:1] subscribeNext:^(id  _Nullable x) {
////    //        if ([x boolValue]) {
////    //            [self saveUser];
////    //        }else {
////    //            [self removeUser];
////    //        }
////    //    }];
////    }
//
//    func saveUser() {
//        if self.isLogin {
//            let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
//            let defaultsUserId = HUserDefaults.defaultsUserId
//            if defaultsUserId!.length > 0 && data != nil {
////                [[HKeyChainStore keyChainStore] setData:data forKey:defaultsUserId];
////                [[HKeyChainStore keyChainStore] setString:defaultsUserId forKey:KUSER];
////                [[HKeyChainStore keyChainStore] synchronizable];
//            }
//        }
//    }
////    - (void)saveUser {
////        if (self.isLogin) {
////            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
////            NSString *defaultsUserId = [HUserDefaults defaultsUserId];
////            if (defaultsUserId.length > 0 && data) {
////                [[HKeyChainStore keyChainStore] setData:data forKey:defaultsUserId];
////                [[HKeyChainStore keyChainStore] setString:defaultsUserId forKey:KUSER];
////                [[HKeyChainStore keyChainStore] synchronizable];
////            }
////        }
////    }
//
//    //加载钥匙串中的数据
//    - (BOOL)loadKeyChainDataWith:(NSString *)userName pwd:(NSString *)pwd {
//        BOOL boolValue = NO;
//        if (userName.length > 3) {
//            NSString *defaultsUserId = [userName uppercaseString];
//            NSData *data = [[HKeyChainStore keyChainStore] dataForKey:defaultsUserId];
//            if (data) {
//                HUserDefaults *userDefaults = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//                id propertyValue = [userDefaults valueForKey:@"password"];
//                //密码不相等则不能提取用户信息
//                if (![pwd isEqualToString:propertyValue]) {
//                    userDefaults = nil;
//                    return boolValue;
//                }
//                boolValue = YES;
//                unsigned int pro_count = 0;
//                objc_property_t *properties = class_copyPropertyList([self class], &pro_count);
//                for (int i = 0; i < pro_count; i ++) {
//                    objc_property_t property = properties[i];
//                    NSString *propertyName = [NSString stringWithFormat:@"%s", property_getName(property)];
//                    //isLogin 这个属性的值由外部业务赋值
//                    if (![propertyName isEqualToString:@"isLogin"]) {
//                        //通过KVC的方式赋值
//                        id propertyValue = [userDefaults valueForKey:propertyName];
//                        [self setValue:propertyValue forKey:propertyName];
//                    }
//                }
//                // 释放
//                userDefaults = nil;
//                free(properties);
//            }
//        }
//        return boolValue;
//    }
//
//    //登出的时候需要移除用户信息
//    - (void)removeUser {
//        //删除记录的登录标志
//        [[HKeyChainStore keyChainStore] setString:nil forKey:KUSER];
//        [[HKeyChainStore keyChainStore] synchronizable];
//        //清空所有属性值
//        [self cleanAllProperties];
//    }
//
//    /**
//    清空属性值
//    */
//    func cleanAllProperties() {
//
//    }
//    - (void)cleanAllProperties {
//        unsigned int pro_count = 0;
//        objc_property_t *properties = class_copyPropertyList([self class], &pro_count);
//        for (int i = 0; i < pro_count; i ++) {
//            objc_property_t property = properties[i];
//            const char *name = property_getName(property);
//            NSString *propertyName = [NSString stringWithUTF8String:name];
//            id propertyValue = [self valueForKey:propertyName];
//
//            //跳过null
//            if (!propertyValue || [propertyValue isKindOfClass:[NSNull class]]) {
//                continue;
//            }
//
//            //通过KVC的方式赋值
//            if ([propertyValue isKindOfClass:[NSString class]]) {
//                [self setValue:@"" forKey:propertyName];
//            }
//            else if ([propertyValue isKindOfClass:[NSNumber class]]) {
//                [self setValue:@(0) forKey:propertyName];
//            }
//            else if ([propertyValue isKindOfClass:[NSMutableDictionary class]] ||
//                     [propertyValue isKindOfClass:[NSDictionary class]]) {
//                [self setValue:@{} forKey:propertyName];
//            }
//            else if ([propertyValue isKindOfClass:[NSMutableArray class]] ||
//                     [propertyValue isKindOfClass:[NSArray class]]) {
//                [self setValue:@[] forKey:propertyName];
//            }
//            else {
//                [self setValue:nil forKey:propertyName];
//            }
//        }
//        // 释放
//        free(properties);
//
//    }
//
//    // 如果属性和字典中的key不一致，可以重写此方法 / 或者readonly
//    // 不一致的key和对应的value都会通过这个方法返回，可以在此方法中做特殊处理
//    - (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//        //NSLog(@"-------> forUndefinedKey:%@  value:%@",key,value);
//    }
//
//
//    - (void)setBaseLink:(NSString *)baseLink {
//        [[NSUserDefaults standardUserDefaults] setObject:baseLink forKey:@"baseLink"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    - (NSString *)baseLink {
//        return [[NSUserDefaults standardUserDefaults] objectForKey:@"baseLink"];
//    }
//
//
//
//    - (void)setH5Link:(NSString *)h5Link {
//        [[NSUserDefaults standardUserDefaults] setObject:h5Link forKey:@"h5Link"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    - (NSString *)h5Link {
//        return [[NSUserDefaults standardUserDefaults] objectForKey:@"h5Link"];
//    }
//
//
//
//    - (void)setPlatCodeLink:(NSString *)platCodeLink {
//        [[NSUserDefaults standardUserDefaults] setObject:platCodeLink forKey:@"platCodeLink"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    - (NSString *)platCodeLink {
//        return [[NSUserDefaults standardUserDefaults] objectForKey:@"platCodeLink"];
//    }
//
//
//    - (void)setSrc1Link:(NSString *)src1Link {
//        [[NSUserDefaults standardUserDefaults] setObject:src1Link forKey:@"src1Link"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    - (NSString *)src1Link {
//        return [[NSUserDefaults standardUserDefaults] objectForKey:@"src1Link"];
//    }
//
//}

