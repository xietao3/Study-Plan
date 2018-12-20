//
//  TTRecordCellTableViewCell.m
//  TestingTutorial
//
//  Created by xietao on 2018/12/11.
//  Copyright © 2018 com.fruitday. All rights reserved.
//

#import "TTRecordCellTableViewCell.h"
#import "TTDateFormatter.h"

@interface TTRecordCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TTRecordCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)initial {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)heightForCellInTableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath dataSource:(id)dataSource {
    return 88;
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"";
    cellIdentifier = [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
    
    NSString *filePath = [NSString stringWithFormat:@"%s",__FILE__];
    NSArray *fileArray = [(NSString *)[(NSArray *)[filePath componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."];
    NSString *fileName = [fileArray firstObject];
    
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:fileName owner:self options:nil];
        NSUInteger index = 0;
        for (id obj in xibs) {
            if ([NSStringFromClass([obj class]) isEqualToString:NSStringFromClass([self class])]) {
                index = [xibs indexOfObject:obj];
                break;
            }
        }
        cell = [xibs objectAtIndex:index];
        ((UITableViewCell *)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(initial)]) {
            [cell performSelector:@selector(initial)];
        }
    }
    return cell;
}

- (void)displayCellByDataSources:(id)dataSources rowAtIndexPath:(NSIndexPath *)indexPath {
    if (!dataSources) return;
    NSArray *recordList = dataSources;
    NSDictionary *record = recordList[indexPath.row];
    self.contentLabel.text = record[@"msg"];
    NSNumber *timeStamp = record[@"timeStamp"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = [TTDateFormatter getHowLongAgoWithTimeStamp:timeStamp.doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = str;
        });
    });
}

@end

