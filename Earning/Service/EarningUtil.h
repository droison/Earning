//
//  EarningUtil.h
//  Earning
//
//  Created by 淞 柴 on 15/4/22.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryItem.h"

@interface EarningUtil : NSObject
/**
 *  只是本地计算，没有网络操作，默认item已经获取了今日估算值
 *
 *  @param item
 *
 *  @return
 */
+ (NSString*) calcTodayEarning:(CategoryItem*)item;

+ (BOOL) calc:(CategoryItem*)item TodayEarning:(double*)earn isGS:(BOOL*)isGS;
@end
