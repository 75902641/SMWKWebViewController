# WKWebViewPushViewController
封装WKWebView,点击web里的链接跳转到下一页，和原生进入下一页一样有一个push动画，点击返回有一个pop动画，兼容web打电话，js和oc互相调用。
给h5封装一个壳子，首次打开会有一个弹窗，输入要展示的h5地址，在自己的h5页里可以调用pushViewController方法，传入string类型的网址就可以push动画到下一页，点击返回可以返回到上一页。随后完善h5的壳子，h5的小伙伴可以使用这个app实现ios的开发。h5调用ios的方法                    window.webkit.messageHandlers.pushViewController.postMessage("https://www.xxxxx.com"); 程序内附有File.html演示怎样调用。
