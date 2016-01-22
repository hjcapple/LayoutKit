# LayoutKit
使用 swift 编写的 view 布局库

## 需要解决的问题
iOS 开发时，为了适应多种屏幕尺寸，通常会使用 AutoLayout。但 AutoLayout 有些问题：

* 没有占位符。导致有些界面配置使用一些看不见的占位 View。
* 需要配置很多约束，就算使用一些 AutoLayout 布局库，约束设置也很繁琐。
* 一些很常见的界面布局，用 AutoLayout 居然也难以表述。

比如
### 界面1

![example0](./images/example0.png)

这种布局在 TableView Cell 中很常见，左边是一张图片，图片距离上、下、左都是 10 point。中间是字体不同的几个单行 Label，几个 Label 整体需要上下居中，最靠右是时间标签，距离右边也是 10 point。

这种布局，用 AutoLayout 表示，通常需要将几个 Label 放到一个看不见的 View 上面，之后配置一系列繁琐的约束。

### 界面2

![example1](./images/example1.png)

有三个按钮，已经知道大小，比如大小都是 44 * 44。之后需要上下居中，左右排列。并且使得间距 1、2、3、4 都相等。

这种布局也很常见，但用 AutoLayout 配置起来也十分麻烦。

另外 AutoLayout 还有一个小小的性能问题，需要动态求解约束，这个问题平时问题不大，但在一些复杂的界面，比如复杂的滚动列表中，假如 TableView Cell 中出现太多不必要的占位 View, 太多约束，快速滚动时就不够流畅。

为此基于传统的 Frame 布局，编写了这个 LayoutKit。但我绝对没有否认 AutoLayout 的作用，比如文字自动适配，基于各个子 View 的大小自动算出父 View 的大小，这种传统的 Frame 布局是做不到的。AutoLayout 和 Frame 布局可以结合起来使用，各取优缺点。

另外提一点，在 xib 或者 storyboard 中拖拉 AutoLayout 的约束，简直是反人类。

## 使用例子
下面给出上面两个界面布局，用 LayoutKit 实现的例子，使大家有个直观的初步的认识。

### 界面1

	self.tk_layoutSubviews { make in
	    // 1
	    let iconHeight = make.yFlexibleValue(10, make.flexible, 10)
	    // 2
	    make.size(iconView) == (iconHeight, iconHeight)
	    // 3
	    make.sizeToFit(titleLabel, detailLabel, longDetalLabel, timeLabel)
	    // 4
	    make.xAlign(10, iconView, 10, titleLabel, make.flexible, timeLabel, 10)
	    // 5
	    make.ref(titleLabel).xLeft(detailLabel, longDetalLabel)
	    // 6
	    make.yCenter(iconView, timeLabel)
	    // 7
	    make.yAlign(make.flexible, titleLabel, 6, detailLabel, longDetalLabel, make.flexible)
	}
	
1. 算出 icon 的高度。
2. 设置 icon 的大小。
3. 设置各个 Label 的大小。
4. 左右依次排列，icon，titleLabel, timeLabel，并设置好各自的间距。
5. 根据 titleLabel 的位置左对齐，detailLabel, longDetalLabel。
6. iconView, timeLabel 上下居中。
7. 上下排列 titleLabel，detailLabel, longDetalLabel，并居中。

### 界面 2
    self.tk_layoutSubviews { make in
        
        // 1
        make.size(redView, blueView, greenView) == (80, 80)
        
        let F = make.flexible
        // 2
        make.xAlign(F, redView, F, blueView, F, greenView, F)
        // 3
        make.yCenter(redView, blueView, greenView)
    }
    
1. 设置各个 view 的大小。
2. 左右排列 redView, blueView, greenView，并设置好各自的间距。
3. 各个 view 上下居中。

配置布局，大致分解成 3 步

1. 设置大小。
2. 左右排列各个 view。(水平方向，也就是x方向）
3. 上下排列各个 view。(垂直方向，也就是y方向）

LayoutKit 将所有的 view 作为一个整体，一次排列多个 view。


	





