//
//  PriceDBMgr.h
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceItem.h"

@interface PriceDBMgr : NSObject

+ (PriceDBMgr*)sharedInstance;

- (void) insert:(PriceItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(PriceItem*)item;
- (void) insertOrUpdate:(PriceItem*)item;

- (int) selectLocalIdByCategoryLocalId:(int)categoryLocalId PriceTime:(NSString*)priceTime;
- (NSArray*) selectAll;
@end
