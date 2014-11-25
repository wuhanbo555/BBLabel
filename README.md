BBLabel
=======

可以设置行间距的Label，支持IOS 5.0及以上版本

使用非常方便，在原有UILabel的属性上添加了.linesSpace属性

每次对BBLabel修改操作之后，如果需要自适应高度，请调用:
(float)wordsDrawInViewHeightWithWidth:(int)width
获得Height之后，重新调整Label的高度
