//
//  HCServiceViewController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HCServiceViewController: UIViewController {
    
    typealias multipyClosure = (_ a: Int, _ b: Int) -> Int

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "客服"
        
//        let multipyClosure2 = { //实现一个闭包
//            (a:Int,b:Int) in
//            a * b
//        }
        
        
        
//        multipyClosure    () -> ()    0x000000010235df8c HSwiftProject`closure #1 (Swift.Int, Swift.Int) -> Swift.Int in HSwiftProject.HCServiceViewController.viewDidLoad() -> () at HCServiceViewController.swift:19
//        let count = handler(2, 3, operation: multipyClosure) //将闭包作为参数传递
//        let count = self.handler(2, operation: multipyClosure)
//        let count = self.handler(2, operation: multipyClosure2)
////        self.perform(#selector(self.handler(_:operation:)), with: 2, with: multipyClosure2 )
//        let unmanaged = self.perform(#selector(self.testSwift))?.takeUnretainedValue()  as! multipyClosure
////        self.performWithUnretainedValue(#selector(self.testSwift), withPre: "pvc_")
//        let ff: multipyClosure = self.performWithRetainedValue(#selector(self.testSwift), withPre: "") as! multipyClosure
//        NSLog("\(count)")
//
////        Thread.detachNewThreadSelector(#selector(self.handler(operation:)), toTarget: self, with: multipyClosure2)
//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handler(operation:)), userInfo: multipyClosure2, repeats: false)
//        NSLog("\(count)")
//        Thread.detachNewThreadSelector(Selector("greetings:"), toTarget:self, withObject: "sunshine")
    }
    

//    func handler(_ a: Int, _ b: Int,operation:(Int,Int)->Int) ->Int {
//        let res = operation(a,b)
//        return res
//    }
//    @objc func handler(_ a: Int,operation: inout (Int,Int)->Int) ->Int {
//        let res = operation(a,a)
//        return res
//    }
    
    @objc func testSwift() -> multipyClosure {
        NSLog("")
        let multipyClosure2 = { //实现一个闭包
            (a:Int,b:Int) in
            a * b
        }
        return multipyClosure2
    }
    
    @objc func pvc_testSwift() -> Void {
        NSLog("")
    }

    @objc func handler(_ a: Int, operation: @escaping multipyClosure) ->Int {
        let res = operation(a,a)
        return res
    }
    
    @objc func handler(operation: @escaping multipyClosure) ->Int {
        let res = operation(2,2)
        return res
    }
    
//    let multipyClosure = { //实现一个闭包
//        (a:Int,b:Int) in
//        a * b
//    }

    

}
