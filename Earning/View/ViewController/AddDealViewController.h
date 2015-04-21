//
//  AddDealViewController.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItem.h"
#import "BaseViewController.h"

/**
 *  增加每一笔交易，categoryItem不能为空，需要它的localId
 *  样式为title上显示
 */
@interface AddDealViewController : BaseViewController

@property (nonatomic, strong) CategoryItem* categoryItem;
@end
