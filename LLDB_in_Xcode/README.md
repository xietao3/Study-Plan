> WWDC 2018 Session 412 : [Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412/)


## 前言

在程序员写 bug 的职业生涯中，只有 bug 会永远陪伴着你，如何处理与 bug 之间的关系，是每一位程序员的必修课。特别是入门程序员经常受 bug 的影响，熬夜加班压力大，长痘长胖还脱发。

每一位 iOS 和 macOS 开发者都是幸运的，因为苹果的 Xcode 和 LLDB 调试工具，这是每一位开发者应该使用的调试神器，可以帮助我们更快地解决问题。本文将主要讲解 Xcode 的 **断点调试** 、**LLDB 调试器** 以及 **视图结构调试**（UI Hierarchy）的使用技巧，这些技巧将大幅减少调试中重新编译的次数，减少你的等待时间。

这些技巧使用起来非常简单，而且在开发场景非常实用，每一位开发者都有必要掌握这些技巧。


## 一、提升 Swift 调试可用性 （Swift Debugging Reliability）

### 1.1 解决从 AST context 获取模块失败问题（Failed to get module from AST context）

相信很多开发者在使用 Swift 的时候，调试过程中的一些问题会让你很头痛。
比如说下面这个问题，LLDB 在 AST Context 重建编译状态时，有些时候在复杂的情况下可能无法检测到部分模块的变化，于是调试器提示``Failed to get module from AST context``。

