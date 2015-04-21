//
//  DealFlowDBMgr.h
//  Earning
//
//  Created by 木淼 on 15/4/14.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DealItem.h"

@interface DealFlowDBMgr : NSObject
+ (DealFlowDBMgr*)sharedInstance;

- (void) insert:(DealItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(DealItem*)item;

- (NSArray*) selectAll;
- (NSArray*) selectByCategoryId:(int)categoryLocalId;
@end
