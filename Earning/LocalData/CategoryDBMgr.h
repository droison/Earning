//
//  CategoryDBMgr.h
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryItem.h"

@interface CategoryDBMgr : NSObject

+ (CategoryDBMgr*)sharedInstance;

- (void) insert:(CategoryItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(CategoryItem*)item;
- (void) update:(CategoryItem*)item withCode:(NSString*)code;

- (int) selectLocalIdByCode:(NSString*)code;
- (NSArray*) selectAll;
@end
