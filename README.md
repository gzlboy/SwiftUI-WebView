#  项目适用

在开发过程中，一般都有各种详情页，如产品详情页，详情数据是后端富文本编辑器的html内容，可能是一堆`<p></p><div></div><img />`标签。详情页的基础数据使用ios的原生布局组件显示，如顶部的banner图片切换、产品标题、描述等，而产品详情(一般为图文混排)使用webView渲染显示，我们不期望webView内部的scroll生效，而应该随同级的其他原生组件一起滚动，所以在外层套一个ScrollView用于滚动。测试会遇到webView不显示、高度获取异常等问题，该示例项目就是解决这些问题的。基本原理就是给webView加载完成后把内容高度通知给ios端，动态设置外层ScrollView的高就可以了。

![Untitled](https://github.com/gzlboy/SwiftUI-WebView/assets/1492060/545853fb-1822-4c6d-a1e8-cb46df319452)
