# WKWebViewPushViewController
# 前言
给H5提供一个app ios的外壳，封装WKWebView，和原生进入下一页一样有一个pushViewController/presentViewController动画，点击返回有一个popViewControllerAnimated/dismissViewControllerAnimated动画，兼容web打电话，js和oc互相调用，消息推送等功能。

# 使用说明
每次打开app会有一个弹窗，可以输入自己的网址，然后选择想要的效果，效果有默认、present、push、js:
默认:(必须输入网址)所有h5的展现，只在一个viewController里展现，没有任何动效。
present：(必须输入网址)每当打开一个新的网页，都会有presentViewController动画效果(从下往上推的效果)，每次打开一个新的网页也就创建一个新的viewController来展示当前的网页，点击返回按钮就会从上向下消失的效果。
push:(可以不输入网址)每当打开一个新的网页，都会有pushViewController动画效果(从右往左进入的效果)，每次打开一个新的网页也就创建一个新的viewController来展示当前的网页。点击返回按钮就会从左往右消失的效果。
js:(可以不输入网址)效果和push效果一样，就是返回键是由js控制。
以上是给大家展示的效果，在项目中上面所有的功能可以混合着用，可以使用默认的效果，由js调用app实现想要的效果，例如:
h5在当前页面不想打开新的viewController来展示，当需要打开一个新的界面就调用pushViewController方法，当点击返回不想返回到上一页想返回到指定页面，就调用app返回的方法，app会触发js的方法，由js来控制应该去哪一页。

# 功能点和函数调用
1.js获取ios的deviceToken，服务器可以根据deviceToken给app发推送

2.开通相机、蓝牙、通讯录、定位、麦克风、媒体库访问权限

3.pushViewController:
js调用pushViewController需要传入一个url的参数，url是希望下一个界面展现的网址，如下
window.webkit.messageHandlers.pushViewController.postMessage("https://www.xxxxx.com");

4.getDeviceToken:
js调用getDeviceToken函数时会触发app的getDeviceToken函数，当app获取到deviceToken时触发js的getDeviceTokenFunc()函数并把deviceToken返回去，如下:
window.webkit.messageHandlers.getDeviceToken.postMessage("");//去客户端拿deviceToken从下面的方法返回得到
function getDeviceTokenFunc(d) {//此函数是写在js里 获取deviceToken 从d传回来

}

5.rightBarButtonItemWithTitle:
js调用rightBarButtonItemWithTitle函数，app会在导航的右上角创建按钮，点击的时候会触发js的pressRightButton()函数，js可以对此进行处理
window.webkit.messageHandlers.rightBarButtonItemWithTitle.postMessage("h5按钮");
function pressRightButton() {

}    

6.popViewControllerAnimatedFunc:
js调用popViewControllerAnimatedFunc函数时需要传入一个type值，"0"不要动画、"1"要动画，触发后app会返回上一页。
window.webkit.messageHandlers.popViewControllerAnimatedFunc.postMessage("1");
                       
7.popToRootViewControllerAnimatedFunc:
js调用popToRootViewControllerAnimatedFunc函数时需要传入一个type值，"0"不要动画、"1"要动画，触发后app会返回首页，就当前堆栈的第一页。
window.webkit.messageHandlers.popToRootViewControllerAnimatedFunc.postMessage("1");

8.goBackFunc:
js调用goBackFunc函数，app会先判断当前h5页面是否可以canGoBack，如果yes则goBack，此函数用于一个网页加载多个h5点击返回按钮的时候。
window.webkit.messageHandlers.goBackFunc.postMessage("");

9.openTheCameraFunc:
js调用openTheCameraFunc函数，app会打开手机相机，拍照完的图片返回给js。
window.webkit.messageHandlers.openTheCameraFunc.postMessage("");

function selectImage(image){

}

10.openAlbumFunc:
js调用openAlbumFunc函数，app会打开手机相册，选择的图片返回给js。
window.webkit.messageHandlers.openAlbumFunc.postMessage("");

function selectImage(image){

}

11.当点击拍照或者相册的取消按钮，会触发js的imageimageDidCancel()函数

function imageDidCancel(){

}

12.当选择图片失败，会触发js的uploadingImageFailed()函数

function uploadingImageFailed(){

}




