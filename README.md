Swift Swizzle
============

Feel free to use or modify.

Swizzle pulbic and private method on public class by swift

1、Swizzle public api
We will swizzle method "loadRequest:" of UIWebView.
extension UIWebView {
        func toReplaceLoadRequest(request: NSURLRequest!)
        {
            println("replaced!!!")
            self.toReplaceLoadRequest(request)
        }
    }
    
    then call like this:
    NSObject.swizzleMethod(UIWebView.self,originSelector: "loadRequest:",newSelector:"toReplaceLoadRequest:")
    
    
2、Swizzle private api
We will swizzle method "didFirstLayoutInFrame:frame:" of UIWebView.
extension UIWebView {
        func mttDidFirstLayoutInFrame(webView: UIWebView!,frame: AnyObject!) {
            println("didFirstLayoutInFrame replaced!!!!!!!!!!!!!!!!!!!!!")
            self.mttDidFirstLayoutInFrame(webView,frame: frame)
        }
    }
    
    then call like this:
    NSObject.swizzleInstanceMethodWithClassName("UIWebView",originClassNamePart2: "",originClassNSelectorPart1: "webView:di",originClassNSelectorPart2: "dFirstLayoutInFrame:",newClass: UIWebView.self,newSelector: "mttDidFirstLayoutInFrame:frame:")
