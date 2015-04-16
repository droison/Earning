//
//  CategoryDBMgr.h
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (nonatomic, assign) int localId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, assign) double curPrice; //保存一份，应该和PriceDB中对应的最后一条相同
@property (nonatomic, assign) int curPriceTime; //保存一份，应该和PriceDB中对应的最后一条相同
@property (nonatomic, assign) double totalNumber; //总持股数量，每次增删后统计
@property (nonatomic, assign) double totalPrice; //总价格，每次增删后统计
@end

@interface CategoryDBMgr : NSObject

+ (CategoryDBMgr*)sharedInstance;

- (void) insert:(CategoryItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(CategoryItem*)item;

- (NSArray*) selectAll;
@end
