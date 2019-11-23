//
//  NSObject+HForwarding.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

public class MyClass {
    public func handler(value1: Int, value2: Double, text: String) {
        print("int=\(value1), double=\(value2), string=\(text)")
    }
}
let myClass = MyClass()

extension NSObject {

    func didChangeValue<Value>(for keyPath: __owned KeyPath<NSObject, Value>, withSetMutation mutation: NSKeyValueSetMutationKind, using set: Set<Value>) where Value : Hashable {
//        NSObject.method(for: <#T##Selector!#>)
        
//        NSMethodSignature *ms =      [[object.target class] instanceMethodSignatureForSelector:object.selector];
        
//        let clos = {() -> () in self.testMethod(); return; }
        
//        let clos = {
//            () -> String in self.testMethod()
//
//            return "试二下"
//
//        }

//        let clos = {
//            (string: String ) -> String in let ss = self.testMethod()
//
//            return ss
//
//        }
        
        
//        let clos = {
//            (string: String ) -> String in let ss = self.testMethod()
//
//            return ss
//
//        }
//
//        clos("试三下")
        
        
//        let funcref: () -> Void = self.testMethod()
//
//        funcref()
        
//        func doStuff (withThis: Any) {}
        func doStuff () {}
        let funcref = doStuff
        funcref()
//        self.perform(<#T##aSelector: Selector!##Selector!#>)
//        NSInvocation
        Timer.scheduledTimer(timeInterval: 9, invocation: nil, repeats: true)
//        didFinishSelector
        
        reflect(myClass.handler).valueType // upd: or myClass.handler.dynamicType
        is
        (Swift.Int, Swift.Double, Swift.String) -> ()
        
        
        let instance : NSObject = fooReturningObjectInstance() as! NSObject
        let selector : Selector = NSSelectorFromString("selectorArg:")
        let methodIMP : IMP! = instance.method(for: selector)
        unsafeBitCast(methodIMP,to:(@convention(c)(Any?,Selector,Any?)->Void).self)(instance,selector,arg)
        
    }
    
    func testMethod() -> Void {

    }
    
//    func testMethod() -> String {
//        return "试一下"
//    }
    
    open func method(for aSelector: Selector!) -> IMP! {
        let selectorString: NSString = NSStringFromSelector(aSelector) as NSString
        
        
        if self.isKind(of: NSClassFromString("UITextInputController")!) || NSStringFromClass(self.classForCoder).hasPrefix("UIKeyboard") || selectorString.isEqual(to: "dealloc") {
            return nil
        }
        
        let count: NSInteger = selectorString.components(separatedBy: ":").count - 1
        var string: String = ":@:"
        for i in 0..<count {
            string = string.appending(":")
        }
        signature
        Method
        return method(for: NSSelectorFromString(string))
    }
    
    + (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
        NSString *selectorString = NSStringFromSelector(aSelector);
        if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
            return nil;
        }
        NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
        NSString *string = @":@:";
        for (int i=0; i<count; i++) {
            string = [string stringByAppendingString:@":"];
        }
        return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
    }
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
        NSString *selectorString = NSStringFromSelector(aSelector);
        if ([self isKindOfClass:NSClassFromString(@"UITextInputController")] || [NSStringFromClass(self.class) hasPrefix:@"UIKeyboard"] || [selectorString isEqualToString:@"dealloc"]) {
            return nil;
        }
        NSUInteger count = [[selectorString componentsSeparatedByString:@":"] count] - 1;
        NSString *string = @":@:";
        for (int i=0; i<count; i++) {
            string = [string stringByAppendingString:@":"];
        }
        return [NSMethodSignature signatureWithObjCTypes:[string UTF8String]];
    }
    + (void)forwardInvocation:(NSInvocation *)anInvocation {}
    - (void)forwardInvocation:(NSInvocation *)anInvocation {}


}


class Test : NSObject
{
    @objc var name : String? {
        didSet {
            NSLog("didSetCalled")
        }
    }

    func invocationTest() {
        
        let invocation : NSObject = unsafeBitCast(method_getImplementation(class_getClassMethod(NSClassFromString("NSInvocation"), NSSelectorFromString("invocationWithMethodSignature:"))!),to:(@convention(c)(AnyClass?,Selector,Any?)->Any).self)(NSClassFromString("NSInvocation"),NSSelectorFromString("invocationWithMethodSignature:"),unsafeBitCast(method(for: NSSelectorFromString("methodSignatureForSelector:"))!,to:(@convention(c)(Any?,Selector,Selector)->Any).self)(self,NSSelectorFromString("methodSignatureForSelector:"),#selector(setter:name))) as! NSObject
        
        unsafeBitCast(class_getMethodImplementation(NSClassFromString("NSInvocation"), NSSelectorFromString("setSelector:")),to:(@convention(c)(Any,Selector,Selector)->Void).self)(invocation,NSSelectorFromString("setSelector:"),#selector(setter:name))
        
        var localName = name
        
        withUnsafePointer(to: &localName) { unsafeBitCast(class_getMethodImplementation(NSClassFromString("NSInvocation"), NSSelectorFromString("setArgument:atIndex:")),to:(@convention(c)(Any,Selector,OpaquePointer,NSInteger)->Void).self)(invocation,NSSelectorFromString("setArgument:atIndex:"), OpaquePointer($0),2) }
        
        withUnsafePointer(to: &localName) {
            unsafeBitCast(class_getMethodImplementation(NSClassFromString("NSInvocation"),
                                                        NSSelectorFromString("setArgument:atIndex:")),
                          to:(@convention(c)(Any,Selector,OpaquePointer,NSInteger)->Void).self)(invocation,NSSelectorFromString("setArgument:atIndex:"),
                                                                                                                                                                            OpaquePointer($0),2)
        }
        
        invocation.perform(NSSelectorFromString("invokeWithTarget:"), with: self)
    }
}


private var dispatchOnceToken: dispatch_once_t = 0

private var selectors: [Selector] = [
    "performSelector:",
    "performSelector:withObject:",
    "performSelector:withObject:withObject:",
    "performSelector:withObject:afterDelay:inModes:",
    "performSelector:withObject:afterDelay:",
]

private func swizzle() {
    dispatch_once(&dispatchOnceToken) {
        for selector: Selector in selectors {
            let 🚀selector = Selector("🚀\(selector)")
            let method = class_getInstanceMethod(NSObject.self, selector)

            class_replaceMethod(
                NSObject.self,
                🚀selector,
                method_getImplementation(method),
                method_getTypeEncoding(method)
            )
        }
    }
}

extension NSObject {

    func 🚀performSelector(selector: Selector) -> AnyObject? {
        swizzle()
        return self.🚀performSelector(selector)
    }

    func 🚀performSelector(selector: Selector, withObject object: AnyObject?) -> AnyObject? {
        swizzle()
        return self.🚀performSelector(selector, withObject: object)
    }

    func 🚀performSelector(selector: Selector, withObject object1: AnyObject?, withObject object2: AnyObject?) -> AnyObject? {
        swizzle()
        return self.🚀performSelector(selector, withObject: object1, withObject: object2)
    }

    func 🚀performSelector(selector: Selector, withObject object: AnyObject?, afterDelay delay: NSTimeInterval, inModes modes: [AnyObject?]?) {
        swizzle()
        self.🚀performSelector(selector, withObject: object, afterDelay: delay, inModes: modes)
    }

    func 🚀performSelector(selector: Selector, withObject object: AnyObject?, afterDelay delay: NSTimeInterval) {
        swizzle()
        self.🚀performSelector(selector, withObject: object, afterDelay: delay)
    }

}
