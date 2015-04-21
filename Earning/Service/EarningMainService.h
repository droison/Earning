//
//  EarningMainService.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryItem.h"
#import "DealItem.h"
#import "PriceItem.h"

#define MainService [EarningMainService sharedInstance]

@protocol IDataChangeExt <NSObject>
@optional
- (void) categoryRefresh; //用于更新所有category数据
- (void) categoryUpdate:(CategoryItem*)item; //更新单个category
- (void) categoryInsert;
- (void) dealInsert:(DealItem*)item;
@end

/**
 *  统一管理三种数据对数据库的操作
 *  统一管理网络操作
 */
@interface EarningMainService : NSObject

+ (EarningMainService*) sharedInstance;
- (NSArray*) selectAllCategory;
- (void) updateCategoryItem:(CategoryItem*)item;
- (void) insertCategoryItem:(CategoryItem*)item;

- (void) insertDealItem:(DealItem*)item;
- (NSArray*) getDealArrayByCategoryId:(int)categoryLocalId;

- (void) requestCategoryCurPrice:(NSArray*)codeArray;
@end
