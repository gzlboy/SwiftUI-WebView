//
//  ContentView.swift
//  SwiftUI-WebView
//
//  Created by admin on 2024/3/8.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @State var htmlText = """
        <p style="color:red;">内容啊啊啊啊</p>
        <p><img src="https://img30.360buyimg.com/sku/jfs/t1/151660/31/38872/79400/654771e3Fdd6864fa/eab3e10411499e40.jpg"><img src="https://img30.360buyimg.com/sku/jfs/t1/151660/31/38872/79400/654771e3Fdd6864fa/eab3e10411499e40.jpg"><img src="https://img30.360buyimg.com/sku/jfs/t1/151660/31/38872/79400/654771e3Fdd6864fa/eab3e10411499e40.jpg"><img src="https://img30.360buyimg.com/sku/jfs/t1/151660/31/38872/79400/654771e3Fdd6864fa/eab3e10411499e40.jpg"></p>
        <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
            <p>近期随着iOS14发布，苹果要求更换UIWebView为性能更高的WKWebView。更换的过程中发现在获取WKWebView获取高度经常不准确。经过调研发现WKWebView在解析html的时候和UIWebView有些许不同。</p>
    """
    @State var webHeight:CGFloat? = 1
    
    var body: some View {
        
        ScrollView {
            Text("产品banner")
            Text("产品title")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text("↑↑↑↑↑↑↑↑以上是ios原生组件↑↑↑↑↑↑↑↑")
            Divider()
                .frame(height:10)
                .overlay(.orange)
            Text("↓↓↓↓↓↓↓以下是webview↓↓↓↓↓↓↓")
            WebView(html:$htmlText,webHeight: $webHeight)
                .frame(height: webHeight) // 要动态设置webview的高
                .background(.red)
        }
    }
}

struct WebView: UIViewRepresentable {
    
    @Binding var html: String // html字符串
    @Binding var webHeight:CGFloat? //动态设置父容器scrollView的高
    
    // 注入动态获取内容高的脚本
    let htmlWrap:String = """
        <meta id="Viewport" name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no" />
        <script type="text/javascript">
         let imgArr = document.getElementsByTagName("img");
         for (var i = 0; i <= imgArr.length - 1; i++) {
            (imgArr[i]).onload = function() {
                 // 加载完成后给 webkit 发送通知
                 let height = document.body.scrollHeight;
                 // ios接收器是resetScrollHeight
                  window.webkit.messageHandlers.resetScrollHeight.postMessage(height);
             }
          }
          window.onload=function(){
            window.webkit.messageHandlers.resetScrollHeight.postMessage(document.body.scrollHeight);
          }
         </script>
        <style>html,body{margin:0;padding:0;}img{max-width:100%;}</style>
    """
   
    func makeUIView(context: Context) -> WKWebView {
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator,name:"resetScrollHeight") // 注入js的消息发送函数
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator //设置委托类
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = false //禁用滑动
        
        return webView
    }
     
    func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.loadHTMLString(html + htmlWrap, baseURL: nil)
    }
      
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    class Coordinator: NSObject, WKNavigationDelegate,WKScriptMessageHandler {
        
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // 加载开始
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            //start load
            //print("start load")
        }
        
        // webView加载完成，注意并不是所有图片加载完成
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            //
        }
        
        // 接收js端发送的消息(回调)
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("JS发送到IOS的数据====\(message.body), name=\(message.name)")
            // 关于webView获取高度不准的问题： https://juejin.cn/post/6885902032465575949
            self.parent.webHeight = message.body as? CGFloat
        }
    }
}

#Preview {
    ContentView()
}
