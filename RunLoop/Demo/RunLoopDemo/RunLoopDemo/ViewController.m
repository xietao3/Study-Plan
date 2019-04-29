//
//  ViewController.m
//  RunLoopDemo
//
//  Created by xietao on 2019/4/27.
//  Copyright © 2019 com.fruitday. All rights reserved.
//

#import "ViewController.h"
#import "BackgroundThread.h"
#import "RunLoopItem/RunLoopSource.h"
#import "RunLoopItem/RunLoopPort.h"

#import <mach/mach.h>

@interface ViewController ()

@property (nonatomic, strong) BackgroundThread *backgroundThread;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)initial {
    self.titleArray = @[@"起后台线程",@"调用 Source",@"调用 Source1" ,@"start Timer",@"stop Timer",@"send Port Message", @"Perform Selector",@"Stop RunLoop"];
}

#pragma mark - BackgroundThread
- (void)startBackgroundThread {
    self.backgroundThread = [BackgroundThread shareInstance];
    [BackgroundThread start];
}

- (BOOL)backgroundThreadValid {
    if (self.backgroundThread.backgroundThread && self.backgroundThread.backgroundThread.isExecuting) {
        return YES;
    }else{
        NSLog(@"BackgroundThread 未启动");
        return NO;
    }
}

#pragma mark - Timer
- (void)addTimer {
    if (![self backgroundThreadValid]) return;
    
//    [self performSelector:@selector(performTimer) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];

    [self performSelector:@selector(performTimer) onThread:[BackgroundThread shareInstance].backgroundThread withObject:nil waitUntilDone:YES];
}

- (void)performTimer {
    if (_timer) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"Timer Callback, thread：%@",[NSThread currentThread].name);
    }];
    
    [_timer fire];
}

- (void)stopTimer {
    if (![self backgroundThreadValid]) return;
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Source
- (void)fireSource {
    if (![self backgroundThreadValid]) return;
    
    [RunLoopSource fireSourceWithKey:kBackgroundThreadSourceKey];
}

- (void)fireSource1 {
    if (![self backgroundThreadValid]) return;
    
    [RunLoopSource fireSourceWithKey:kBackgroundThreadSourceKey1];
}

#pragma mark - Port
- (void)sendPortMsg {
    if (![self backgroundThreadValid]) return;
    
    [RunLoopPort sendPortWithMessage:@"xietao3" key:kBackgroundThreadPortKey];
}

#pragma mark - PerformSelector
- (void)performAction {
    if (![self backgroundThreadValid]) return;
    
    [self performSelector:@selector(performResponder) onThread:[BackgroundThread shareInstance].backgroundThread withObject:nil waitUntilDone:YES];
}

- (void)performResponder {
    if (![self backgroundThreadValid]) return;
    
    NSLog(@"Perform Action, thread：%@",[NSThread currentThread].name);
}

#pragma mark - RunLoopStop
- (void)stopRunLoop {
    if (![self backgroundThreadValid]) return;
    [self performSelector:@selector(performStopRunLoop) onThread:[BackgroundThread shareInstance].backgroundThread withObject:nil waitUntilDone:YES];
}

- (void)performStopRunLoop {
    NSLog(@"Perform Stop RunLoop, thread：%@",[NSThread currentThread].name);
    CFRunLoopStop(CFRunLoopGetCurrent());
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count>0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self startBackgroundThread];
            break;
        case 1:
            [self fireSource];
            break;
        case 2:
            [self fireSource1];
            break;
        case 3:
            [self addTimer];
            break;
        case 4:
            [self stopTimer];
            break;
        case 5:
            [self sendPortMsg];
            break;
        case 6:
            [self performAction];
            break;
        case 7:
            [self stopRunLoop];
            break;

        default:
            break;
    }

}


@end
