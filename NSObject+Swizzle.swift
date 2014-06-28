//
//  NSObject+Swizzle.swift
//  RexBrowser
//
//  Created by Abc on 14-6-24.
//  Free to use or modify
//


//实现方法置换
//没有找到class_addMethod方法，那私有类中的方法怎么置换呢？只能用Objective-C了

import Foundation
import UIKit

extension NSObject {
    
    /*
    适用于对同一个类中的方法进行置换，newSelector可以是子类方法或是通过extension添加的方法
    新方法添加：
    extension UIWebView {
        func toReplaceLoadRequest(request: NSURLRequest!)
        {
            println("replaced!!!")
            self.toReplaceLoadRequest(request)
        }
    }
    
    置换调用这么写：
    NSObject.swizzleMethod(UIWebView.self,originSelector: "loadRequest:",newSelector:"toReplaceLoadRequest:")
    */
    class func swizzleMethod(targetClass: AnyClass,originSelector: String,newSelector:String) -> Void
    {
        NSObject.swizzleMethod(targetClass,originSelector: originSelector,newClass: targetClass,newSelector:newSelector)
    }
    
    /*
    适用于对不同或相同类中的方法进行置换，(不同类)限父子关系，且使用时要使用子类，不然调用时也找不到方法。比如这样：
    父子类中方法置换：
    RexUIWebView是UIWebView的Swift子类，新方法实现如下：
    class RexUIWebView: UIWebView {
        func toReplaceLoadRequest(request: NSURLRequest!)
        {
            println("replaced!!!")
            let className: CString = object_getClassName(self)
            println(className)
            if className != "UIWebView" {//Swift中RexUIWebView的名字是这样了：_TtC10RexBrowser12RexUIWebView
                self.toReplaceLoadRequest(request)
            }
            else {
                println("[loadRequest] had been swizzled，please use the sub class")
            }
        }
    }
    （防止置换后还直接使用UIWebView而出现找不到方法，增加了一点特别处理)
    
    置换调用这么写：
    NSObject.swizzleMethod(UIWebView.self,originSelector: "loadRequest:",newClass: RexUIWebView.self,newSelector:"toReplaceLoadRequest:")
    
    或者这样：（相同类中方法置换，把方法通过extension添加到原来的类中）
    这么实现：
    extension UIWebView {
        func toReplaceLoadRequest(request: NSURLRequest!)
        {
            println("replaced!!!")
            self.toReplaceLoadRequest(request)
        }
    }

    这么调用
    NSObject.swizzleMethod(UIWebView.self,originSelector: "loadRequest:",newClass: UIWebView.self,newSelector:"toReplaceLoadRequest:")
    */
    class func swizzleMethod(originClass: AnyClass,originSelector: String,newClass: AnyClass,newSelector:String) -> Void
    {
        let originMethod: Method = class_getInstanceMethod(originClass, Selector(originSelector));
        let newMethod: Method = class_getInstanceMethod(newClass, Selector(newSelector));
        if nil != originMethod && nil != newMethod {
            method_exchangeImplementations(originMethod, newMethod)
        }
        else {
            if nil == originMethod {
                println("Can't find origin method,method name:\(originSelector) class:\(originClass)")
            }
            else if nil == newMethod {
                println("Can't find new method  name:\(newSelector) class:\(newClass)")
            }
        }
    }
    
    /**
    置换公开类的私有函数
    
    对要置换的类和方法名拆成两部分。没有找到原来的class_addMethod方法，所以拆类名没什么意义，私有类没法添加方法进去。
    
    如置换私有函数：UIWebView的didFirstLayoutInFrame:frame:
    
    新方法实现如下：
    extension UIWebView {
        func mttDidFirstLayoutInFrame(webView: UIWebView!,frame: AnyObject!) {
            println("didFirstLayoutInFrame replaced!!!!!!!!!!!!!!!!!!!!!")
            self.mttDidFirstLayoutInFrame(webView,frame: frame)
        }
    }
    
    置换调用这么写：
    NSObject.swizzleInstanceMethodWithClassName("UIWebView",originClassNamePart2: "",originClassNSelectorPart1: "webView:di",originClassNSelectorPart2: "dFirstLayoutInFrame:",newClass: UIWebView.self,newSelector: "mttDidFirstLayoutInFrame:frame:")
    **/
    class func swizzleInstanceMethodWithClassName(originClassNamePart1: String,originClassNamePart2: String,originClassNSelectorPart1: String,originClassNSelectorPart2: String,newClass: AnyClass,newSelector: String)
    {
        let className: CString =  (originClassNamePart1 + originClassNamePart2).bridgeToObjectiveC().UTF8String
        println("origin class:\(className)")
        
        let cls :AnyObject! = objc_getClass(className)
        if nil == cls {
            println("Can't get origin class")
            return
        }
        
        println("origin class:[\(cls!)]\n")
        let originSelectorName: String = originClassNSelectorPart1 + originClassNSelectorPart2
        println("originSelectorName:\(originSelectorName)")
        
        NSObject.swizzleMethod(cls!.classForCoder,originSelector: originSelectorName,newClass:newClass,newSelector: newSelector)
    }
    
    /*
    类方法的置换
    */
    class func swizzleClassMethod(originClass: AnyClass,originSelector: String,newClass: AnyClass,newSelector:String) -> Void
    {
        let originMethod: Method = class_getClassMethod(originClass, Selector(originSelector));
        let newMethod: Method = class_getClassMethod(newClass, Selector(newSelector));
        if nil != originMethod && nil != newMethod {
            method_exchangeImplementations(originMethod, newMethod)
        }
        else {
            if nil == originMethod {
                println("Can't find origin class method,method name:\(originSelector) class:\(originClass)")
            }
            else if nil == newMethod {
                println("Can't find new class method  name:\(newSelector) class:\(newClass)")
            }
        }
    }
}