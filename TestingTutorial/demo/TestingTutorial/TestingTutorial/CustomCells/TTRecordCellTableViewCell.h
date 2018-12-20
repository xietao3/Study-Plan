//
//  TTRecordCellTableViewCell.h
//  TestingTutorial
//
//  Created by xietao on 2018/12/11.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTRecordCellTableViewCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;

+ (CGFloat)heightForCellInTableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath dataSource:(id)dataSource;

- (void)displayCellByDataSources:(id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath;

@end
