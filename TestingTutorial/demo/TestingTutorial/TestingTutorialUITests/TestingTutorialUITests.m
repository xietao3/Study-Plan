//
//  TestingTutorialUITests.m
//  TestingTutorialUITests
//
//  Created by xietao on 2018/12/6.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTTestCase.h"

@interface TestingTutorialUITests : TTTestCase

@end

@implementation TestingTutorialUITests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMainFlow {

    
    // 启动 app
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    // 添加笔记
    [self addRecordWithApp:app msg:@"今天天气真好！🌞"];
    [self addRecordWithApp:app msg:@"今天詹姆斯特别给力，带领球队走向胜利。✌️"];
    
//    [self addAttachmentWithScreenshot:[app screenshot] attachmentName:@"MyScreenshot"];

    while (app.cells.count > 0) {
        // 删除笔记
        [self deleteFirstRecordWithApp:app];
    }

    sleep(1.1);
}


/**
 添加笔记
 
 @param app app 实例
 @param msg 笔记内容
 */
- (void)addRecordWithApp:(XCUIApplication *)app msg:(NSString *)msg {
    // 暂存当前 cell 数量
    NSInteger cellsCount = app.cells.count;
    
    // 设置一个预期 判断 app.cells 的 count 属性会等于 cellsCount+1， 等待直至失败，如果符合则不再等待
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"count == %d",cellsCount+1];
    [self expectationForPredicate:predicate evaluatedWithObject:app.cells handler:nil];
    
    
    // 定位导航栏+号按钮，点击进入添加笔记页面
    XCUIElement *addButton = app.navigationBars[@"Record List"].buttons[@"Add"];
    [addButton tap];
    
    // 测试 未输入任何内容点击保存
    [app.navigationBars[@"Write Anything"].buttons[@"Save"] tap];
    
    // 定位文本输入框 输入内容
    XCUIElement *textView = app.textViews.firstMatch;
    [textView typeText:msg];
    
    // 保存
    [app.navigationBars[@"Write Anything"].buttons[@"Save"] tap];
    
    // 等待预期
    [self waitShortTimeForExpectations];
}

/**
 删除最近一个笔记
 
 @param app app 实例
 */
- (void)deleteFirstRecordWithApp:(XCUIApplication *)app {
    NSInteger cellsCount = app.cells.count;
    
    XCTNSPredicateExpectation
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"count == %d",cellsCount-1];
    // 设置一个预期 判断 app.cells 的 count 属性会等于 cellsCount-1， 等待直至失败，如果符合则不再等待
    [self expectationForPredicate:predicate evaluatedWithObject:app.cells handler:nil];
    
    // 定位到 cell 元素
    XCUIElement *firstCell = app.cells.firstMatch;
    
    // 左滑出现删除按钮
    [firstCell swipeLeft];
    
    // 定位删除按钮
    XCUIElement *deleteButton = [app.buttons matchingIdentifier:@"Delete"].firstMatch;
    
    // 点击删除按钮
    if (deleteButton.exists) {
        [deleteButton tap];
    }
    
    // 等待预期
    [self waitShortTimeForExpectations];
    
}



@end
