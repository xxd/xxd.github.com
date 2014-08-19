swift站点：
   * [资料汇总](https://swift.zeef.com/robin.eggenkamp)
   * https://github.com/nettlep/learn-swift playground学习
   * http://www.swiftcast.tv/articles?utm_medium=referral&utm_source=swift.zeef.com%2Frobin.eggenkamp&utm_campaign=ZEEF

swift语法教程：
   * http://www.raywenderlich.com/74438/swift-tutorial-a-quick-start

swift项目教程：
   * http://www.raywenderlich.com/76147/uikit-dynamics-tutorial-swift
   * http://www.raywenderlich.com/77878/video-tutorial-introduction-swift-part-8-tuples
   * http://www.raywenderlich.com/76020/using-uigesturerecognizer-with-swift-tutorial
   * http://www.swiftcast.tv/articles/build-a-simple-twitter-ios-app-with-swift

- 【WWDC 2014 例子代码】 Sample Code for WWDC2014 http://t.cn/8FkciaK  http://t.cn/RvizkmQ
- @程寅zju 在他的博客上花3篇博客详细介绍了iOS音频播放相关的知识，有做相关工作的朋友可以参考一下，地址是：http://t.cn/RP72iKX
- @JeOam 根据我上次整理的40个高质量iOS中文博客，定制了一个iOS 优质中文博客搜索： http://t.cn/RPvhXEy ，用它来搜中文的iOS开发知识还挺有用的，我试了一下，命中的质量很高。
- 前两天看到一篇不错的深度文章：《Inside Swift》http://www.eswick.com/2014/06/inside-swift/看完这个大家可以弄明白：1、Swift和Objective-C在运行时的关系 2、Swift做了哪些改进使得它可能比Objective-C更快。 16岁小孩儿写的。
- 乔学士将WWDC官方的视频字幕抓取转换了，地址在：
https://github.com/qiaoxueshi/WWDC_2014_Video_Subtitle 
- 关于Swift的示例程序网上已经很多了，前天又看到有人开源了Swift版的知乎日报，地址是：http://t.cn/RvSaQkQ
- 今天再一次看到一篇讨论Swift性能问题的文章，该文章中提到100万个数的排序，Swift默认情况下需要88秒，感觉这可能是beta版的bug。但也说明Swift在优化上应该还有很长的路要走。感兴趣的可以读一读这篇文章在InfoQ上的翻译：http://www.infoq.com/cn/news/2014/06/apple-swift-performance-hit
- 现在学习swift的权威资料，除了苹果出的官方书籍外，还有今天刚刚放到的WWDC中关于Swift的视频，我今天早上抽空看了，值得大家学习，下载地址是：https://developer.apple.com/videos/wwdc/2014/
- 转发了不少swift的资料，包括开源的示例代码和一些中文翻译。感兴趣的也可以关注我的微博：http://weibo.com/tangqiaoboy
- 《码农周刊》今天已经做了，这期《swift特刊》http://weekly.manong.io/issues/33?ref=swift  ，http://swift.sh/ 是中文论坛中人气最好的。
- onevcat今天就写了一篇文章《行走于 Swift 的世界中》 http://t.cn/RviPoeM  其中讲述了不少swift的细节。你会看到，swift真的不简单。
- 找到一篇做swift 和Objective-C性能测试的文章 :http://www.splasmata.com/?p=2798
- 分享一些学习swift的心得。swift是类型安全（ type safe ) 的语言。但是，由于它有类型推断（type inference） 能力，所以当能推断出类型时，你不必非要写对应的类型。对于 字面量（literal value），整数会被推断成Int，浮点数会被推断成Double类型。但是，它并没有定义整数和浮点之间的加法。所以你如果这么写，就报编译错误：
var a = 1 
var b = 2.0 
var c = a + b // 这一行报错
你需要显式地做类型转换，比如这样：
var a = 1 
var b = 2.0 
var c = Double(a) + b
是不是觉得有点麻烦？告诉你一个好消息，喵神做了一个常用的运算符重载，这样就可以支持整数和浮点数做加法了，地址在这里：https://github.com/onevcat/Easy-Cal-Swift/blob/master/Easy-Cal.swift
- 最近在做涂鸦功能，分享两篇介绍如何让涂鸦笔画平滑的文章，基本原理就是使用bezier曲线，文章地址是：
https://github.com/nixzhu/dev-blog/blob/master/2014-05-27-capture-a-signature-on-ios.md，http://code.tutsplus.com/tutorials/ios-sdk_freehand-drawing--mobile-13164，我的好朋友@糖炒小虾_txx 昨晚利用IDA和method_swizzling 破解了微博SDK的bundle d綁定，这样就可以绕开weibo sdk 的sso 和bundle id綁定的要求。算是OC黑魔法的一次有效实践，博客地址是：http://blog.t-xx.me/blog/2014/05/28/hack-weibo-sdk/ 欢迎大家学习借鉴，但最好别干坏事哈。
- 今天推荐一个iOS开发神器：http://fauxpasapp.com/ ，使用它相当于给自己的项目请了一个专业的 Reviewer，它会指出项目级别上不规范不合理的地方，并且有相关内容的链接可以学习。