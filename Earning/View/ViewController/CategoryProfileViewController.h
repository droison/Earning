//
//  CategoryProfileViewController.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItem.h"
#import "BaseViewController.h"

/**
 *  上面显示价格和时间，总笔数，收入   下面是每一笔交易
 */
@interface CategoryProfileViewController : BaseViewController

@property(nonatomic, strong) CategoryItem* categoryItem;
@end
