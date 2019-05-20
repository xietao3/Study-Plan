# RunLoop 学习笔记

> 对本文感兴趣的同学可以查看本文 [Demo](./Demo) ，其中实现了本文大部分相关内容。本文在部分基础概念知识点借鉴(copy)了参考文章内容，望包涵。

## 一、RunLoop

### 1.1 RunLoop 的概念

``RunLoop``和线程是一对一的关系，通常来讲线程执行完任务之后就会退出，有时候我们需要一个常驻线程帮我们处理事件，处理完成也不会退出，等待下一次处理事件。

这种机制一般称作为 **事件循环机制(EventLoop)** ，RunLoop 管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面``EventLoop``的逻辑。线程执行了这个函数后，就会一直处于这个函数内部 ``接受消息->等待->处理`` 的循环中。当没有事件的时候进入休眠状态，避免占用资源，一旦受到事件就将被唤醒来处理事件，直到这个循环结束，函数返回。


### 1.2 获得 RunLoop

苹果不允许直接创建``RunLoop``，它只提供了两个自动获取的函数：``CFRunLoopGetMain()``和 ``CFRunLoopGetCurrent()``。你可以在任意线程获得主线程的``RunLoop``，除此之外只能获得本线程的``RunLoop``。

除了主线程之外，其他线程的``RunLoop``都需要手动运行。API 提供了 3 种运行方式：

```
- (void)run; 
- (void)runUntilDate:(NSDate *)limitDate;
- (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;
```

* ``run`` 即使调用``CFRunLoopStop()``也无法退出，通常如果想要永远不会退出``RunLoop``才会使用此方法，否则可以使用另外 2 种方式 。

* ``runUntilDate:``执行完并不会退出，继续执行下去直到你设置的结束时间，``CFRunLoopStop()``同样无效。

* ``runMode:beforeDate:``通过该方法启动时，只能执行一次，执行完就退出，此方法可以使用``CFRunLoopStop()``提前退出。

### 1.3 CFRunLoop