![](https://user-gold-cdn.xitu.io/2018/6/10/163e925acd190891?w=1384&h=581&f=jpeg&s=134767)

在 Xcode 10 中，为了应对这个问题，会为当前的 frame 调用栈创建一个新的 expression evaluator 。

![](https://user-gold-cdn.xitu.io/2018/6/10/163e925f08d3858e?w=1384&h=581&f=jpeg&s=93068)

### 1.2 解决 Swift 类型问题（Swift Type Resolution）

还有一些开发者会遇到在调试的时候无法显示变量类型、打印变量信息的问题如下图：

![](https://user-gold-cdn.xitu.io/2018/6/10/163e927ebe99bb83?w=1322&h=578&f=jpeg&s=87342)

苹果针对大量的错误报告进行追踪，在 Xcode 10 中修复了这个 bug ，调试信息中将不再会出现此类错误。

![](https://user-gold-cdn.xitu.io/2018/6/10/163e92811fe45906?w=1322&h=578&f=jpeg&s=93289)


## 二、吐血推荐的调试小技巧（Advanced Debugging Tips and Tricks）

### 2.1 自动创建调试标签页（Configure behaviors to dedicate a tab for debugging）

想必你经常在看代码的时候由于执行到断点而被强行切换到断点所在的页面，在断点页面和之前页面进行切换的体验是非常差的。现在你可以设置在被断点的时候自动新建一个标签页，通过切换标签页你可以快速便捷地切回到之前浏览的页面。

![](https://user-gold-cdn.xitu.io/2018/6/10/163e946beb69b20c?w=1534&h=190&f=png&s=43761)

设置自动新建 Debug Tab 方法：顶部导航栏 Xcode -> Behaviors -> Edit Behaviors... -> Runing -> Pauses -> ✅ Show Tab Name ``tab name`` in ``active window``。

![](https://user-gold-cdn.xitu.io/2018/6/10/163e94c35d019c1f?w=1824&h=1324&f=png&s=444942)

### 2.2 在 LLDB 中修改 App 状态（LLDB expressions can modify program state）

在 LLDB 中通过``expression``命令可以改变程序当前的各种状态，``e``、``expr`` 作为简写也可以实现同样的功能。我们用一个简单的``UILabel``来举例，为``myLabel``设置一个值 hello ， 正常来讲视图上的``myLabel``就应该显示 hello 。

```
func test() -> Void {
myLabel.text = "hello"
// 断点 -> 
}
```

你可以在``myLabel.text = "hello"``这句代码后设置一个断点，运行程序执行断点后，在控制台的 LLDB 调试器 中输入下面的表达式改变它的值，在继续运行程序之后，相信你在界面上看到的值一定是 hello world 。

```
// 改变 myLabel 文案
expr myLabel.text = "hello world"
```


![](https://user-gold-cdn.xitu.io/2018/6/10/163e9b2cf444a861?w=1280&h=256&f=png&s=59224)

除了改变``myLabel.text``的值之外，你可以像在 Xcode 中写代码一样，在 LLDB 中进行同样的操作。例如你可以像下面的代码一样使用表达式改变它的文字颜色，也可以执行某个函数。

```
// 改变 myLabel 文字颜色
expr myLabel.textColor = UIColor.red

// 执行 test 方法
expr test()
```

### 2.3 利用断点实时插入代码（Use auto-continuing breakpoints with debugger commands to inject code live）

除了直接在控制台通过 LLDB 调试器修改 App 状态，你还可以通过在断点中添加命令来实现同样的功能。而且通过断点来设置调试命令的方式更加方便实用，几乎是实时插入代码的功能。

如下图，设置一个断点，通过 Edit Breakpoint... 打开编辑框，你可以将多个不同的调试命令按顺序填入 Action 中，就能实现之前同样的功能。另外你可以勾选  Automatically continue after evaluationg actions ，可以自动继续执行后续代码，而不会停在这一行。
![](https://user-gold-cdn.xitu.io/2018/6/10/163e9c26031edf00?w=1092&h=804&f=png&s=137228)

### 2.4 在汇编调用栈中打印函数实参（"po \$arg1" ($arg2, etc) in assembly frames to print function arguments）

首先，我们了解一下全局断点，你可以点击在 Breakpoints Navigator 左下角 + 号，然后选择 Symbolic Breakpoint... ，如下图，你可以在 Symbol 一栏输入任何你想监听的函数比如``[UILabel setText:]``，之后所有页面下的所有``UILabel``类型对象在设置``text``属性的时候都会执行该断点。（ps：我还不是最酷的😎）

![](https://user-gold-cdn.xitu.io/2018/6/10/163e9efdd0eb1e68?w=3104&h=1978&f=png&s=574184)

在这个断点的控制台中，并没有显示变量属性等信息，我们怎么能知道设置了什么呢？接下来我们可以用``$arg1``、``$arg2``等命令来打印出我们想要的信息。

如下图，在这里``$arg1``是指对象本身，``$arg2``是对象被调用的函数，``po``命令无法直接输出函数名，需要加上``(SEL)``，``$arg3``是被赋给``text``的值。

![](https://user-gold-cdn.xitu.io/2018/6/10/163ea00e6f7ab42a?w=1062&h=434&f=png&s=64979)


### 2.5 利用 “breakpoint set --one-shot true” 命令创建一次性断点（Create dependent breakpoints using ）

上面我们介绍了全局断点，它能监测到全局的函数调用，但是我想监测某一个函数内局部区域的函数调用，这个时候我们可以使用``breakpoint set --one-shot true``命令动态生成一个断点，这个断点将是一次性的，执行一次后将被自动删除。

最酷的是，我们将创建会先一个断点,如下图，让这个断点来实现这一切，即用一个断点来创建另外一个一次性的断点，为了让整个过程是无感的，我建议勾选  Automatically continue after evaluationg actions 选项。

![](https://user-gold-cdn.xitu.io/2018/6/10/163ea313aa24d063?w=1226&h=508&f=png&s=130774)

上图这个断点到底干了什么？当执行到图中第 61 行的断点时，这个断点并不会导致命令执行暂停，它只干了一件事，就是通过命令``breakpoint set --name "[UILabel setText:]"``创建了一个全局断点，加上``--one-shot true``就代表是一次性的断点。

如上图的执行效果就是``breakpoint set --one-shot true --name "[UILabel setText:]"``命令会让指针在``myLabel.text = "hello"``这一行暂停，暂停后一次性的使命就已经结束，所以在下一行``myLabel.text = "hello world"``是不会暂停的。

### 2.6 通过拖拽指令指针或 “thread jump --by 1” 命令跳过一行代码（Skip lines of code by dragging Instruction Pointer or “thread jump --by 1” ）

首先我们看如何通过拖拽指令指针来，跳过一段代码不执行。如下图，直接拖拽红色箭头指向的按钮，拖到哪从哪里开始执行，往上拖可以重复执行之前的代码，往下拖将不执行中间被跳过的代码。

![](https://user-gold-cdn.xitu.io/2018/6/10/163ea53678d5e902?w=1318&h=270&f=png&s=49832)

我们通过``thread jump --by 2``命令，跳过了 2 行代码，如下图将只打印 1 和 4 。
![](https://user-gold-cdn.xitu.io/2018/6/11/163ea6edb2451f2f?w=1012&h=510&f=png&s=108473)

### 2.7 利用 watchpoints 监听变量的变化（Pause when variables are modified by using watchpoints）

上面我们介绍了使用全局断点和一次性断点对``[UILabel setText:]``函数监听属性的变化，其实我们还有另一个选择，
使用 watchpoints 通过监测内存的变化来监听属性的变化。

我们可以在``viewDidLoad``函数中设置一个断点，然后再控制台找到你需要监听的属性，如下图：

![](https://user-gold-cdn.xitu.io/2018/6/12/163efb9bb0924e67?w=946&h=228&f=png&s=50242)

选中你想要监听的属性后，点击右键将弹出下图窗口，点击 Watch "count"即可监听属性 count 的值的改变，如执行``count+=1``。需要注意的是每当重新编译后指针发生变化，就需要重新设置 watchpoints 。

![](https://user-gold-cdn.xitu.io/2018/6/12/163efc02bd236d5d?w=289&h=400&f=png&s=79653)

### 2.8  Swift 调用栈中在 LLDB 调试器使用 Obj-C 代码命令（Evaluate Obj-C code in Swift frames with “expression -l objc -O -- <expr>”）

在日常调试中，使用 LLDB 命令``po [self.view recursiveDescription]``命令来输出页面视图结构是非常方便的，然而我们在 Swift 调用栈中使用这个命令的时候将打印以下错误：

```
po self.view.recursiveDescription()
error: <EXPR>:3:6: error: value of type 'UIView?' has no member 'recursiveDescription'
self.view.recursiveDescription()
~~~~~^~~~ ~~~~~~~~~~~~~~~~~~~~
```

其实我们可以通过“expression -l objc -O -- <expr>”命令来使用 Obj-C 代码来输出我们想要的视图结构，记得``self.view``两边一定要加上 \` 符号。

```
expression -l objc -O -- [`self.view` recursiveDescription]
```

不知道你们有没有觉得上面这个命令有点长，还好我们可以可以通过``command alias <alias name> expression -l objc -O —-`` 为这句命令建立一个别名，之后就可以通过别名来使用相关操作。

![](https://user-gold-cdn.xitu.io/2018/6/12/163eff30cd98f018?w=1216&h=220&f=png&s=49918)

再另一种方式，我们可以使用``po unsafeBitCast(<pstr> , UnsafePointer.self)``命令打印对象描述、中心点坐标，当然也可以设置相关属性。

```
// 打印对象
(lldb) po unsafeBitCast(0x7fe439d13160, UILabel.self)
<UILabel: 0x7fe439d13160; frame = (57 141; 42 21); text = 'Label'; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x600003942a30>>

// 打印中心点坐标
(lldb) po unsafeBitCast(0x7fe439d13160, UILabel.self).center
▿ (78.0, 151.5)
- x : 78.0
- y : 151.5

// 设置中心点坐标
(lldb) po unsafeBitCast(0x7fe439d13160, UILabel.self).center.y = 300
```

### 2.9 利用 “expression CATransaction.flush()” 命令刷新页面（Flush view changes to the screen using “expression CATransaction.flush()”）

你可以在控制台通过 LLDB 调试器中改变 UI 的坐标值，但你并不能立即看到页面有任何改变。事实上你确实修改了它的值，你只是需要使用``“expression CATransaction.flush()”``来刷新一下你的页面。

配合修改 UI 坐标值的命令一起使用，你能看到你的模拟器正在发生令人振奋的一幕。

```
// 修改坐标点
po unsafeBitCast(0x7fe439d13160, UILabel.self).center.y = 300
// 刷新页面
expression CATransaction.flush()
```

### 2.10 利用别名和脚本添加自定义 LLDB 命令（Add custom LLDB commands using aliases and scripts）

当你对 LLDB 命令越来越了解，操作越来越骚的时候，你会发现小小的控制台会限制你的发挥，这个时候你需要一个更大的舞台。

现在我要展示如何使用 Python 脚本执行命令，你需要先下载一 个[nudge.py](https://developer.apple.com/sample-code/wwdc/2018/UseScriptsToAddCustomCommandsToLLDB.zip) ，这是苹果开发工程师为我们准备好的 Python 脚本，它可以帮助我们简单、快速地移动 UI 控件。我们需要将 [nudge.py](https://developer.apple.com/sample-code/wwdc/2018/UseScriptsToAddCustomCommandsToLLDB.zip) 文件放入你的用户根目录``~/nudge.py``。

下一步我们需要在用户根目录下新建一个``~/.lldbinit``文件，并加入下方命令和别名：

```
command script import ~/nudge.py
command alias poc expression -l objc -O --
command alias 🚽 expression -l objc -- (void)[CATransaction flush]
```

做完这些，我们就可以来使用我们的自定义命令``nudge x-offset y-offset [view]``了，具体用法如下：

```
// 引用 nudge
(lldb) command script import ~/nudge.py
The "nudge" command has been installed, type "help nudge" for detailed help.

// 拿到对象指针
(lldb) po myLabel
▿ Optional<UILabel>
- some : <UILabel: 0x7fc04a60fff0; frame = (57 141; 42 21); text = 'Label'; opaque = NO; autoresize = RM+BM; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x600001d36c10>>

// Y轴向上偏移5
(lldb) nudge 0 -5 0x7fc04a60fff0
```

调整模拟器中控件位置的效果：

![](https://user-gold-cdn.xitu.io/2018/6/12/163f2c28cf4b078e?w=1000&h=570&f=gif&s=4115526)

### 2.11 LLDB 打印命令（LLDB Print Commands）

Command|Alias For|Steps TO Evaluate
-|-|-
po ``<expression>``|expression --object-description -- ``<expression>``|1. Expression: evaluate <expression><br>2. Expression: debug description
p <expression>|expression -- <expression>|1. Expression: evaluate <expression><br>2. Outputs LLDB-formatted description|
frame variable <name>|none|1. Reads value of <name> from memory<br>2. Outputs LLDB-formatted description

p 和 po 命令从别名和执行过程上来看，分别输出的是对象和 LLDB 格式数据。

而 frame variable 不同之处的是从当前 frame 调用栈的内存中拿到的值。只接受变量作为参数，不接受表达式。通过``frame variable ``命令，可以打印出当前 frame 调用栈的的所有变量。

## 三、深入了解 Xcode 视图调试技巧（Advanced View Debugging）

### 3.1 在调试导航栏中快速定位到视图位置（Reveal in Debug Navigator）

在开发中我们会频繁使用到 Debug View Hierarchy 查看当前页面视图结构，正常情况下导航栏的 UI 嵌套层级会非常多，让我们无法快速准确找到我们想查看的控件所在的层级。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f30b7fe3731b4?w=784&h=122&f=png&s=24544)

其实 Xcode 已经有快捷方式可以让你快速定位到控件在导航栏中的位置，首先点击选中你需要查看的控件，然后再导航栏中的 navigate 选项，展开后选择 Reveal in Debug Navigator ，如下图：

![](https://user-gold-cdn.xitu.io/2018/6/12/163f3216c6b8b33b?w=850&h=840&f=png&s=204145)

### 3.2 显示被裁剪的视图内容（View clipped content）

![](https://user-gold-cdn.xitu.io/2018/6/12/163f335462f645a6?w=1008&h=503&f=png&s=57285)

当我们遇到这样一个显示不全的 bug 的时候，我们可以用到 Debug View Hierarchy 查看当前视图具体情况，进入调试页面你会看到下面这种情况：

![](https://user-gold-cdn.xitu.io/2018/6/12/163f35c33f771593?w=594&h=226&f=png&s=17383)

我想我的 label 应该是完整的，但是超出页面被裁剪掉了，这个时候我需要确认一下事实是不是和我想的一样。如下图，我们需要开启 Show Clipped Content 选项。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f361387b25659?w=534&h=116&f=png&s=21813)

最后我看到了真相和我猜测的是一致的，我可以根据真实情况准确制定出解决方案。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f3604d13e73fb?w=826&h=250&f=png&s=24502)

### 3.3 在调试中查看自动布局信息（Auto Layout debugging）

在调试 Debug View Hierarchy 中查看控件的约束只需要启动 Show Constraints 选项，选中任何一个控件都会显示出其拥有的约束。
![](https://user-gold-cdn.xitu.io/2018/6/12/163f458f116c11ab?w=578&h=122&f=png&s=22937)

选中约束后可以在右边栏对象检查器 Object Inspector 中查看约束的详细信息。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f4722a1f8963c?w=1256&h=788&f=png&s=127578)

### 3.4 在调试检查器中显示调用栈（Creation backtraces in the inspector）

在调试模式下，我们有办法看到每一个控件，每一个约束的创建调用栈，方便我们快速定位到问题的源头。举个例子，我手动为我的 label 对顶部距离 100 的约束。

```
let myLabelTopConstraint =  myLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
NSLayoutConstraint.activate([myLabelTopConstraint])
```

运行 Demo 后开启 Debug View Hierarchy ，开启显示约束选项后，你可以找到这个约束并选中，在右边栏的对象检查器的 Backtrace 一栏你可以看到一个调用栈的列表。如下图，点击右边小箭头可以跳转到创建该对象的代码处。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f496d9b8c92c7?w=934&h=676&f=png&s=135279)

这项功能是需要手动开启的，你可以通过点击项目 Target -> Edit Scheme... -> Run -> Diagnostics -> Logging -> 勾选 Malloc Stack 并且切换至 All Allocation and Free History 模式开启此功能。

![](https://user-gold-cdn.xitu.io/2018/6/12/163f49e36ca19eb8?w=1766&h=984&f=png&s=206276)

### 3.5 获取对象指针及其拓展（Access object pointers (copy casted expressions) ）

在视图调试模式中，我们有时候也会需要在 LLDB 调试器中输入表达式来达到修改控件位置的的效果。

举例我们要修改一个约束的值，我们首先要拿到这个约束对象的指针，好消息是 Xcode 可以非常方便让我们拿到，选中该约束，直接快捷键 ⌘ + c 就复制好了，可以直接复制到控制台中使用。

你可以输出该约束的描述信息，和右边栏检查器中的 Description 是一样的效果。

```
// po + 复制好的指针
po ((NSLayoutConstraint *)0x600000dd4460)

// 输出结果
<NSLayoutConstraint:0x600000dd4460 UILabel:0x7fdb1c70a710'WWDC 2018：效率提升爆表的 Xcode 和...'.top == UIView:0x7fdb1c70b950.top + 100   (active)>
```

也许你还需要复习一下之前的内容，来修改一下约束的值，并且刷新页面，完成这些后赶紧看看模拟器的效果。

```
// 设置约束的值为 200
(lldb) e [((NSLayoutConstraint *)0x600000dd4460) setConstant:200]

// 刷新 UI
// 🚽 是 expression -l objc -- (void)[CATransaction flush] 命令的别名
(lldb) 🚽 
```

### 3.6 利用快捷键 ⌘-click 选中被遮挡的视图 （⌘-click-through for selection）

在调试中，你要选择的视图被另一个视图遮挡住的情况下，你可以通过 3D 的查看模式，选中后背的视图，如下图。

![](https://user-gold-cdn.xitu.io/2018/6/13/163f4d575965b2bc?w=964&h=732&f=png&s=59820)

但是这种方式实在难称优雅，况且还有一些刁钻的角度会让你非常头疼。在 2D 的情况下，正确的选中方式应该是 ⌘-click 直接选中背后被遮挡的视图，快去试试看吧。

## 四、调试深色模式（Debugging Dark Mode）

### 4.1 切换深色模式（Appearance overrides）

在 macOS 10.14 版本下并且安装了 Xcode 10 ，你就可以在开发中使用 Dark Mode 了，你可以在 Xcode 底部的找到一个黑白两色小方块按钮，通过选中这个按钮，你可以切换模拟器 Dark 和 Light 两种外观。如果你的 Macbook 有 Touch Bar 的话，你也可以通过 Touch Bar 上的按钮来切换。

![](https://user-gold-cdn.xitu.io/2018/6/13/163f83586e06d7b7?w=3042&h=1934&f=png&s=438896)

在 StoryBoard 中你可以在底部找到 View as : Light/Dark Appearance 来预览 Dark 和 Light 外观。

macOS 开发中选中任意一个 View ，你都可以在右边栏的检查器中找到 Appearance 属性，通过这个属性你可以为这个 View 及其子视图设置固定的外观颜色，且不会随着用户切换 Dark 和 Light 外观而改变颜色。


### 4.2 捕获活动的 Mac app（Capturing active Mac apps）

我们的 UI Hirerachey 同时只能显示一个 UIWindow 的内容，所有在调试的时候，弹出的 UIWindow 并不会和页面内的 UI 结构一起展示给我们，像 UIAlertView 这种弹出 UIWindow 就无法一起显示。

如果我们需要查看弹出 UIWindow ， 我们需要把左边栏当前的文件结构全部关闭收起，这个时候你会看到 ViewController 所在的 UIWindow 下面还有另外一个 UIWindow ，选中之后就可以查看弹出的 UIWindow 的 UI 层级结构了。

![](https://user-gold-cdn.xitu.io/2018/6/13/163f915e8ce2552a?w=534&h=560&f=png&s=78538)

### 4.3 在检查器中查看深色模式信息（Named colors and NSAppearance details in inspector）

在 UI Hierarchy 调试中我们可以在右边栏的检查器中查看 Dark Mode 相关信息，选中一个 UILabel 可以查看该 label 的 Text Color 属性。在 Dark Mode 下一共有 3 中类型颜色：

* **System Color**：
系统推荐颜色 System Color ，可以根据当前外观颜色自适应文字颜色。
* **Named Color**：Named Color 需要开发者在 assets catalog 中设置，可以针对 Dark Light 设置不同色值。
* **自定义 RGB 颜色**：纯手动设置的自定义 RGB 固定色值。

下图中的 Text Color 就是在 assets catalog 中设置的 Named Color ，设置的名字为 titleColor，你可以根据场景为该设置设置合适的名字。

![](https://user-gold-cdn.xitu.io/2018/6/13/163f917da2497371?w=1452&h=808&f=png&s=96770)

如下图，检查器偏下的位置 View 一栏中，我们可以找到 Appearance 和 Effective 属性，Appearance 是表示该视图下子视图无法切换的固定的外观颜色选择，Effective 是当前生效的外观颜色。

![](https://user-gold-cdn.xitu.io/2018/6/13/163f917fb6dcbd69?w=506&h=580&f=png&s=48918)

在  assets catalog 中设置 Named Color：

![](https://user-gold-cdn.xitu.io/2018/6/13/163f9bdd09e5707c?w=1360&h=782&f=png&s=197698)

## 总结

功能强大的 LLDB ，特别是配合 BreakPoint 一起使用，让我们有了更多的想象空间，加上越来越好用的 UI Hirerachey ，让我们的调试手段更加灵活。 这些内容虽然需要花一些时间去了解，但我相信掌握这些技巧将会为你节省下更多的时间。

从此你再也不用为下班前测出 bug 而焦虑了，早用上，早收工，最多干到下午 3 点钟。希望本文内容对每一位读者有所帮助。

## 参考链接

* 视频地址：[WWDC 2018 Session 412 - Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412)
* PDF地址：[WWDC 2018 Session 412 - Advanced Debugging with Xcode and LLDB](https://devstreaming-cdn.apple.com/videos/wwdc/2018/412zw88j5aa4mr9/412/412_advanced_debugging_with_xcode_and_lldb.pdf?dl=1)


>查看更多 WWDC 18 相关文章请前往 [老司机x知识小集xSwiftGG WWDC 18 专题目录](https://juejin.im/post/5b1d284df265da6e572b3d87)





