Swift Swizzle
============

Feel free to use or modify.

Swizzle pulbic or private method on public class by swift.

1、Swizzle public api.<br>
We will swizzle method "loadRequest:" of UIWebView.
<pre>
extension UIWebView {
    func toReplaceLoadRequest(request: NSURLRequest!)
        {
            println("loadRequest replaced!")
            self.toReplaceLoadRequest(request)
        }
    }
</pre>
Then call like this:<br>
<pre>
    NSObject.swizzleMethod(UIWebView.self,originSelector: "loadRequest:",newSelector:"toReplaceLoadRequest:")
</pre>
    
    
2、Swizzle private api.<br>
We will swizzle method "didFirstLayoutInFrame:frame:" of UIWebView.
<pre>
extension UIWebView {
        func mttDidFirstLayoutInFrame(webView: UIWebView!,frame: AnyObject!) {
            println("didFirstLayoutInFrame replaced!")
            self.mttDidFirstLayoutInFrame(webView,frame: frame)
        }
    }
    </pre>
Then call like this:<br>
<pre>
    NSObject.swizzleInstanceMethodWithClassName("UIWebView",originClassNamePart2: "",originClassNSelectorPart1: "webView:di",originClassNSelectorPart2: "dFirstLayoutInFrame:",newClass: UIWebView.self,newSelector: "mttDidFirstLayoutInFrame:frame:")
</pre>
