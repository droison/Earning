//
//  BaseTableViewCell.mm
//  Earning
//
//  Created by 淞 柴 on 15/4/21.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
{
    UIScrollView* _contentScrollView;
    UILabel* _contentLabel;
}

@end

@implementation BaseTableViewCell


- (void) setContentText:(NSString*)text
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [_contentLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_contentLabel];
    }
    _contentLabel.text = text;
}
@end
