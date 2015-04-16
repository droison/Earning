//
//  PriceDBMgr.h
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceItem : NSObject

@property (nonatomic, assign) int localId;
@property (nonatomic, assign) double curPrice;
@property (nonatomic, assign) int curPriceTime; //最后一次更新价格的时间
@property (nonatomic, assign) int categoryLocalId; //外键
@end

@interface PriceDBMgr : NSObject

+ (PriceDBMgr*)sharedInstance;

- (void) insert:(PriceItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(PriceItem*)item;

- (NSArray*) selectAll;
@end
