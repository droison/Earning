//
//  AddCategoryViewController.h
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItem.h"
#import "BaseViewController.h"

@interface AddCategoryViewController : BaseViewController

@property (nonatomic, strong) CategoryItem * categoryItem; //通过这个值来确定是否是更新操作
@end
