# WKWebViewPushViewController
给H5提供一个app的外壳，封装WKWebView，和原生进入下一页一样有一个push动画，点击返回有一个pop动画，兼容web打电话，js和oc互相调用，消息推送。

给h5封装一个壳子，首次打开会有一个弹窗，输入要展示的h5地址，在自己的h5页里可以调用pushViewController方法，传入string类型的网址就可以push动画到下一页，点击返回可以返回到上一页。随后完善h5的壳子，h5的小伙伴可以使用这个app实现ios的开发。h5调用ios的方法                    window.webkit.messageHandlers.pushViewController.postMessage("https://www.xxxxx.com"); 程序内附有File.html演示怎样调用。

增加推送，js获取ios的deviceToken，服务器可以根据deviceToken给app发推送

增加相机、蓝牙、通讯录、定位、麦克风、媒体库访问权限

增加选择默认加载还是pushViewController动画加载。（可以用默认的js来控制pushViewController，也可以在弹框上选择pushViewController动画）

增加选择默认加载还是presentViewController动画加载。（可以用默认的js来控制presentViewController，也可以在弹框上选择presentViewController动画）





Give H5 an app shell, wrap WKWebView, and have a push animation just like the next page. Click to return to have a pop animation, compatible with web calls, js and oc call each other, message push.

Package a shell for h5. For the first time, there will be a popup window. Enter the h5 address to be displayed. In your own h5 page, you can call the pushViewController method. If you pass the string type URL, you can push the animation to the next page. Click to return. You can return to the previous page. Then improve the shell of h5, h5's small partners can use this app to achieve ios development. H5 calls the ios method window.webkit.messageHandlers.pushViewController.postMessage("https://www.xxxxx.com"); The program contains the File.html demo to call.

Add push, js get ios deviceToken, the server can push the app according to deviceToken

Add camera, Bluetooth, contacts, location, microphone, media library access

Increase the selection of the default load or the pushViewController animation load. (You can use the default js to control the pushViewController, or you can select the pushViewController animation on the bullet box.)

Increase the selection of the default load or the presentViewController animation load. (You can use the default js to control the presentViewController, or you can select the presentViewController animation on the bullet box.)
