//
//  BaseViewController.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ErrorAlertTag 404404

@interface BaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView* _tableview;
    BOOL _needTableview;
    NSMutableArray* _dataArray;
}

- (void) alert:(NSString*)text;
- (void) toast:(NSString*)text;
- (void) toast:(NSString*)text duration:(int)duration;
@end