NSRunLoop 是在 CFRunLoop 的基础上进行封装，有希望了解实现原理的可以查看 [RunLoop 源码](https://opensource.apple.com/source/CF/CF-855.17/) 。

CFRunLoop 相关的函数基本和 NSRunLoop 一致。

```
CF_EXPORT CFRunLoopRef CFRunLoopGetCurrent(void);
CF_EXPORT CFRunLoopRef CFRunLoopGetMain(void);

CF_EXPORT void CFRunLoopRun(void);
CF_EXPORT SInt32 CFRunLoopRunInMode(CFStringRef mode, CFTimeInterval seconds, Boolean returnAfterSourceHandled);
CF_EXPORT Boolean CFRunLoopIsWaiting(CFRunLoopRef rl);
CF_EXPORT void CFRunLoopWakeUp(CFRunLoopRef rl);
CF_EXPORT void CFRunLoopStop(CFRunLoopRef rl);
```

下面是 CFRunLoop 的基本结构：

```
struct __CFRunLoop {
    CFRuntimeBase _base;			
    pthread_mutex_t _lock;			/* locked for accessing mode list */
    __CFPort _wakeUpPort;			// used for CFRunLoopWakeUp 
    Boolean _unused;
    volatile _per_run_data *_perRunData;    // reset for runs of the run loop
    pthread_t _pthread;
    uint32_t _winthread;
    CFMutableSetRef _commonModes;    
    CFMutableSetRef _commonModeItems;
    CFRunLoopModeRef _currentMode;
    CFMutableSetRef _modes;
    struct _block_item *_blocks_head;
    struct _block_item *_blocks_tail;
    CFTypeRef _counterpart;
};
```

在 CFRunLoop 的结构当中，有很多与 Mode 相关的属性，比如说``_commonModes``、``_commonModeItems``、``_currentMode``和``_modes``等等，继续往下看了解他们的关系。



## 二、Mode

### 2.1 Mode 的概念

一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Mode Item ，如 Source、Timer、Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source、Timer、Observer，让其互不影响。

主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode。这两个 Mode 都已经被标记为``Common``属性。

* DefaultMode 是 App 平时所处的状态

* TrackingRunLoopMode 是追踪 ScrollView 滑动时的状态。

* CommonModes 并不是一个真的 Mode ，它是一个 Mode 的集合，可以将其他 Mode 加入其中。

除此之外还有一些开发者不常用的 Mode 可以在 [http://iphonedevwiki.net/index.php/CFRunLoop](http://iphonedevwiki.net/index.php/CFRunLoop) 查看。

CF 中获得 Mode 的方式： 

```
CF_EXPORT CFStringRef CFRunLoopCopyCurrentMode(CFRunLoopRef rl);
CF_EXPORT CFArrayRef CFRunLoopCopyAllModes(CFRunLoopRef rl);
```


### 2.2 CommonModes

Mode 有个概念叫 **CommonModes** ：一个 Mode 可以将自己标记为``Common``属性，通过将其 ModeName 添加到 RunLoop 的``commonModes``中。每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 _commonModeItems 里的 Source、Observer、Timer 同步到具有``Common``标记的所有 Mode 里。

当你创建一个 Timer 并加到 DefaultMode 时，Timer 会得到重复回调，但此时滑动一个 ScrollView 时，RunLoop 会将 mode 切换为 TrackingRunLoopMode，这时 Timer 就不会被回调，并且也不会影响到滑动操作。如果你将以上两种 Mode 都标记成 CommonModes ，并且将 Timer 将入 CommonModes 中，那不管 ScrollView 是否滑动， Timer 都会执行回调。


将一个 Mode 加入 CommonMode 源代码：

```
void CFRunLoopAddCommonMode(CFRunLoopRef rl, CFStringRef modeName) {
	...
	// 不包含在 _commonModes 当中
    if (!CFSetContainsValue(rl->_commonModes, modeName)) {
    // 获得 RunLoop 的 _commonModeItems
	CFSetRef set = rl->_commonModeItems ? CFSetCreateCopy(kCFAllocatorSystemDefault, rl->_commonModeItems) : NULL;
	// 将 Mode 加入 _commonModes 中
	CFSetAddValue(rl->_commonModes, modeName);
	// 如果 _commonModeItems 有值则加入当前 Mode 中
	if (NULL != set) {
	    CFTypeRef context[2] = {rl, modeName};
	    /* add all common-modes items to new mode */
	    CFSetApplyFunction(set, (__CFRunLoopAddItemsToCommonMode), (void *)context);
	    CFRelease(set);
	}
    } else {
    }
    __CFRunLoopUnlock(rl);
}

```

### 2.3 Mode Items

Source、Timer、Observer 对应 CFRunLoop 源代码结构中 Source0、Source1、Timer 和待执行的 block 被统称为 Mode Item ，一个 item 可以被同时加入多个 mode。但一个 item 被重复加入同一个 mode 时是不会有效果的。如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环，所有大家需要建立一个常驻线程的话，至少要在该线程 RunLoop 中加入一个 Mode Item。

CFRunLoop 管理 Mode Items 相关接口：

```
CF_EXPORT Boolean CFRunLoopContainsSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode);
CF_EXPORT void CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode);
CF_EXPORT void CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef mode);

CF_EXPORT Boolean CFRunLoopContainsObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef mode);
CF_EXPORT void CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef mode);
CF_EXPORT void CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef mode);

CF_EXPORT Boolean CFRunLoopContainsTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
CF_EXPORT void CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
CF_EXPORT void CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
```

下面是 CFRunLoopMode 检查 Mode Items 是否为空的源代码：

```
static Boolean __CFRunLoopModeIsEmpty(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFRunLoopModeRef previousMode) {
	...
    // 主线程 GCD 也和后面一些内容有关
    if (libdispatchQSafe && (CFRunLoopGetMain() == rl) && CFSetContainsValue(rl->_commonModes, rlm->_name)) return false; // represents the libdispatch main queue
    // 检查 Source0
    if (NULL != rlm->_sources0 && 0 < CFSetGetCount(rlm->_sources0)) return false;
    // 检查 source1
    if (NULL != rlm->_sources1 && 0 < CFSetGetCount(rlm->_sources1)) return false;
    // 检查 Timer
    if (NULL != rlm->_timers && 0 < CFArrayGetCount(rlm->_timers)) return false;
    // 检查 Block
    struct _block_item *item = rl->_blocks_head;
    while (item) {
        struct _block_item *curr = item;
        item = item->_next;
        Boolean doit = false;
        if (CFStringGetTypeID() == CFGetTypeID(curr->_mode)) {
            doit = CFEqual(curr->_mode, rlm->_name) || (CFEqual(curr->_mode, kCFRunLoopCommonModes) && CFSetContainsValue(rl->_commonModes, rlm->_name));
        } else {
            doit = CFSetContainsValue((CFSetRef)curr->_mode, rlm->_name) || (CFSetContainsValue((CFSetRef)curr->_mode, kCFRunLoopCommonModes) && CFSetContainsValue(rl->_commonModes, rlm->_name));
        }
        if (doit) return false;
    }
    return true;
}
```

### 2.4 CFRunLoopMode

```
struct __CFRunLoopMode {
    CFRuntimeBase _base;
    pthread_mutex_t _lock;	/* must have the run loop locked before locking this */
    CFStringRef _name;
    Boolean _stopped;
    char _padding[3];
    CFMutableSetRef _sources0;
    CFMutableSetRef _sources1;
    CFMutableArrayRef _observers;
    CFMutableArrayRef _timers;
    CFMutableDictionaryRef _portToV1SourceMap;
    __CFPortSet _portSet;
    CFIndex _observerMask;
#if USE_DISPATCH_SOURCE_FOR_TIMERS
    dispatch_source_t _timerSource;
    dispatch_queue_t _queue;
    Boolean _timerFired; // set to true by the source when a timer has fired
    Boolean _dispatchTimerArmed;
#endif
#if USE_MK_TIMER_TOO
    mach_port_t _timerPort;
    Boolean _mkTimerArmed;
#endif
#if DEPLOYMENT_TARGET_WINDOWS
    DWORD _msgQMask;
    void (*_msgPump)(void);
#endif
    uint64_t _timerSoftDeadline; /* TSR */
    uint64_t _timerHardDeadline; /* TSR */
};
```

在 CFRunLoopMode 的结构中，最重要的 _sources0 、 _sources1 、 _observers 和 timers 后面会一一介绍。

## 三、Source

CFRunLoopSourceRef 是事件产生的来源。从 CFRunLoopMode 的结构中可以发现 Source 有两个种：Source0 和 Source1。

* **Source0**：只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。

* **Source1**：包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，其原理在下面会讲到。

### 3.1 利用 Source(Source0) 跨线程通信

利用 Source(Source0) 跨线程通信整个流程大致分为:
	
* 创建 ``CFRunLoopSourceContext``
* 创建 ``CFRunLoopSourceRef``
* 将``CFRunLoopSourceRef``加入当前线程 RunLoop
* 通过 ``CFRunLoopSourceRef`` 发送信号并唤醒 RunLoop 处理

文章中的全部 OC 代码可以在本文 [Demo](./Demo) 中找到。

下面的代码展示了如何创建``CFRunLoopSourceContext ``，并借此创建``CFRunLoopSourceRef ``，最后将``CFRunLoopSourceRef ``加入到 RunLoop 中。

```
- (void)setup {
	// 初始化 CFRunLoopSourceContext
    CFRunLoopSourceContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleCallBack,
        RunLoopSourceCancelCallBack,
        RunLoopSourcePerformCallBack};
        
    // 创建 CFRunLoopSourceRef
    self.runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    // 保存当前线程 runloop
    self.runLoop = CFRunLoopGetCurrent();
}

// 将 CFRunLoopSourceRef 加入当前线程 RunLoop
- (void)addToCurrentRunLoopWithKey:(NSString *)key {
    self.name = key;
    // 将 Source 加入 RunLoop
    CFRunLoopAddSource(CFRunLoopGetCurrent(), _runLoopSource, kCFRunLoopDefaultMode);
    // 将自定义 Source 对象存储起来，方便外部通过 Key 获取
    [RunLoopItemCenter addSource:self withKey:key];
}

```

查看``CFRunLoopSourceContext``结构可以得到一些关键信息，比如说如何传递信息，如何获得各种回调。

```
typedef struct {
    CFIndex	version;
    void *	info;		// 传递信息
    const void *(*retain)(const void *info);
    void	(*release)(const void *info);
    CFStringRef	(*copyDescription)(const void *info);
    Boolean	(*equal)(const void *info1, const void *info2);
    CFHashCode	(*hash)(const void *info);
    void	(*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode); // 加载回调
    void	(*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode); // 卸载回调
    void	(*perform)(void *info);	// 执行回调
} CFRunLoopSourceContext;

```

加入``CFRunLoopSourceContext``的各种回调处理事件。

```
// 装载回调
void RunLoopSourceScheduleCallBack (void *info, CFRunLoopRef rl, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"加入 Source：%@", source.name);
}

// 处理回调 info 在 CFRunLoopSourceContext 中传入
void RunLoopSourcePerformCallBack (void *info) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"通知处理 Source：%@", source.name);
}

// 卸载回调
void RunLoopSourceCancelCallBack (void *info, CFRunLoopRef rl, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)(info);
    NSLog(@"移除 Source：%@", source.name);
    [RunLoopItemCenter removeSourceWithKey:source.name];
}
```

接下来就可以利用下面的方法发送信号，通知 RunLoop 处理事件。

```
[RunLoopSource fireSourceWithKey:kBackgroundThreadSourceKey1];

+ (void)fireSourceWithKey:(NSString *)key {
	// 通过 key 取出对应的 RunLoopSource
    RunLoopSource *source = [RunLoopItemCenter getSourceWithKey:key];
    if (source) {
    	// 需要先发信号 然后再唤醒 RunLoop
        CFRunLoopSourceSignal(source.runLoopSource);
        CFRunLoopWakeUp(source.runLoop);
    }
}
```


### 3.2 NSPort

利用 NSPort(Source1) 跨线程通信整个流程大致分为:

* 设置线程 1 端口及事件代理
* 设置线程 2 端口及事件代理
* 从线程 1 发送消息至线程 2
* 线程 2 回复消息至 线程 1

```
- (void)setup {
    // 创建主线程 RunLoop 端口 _mainPort
    _mainPort = [[NSMachPort alloc]init];
    // 设置 主线程端口处理事件代理
    _mainPortDelegate = [[RunLoopMainPortDelegate alloc] init];
    _mainPort.delegate = (id)_mainPortDelegate;
    // 将端口加入主线程 RunLoop
    [[NSRunLoop mainRunLoop] addPort:_mainPort forMode:NSDefaultRunLoopMode];
    
    // 创建子线程端口 _threadPort
    _threadPort = [NSMachPort port];
    // 设置处理事件代理
    _threadPort.delegate = self;
    
}

// 将子线程端口加入子线程 RunLoop 并且保存，方便后面获取调用
- (void)addPortToCurrentRunLoopWithKey:(NSString *)key {
    [[NSRunLoop currentRunLoop]addPort:_threadPort forMode:NSDefaultRunLoopMode];
    [RunLoopItemCenter addPort:self withKey:key];
}
```

处理主线程端口代理事件：

```
@implementation RunLoopMainPortDelegate

- (void)handlePortMessage:(id)message {
    NSArray *components = [message valueForKeyPath:@"components"];
    NSData *data =  components[0];
    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"收到消息:%@",s1);
}

@end
```

处理子线程端口事件：

```
- (void)handlePortMessage:(id)message {
    NSArray *components = [message valueForKeyPath:@"components"];
    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];

    NSData *data =  components[0];
    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"收到消息:%@",s1);
    
    // 收到消息后回复对方端口
    [self replyWithLocalPort:remotePort remotePort:localPort];
}

- (void)replyWithLocalPort:(NSPort *)localPort remotePort:(NSPort *)remotePort {
    NSMutableArray *components = [NSMutableArray arrayWithArray:@[[@"这是回复" dataUsingEncoding:NSUTF8StringEncoding]]];
    [localPort sendBeforeDate:[NSDate date] msgid:200 components:components from:remotePort reserved:0];
}
```

一切就绪可以进行通信了：

```
[RunLoopPort sendPortWithMessage:@"xietao3" key:kBackgroundThreadPortKey];

+ (void)sendPortWithMessage:(NSString *)message key:(NSString *)key {
	// 获取保存端口对象
    RunLoopPort *runLoopPort = [RunLoopItemCenter getPortWithKey:key];
    if (runLoopPort) {
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *components = [NSMutableArray arrayWithArray:@[data]];
        // 通过子线程端口发送消息
        [runLoopPort.threadPort sendBeforeDate:[NSDate date] msgid:100 components:components from:runLoopPort.mainPort reserved:0];
    }
}
```

子线程在收到信息后，对主线程进行了回复：

```
当前线程：<NSThread: 0x6000035b25c0>{number = 3, name = BackgroundThread}
收到消息:xietao3
当前线程：<NSThread: 0x6000035c2900>{number = 1, name = main}
收到消息:这是回复
```


## 四、Timer

CFRunLoopTimerRef 是基于时间的触发器，它和 NSTimer 是 toll-free bridged （免费桥，可以互相转换）的。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调。

Timer 在开发中比较常用，有部分初级的开发者在不了解 Timer 与 Mode 之间关系，会发现 Timer 在滑动时无法调用。这是因为滑动 ScrollView 时主线程 RunLoop 切换成 UITrackingRunLoopMode 模式，这是为了提升滑动时的用户体验。解决问题的办法有 2 种：

* 将 Timer 加入 CommomModes ，2 种 Mode 都被包含在其中，所以 Timer 在加入时会分别加入 CommonMode 中的每一个 Mode 。
* 将 Timer 加入子线程，子线程没有 UITrackingRunLoopMode ，在滑动时不会受影响。


```
<CFRunLoop 0x600000f64600 [0x10712bb68]>{wakeup port = 0x1e07, stopped = false, ignoreWakeUps = true, 
current mode = kCFRunLoopDefaultMode,
common modes = <CFBasicHash 0x600003d68810 [0x10712bb68]>{type = mutable set, count = 2,
entries =>
	0 : <CFString 0x10a653be0 [0x10712bb68]>{contents = "UITrackingRunLoopMode"}
	2 : <CFString 0x107141168 [0x10712bb68]>{contents = "kCFRunLoopDefaultMode"}
}
...

```

在调试模式中通过 LLBD 指令``po CFRunLoopGetCurrent()``可以查看当前 RunLoop 具体信息。

下面是子线程的 RunLoop 结构：

```
<CFRunLoop 0x600003798000 [0x105559b68]>{wakeup port = 0x9f07, stopped = false, ignoreWakeUps = false, 

// 当前 Mode
current mode = kCFRunLoopDefaultMode,

// RunLoop 的 Common Modes
common modes = <CFBasicHash 0x600000596520 [0x105559b68]>{type = mutable set, count = 1,
entries =>
	2 : <CFString 0x10556f168 [0x105559b68]>{contents = "kCFRunLoopDefaultMode"}
}
,

// Common Mode Items
common mode items = <CFBasicHash 0x6000005c92f0 [0x105559b68]>{type = mutable set, count = 1,
entries =>
	2 : <CFRunLoopSource 0x600003e94e40 [0x105559b68]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x60000098c7e0, callout = __NSThreadPerformPerform (0x10431eb31)}}
}
,

// RunLoop 拥有的 Mode
modes = <CFBasicHash 0x600000595110 [0x105559b68]>{type = mutable set, count = 1,
entries =>
	2 : <CFRunLoopMode 0x600003094750 [0x105559b68]>{name = kCFRunLoopDefaultMode, port set = 0x6007, queue = 0x600002595c00, source = 0x600002595980 (not fired), timer port = 0x5e0b, 
	
	// 该 Mode 里的 Source 0 有 3 个
	sources0 = <CFBasicHash 0x600000596ac0 [0x105559b68]>{type = mutable set, count = 3,
entries =>
	0 : <CFRunLoopSource 0x600003e94e40 [0x105559b68]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x60000098c7e0, callout = __NSThreadPerformPerform (0x10431eb31)}}
	1 : <CFRunLoopSource 0x600003e989c0 [0x105559b68]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x600000b94940, callout = RunLoopSourcePerformCallBack (0x103f5e0c0)}}
	2 : <CFRunLoopSource 0x600003e91740 [0x105559b68]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x600000bc8720, callout = RunLoopSourcePerformCallBack (0x103f5e0c0)}}
}
,
	
	// 该 Mode 里的 Source1 有 2 个
	sources1 = <CFBasicHash 0x6000005968e0 [0x105559b68]>{type = mutable set, count = 2,
entries =>
	0 : <CFRunLoopSource 0x600003e9fcc0 [0x105559b68]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0x600003c9c840 [0x105559b68]>{valid = Yes, port = 6b03, source = 0x600003e9fcc0, callout = __NSFireMachPort (0x10430337f), context = <CFMachPort context 0x60000059bde0>}}
	2 : <CFRunLoopSource 0x600003e99140 [0x105559b68]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0x600003c980b0 [0x105559b68]>{valid = Yes, port = a307, source = 0x600003e99140, callout = __NSFireMachPort (0x10430337f), context = <CFMachPort context 0x600000596d30>}}
}
,
	
	// Mode 里的 Observer
	observers = (null),
	
	// Mode 里的 Timer
	timers = <CFArray 0x600002f8f8a0 [0x105559b68]>{type = mutable-small, count = 2, values = (
	0 : <CFRunLoopTimer 0x600003e90fc0 [0x105559b68]>{valid = Yes, firing = No, interval = 2, tolerance = 0, next fire date = 578243733 (-14.179448 @ 95022246756349), callout = (NSTimer) [_NSTimerBlockTarget fire:] (0x10432882e / 0x104327e94) (/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation), context = <CFRunLoopTimer context 0x600000bc86a0>}
	1 : <CFRunLoopTimer 0x600003e95980 [0x105559b68]>{valid = Yes, firing = No, interval = 3.061152e+09, tolerance = 0, next fire date = 1.08315496e+09 (504911215 @ 505006251110144887), callout = __28+[BackgroundThread addTimer]_block_invoke (0x10524aa80 / 0x103f5dbe0) (/Users/xietao/Library/Developer/CoreSimulator/Devices/A7E23433-02D3-4BEE-A48D-E5633884E274/data/Containers/Bundle/Application/F6A347C6-7AD1-4C3B-81CE-A33C41D192D7/RunLoopDemo.app/RunLoopDemo), context = <CFRunLoopTimer context 0x103f62198>}
)},
	currently 578243747 (95036425793208) / soft deadline in: 1.84467441e+10 sec (@ 95022246756349) / hard deadline in: 1.84467441e+10 sec (@ 95022246756349)
},

}
}
```



## 五、Observer


CFRunLoopObserverRef 是观察者，每个 Observer 都包含了一个回调（函数指针），当 RunLoop 的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个：

```
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
```

目前已经很多小伙伴利用 Observer 进入休眠的时长来实现卡顿检测的功能，除了上述的 Observer 之外主线程会额外注册一些 Observer ：

```
observers = (
    "<CFRunLoopObserver 0x6000011443c0 [0x10aa86b68]>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, 
    callout = _wrapRunLoopWithAutoreleasePoolHandler (0x10d7591b1), context = <CFArray 0x600002e54ed0 [0x10aa86b68]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7fbbc4002058>\n)}}",
    
    "<CFRunLoopObserver 0x60000114c320 [0x10aa86b68]>{valid = Yes, activities = 0x20, repeats = Yes, order = 0, 
    callout = _UIGestureRecognizerUpdateObserver (0x10d32b473), context = <CFRunLoopObserver context 0x600000b4c070>}",
    
    "<CFRunLoopObserver 0x600001144500 [0x10aa86b68]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 1999000, 
    callout = _beforeCACommitHandler (0x10d788dfc), context = <CFRunLoopObserver context 0x7fbbc5001b30>}",
    
    "<CFRunLoopObserver 0x600001145400 [0x10aa86b68]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2000000, 
    callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv (0x10f1876ae), context = <CFRunLoopObserver context 0x0>}",
    
    "<CFRunLoopObserver 0x6000011445a0 [0x10aa86b68]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2001000, 
    callout = _afterCACommitHandler (0x10d788e75), context = <CFRunLoopObserver context 0x7fbbc5001b30>}",
    
    "<CFRunLoopObserver 0x6000011441e0 [0x10aa86b68]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, 
    callout = _wrapRunLoopWithAutoreleasePoolHandler (0x10d7591b1), context = <CFArray 0x600002e54ed0 [0x10aa86b68]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7fbbc4002058>\n)}}"
)

```

其中 _UIGestureRecognizerUpdateObserver 为监听手势更新事件，另外 CoreAnimation 相关的有 3 个：

* _beforeCACommitHandler
* _ZN2CA11Transaction17observer
* _afterCACommitHandler


还有 2 个和 AutoReleasePool 相关：

* _wrapRunLoopWithAutoreleasePoolHandler order = -2147483647, 
* _wrapRunLoopWithAutoreleasePoolHandler order = 2147483647, 


第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用``_objc_autoreleasePoolPush()``创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。

第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用``_objc_autoreleasePoolPop()``和``_objc_autoreleasePoolPush()``释放旧的池并创建新池； Exit (即将退出 Loop ) 时调用``_objc_autoreleasePoolPop()``来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。

在创建子线程时，在线程的入口函数中，我们就需要自己加上自动释放池代码：

```
- (void)threadEntryPoint {
	@autoreleasepool {
	    // Do thread work here.
    }
}
```

## 六、RunLoop 的内部逻辑

如果对上面的内容有了初步了解，那应该掌握了 RunLoop 内部大概的组成结构，这个时候可以来看看 RunLoop 其内部运行的逻辑。

这里羞耻的直接贴上 YY 大神简化后的逻辑，相信很多人已经看过，不过还是贴出来让更多人知道（文末有参考链接），对更多细节感兴趣的同学可以在[源码](https://opensource.apple.com/source/CF/CF-855.17/)中查看。

```
/// 用DefaultMode启动
void CFRunLoopRun(void) {
    CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
}
 
/// 用指定的Mode启动，允许设置RunLoop超时时间
int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
    return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
}
 
/// RunLoop的实现
int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
    
    /// 首先根据modeName找到对应mode
    CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
    /// 如果mode里没有source/timer/observer, 直接返回。
    if (__CFRunLoopModeIsEmpty(currentMode)) return;
    
    /// 1. 通知 Observers: RunLoop 即将进入 loop。
    __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
    
    /// 内部函数，进入loop
    __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
        
        Boolean sourceHandledThisLoop = NO;
        int retVal = 0;
        do {
 
            /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
            __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
            /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
            __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
            /// 执行被加入的block
            __CFRunLoopDoBlocks(runloop, currentMode);
            
            /// 4. RunLoop 触发 Source0 (非port) 回调。
            sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
            /// 执行被加入的block
            __CFRunLoopDoBlocks(runloop, currentMode);
 
            /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
            if (__Source0DidDispatchPortLastTime) {
                Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
                if (hasMsg) goto handle_msg;
            }
            
            /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
            if (!sourceHandledThisLoop) {
                __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
            }
            
            /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
            /// • 一个基于 port 的Source 的事件。
            /// • 一个 Timer 到时间了
            /// • RunLoop 自身的超时时间到了
            /// • 被其他什么调用者手动唤醒
            __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
                mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
            }
 
            /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
            __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
            
            /// 收到消息，处理消息。
            handle_msg:
 
            /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
            if (msg_is_timer) {
                __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
            } 
 
            /// 9.2 如果有dispatch到main_queue的block，执行block。
            else if (msg_is_dispatch) {
                __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
            } 
 
            /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
            else {
                CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
                sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
                if (sourceHandledThisLoop) {
                    mach_msg(reply, MACH_SEND_MSG, reply);
                }
            }
            
            /// 执行加入到Loop的block
            __CFRunLoopDoBlocks(runloop, currentMode);
            
 
            if (sourceHandledThisLoop && stopAfterHandle) {
                /// 进入loop时参数说处理完事件就返回。
                retVal = kCFRunLoopRunHandledSource;
            } else if (timeout) {
                /// 超出传入参数标记的超时时间了
                retVal = kCFRunLoopRunTimedOut;
            } else if (__CFRunLoopIsStopped(runloop)) {
                /// 被外部调用者强制停止了
                retVal = kCFRunLoopRunStopped;
            } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
                /// source/timer/observer一个都没有了
                retVal = kCFRunLoopRunFinished;
            }
            
            /// 如果没超时，mode里没空，loop也没被停止，那继续loop。
        } while (retVal == 0);
    }
    
    /// 10. 通知 Observers: RunLoop 即将退出。
    __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
```

## 总结

RunLoop 有一部分涉及到内核部分的知识，已经把这部分列入学习计划当中。如果还有一些 RunLoop 相关知识没有谈到的，可以查看文末参考文章，都是出自大神之手。

## 参考

* [深入理解RunLoop](https://blog.ibireme.com/2015/05/18/runloop/)
* [Threading Programming Guide(2)](http://yulingtianxia.com/blog/2017/09/17/Threading-Programming-Guide-2/#%E9%85%8D%E7%BD%AE-Run-Loop-Source)
