//
//  MMDateFormat.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMDateFormat : NSObject

/**
 *  会将时间格式化为2015-06-01样式
 *
 *  @param time 时间 1970年以后的秒数
 *
 *  @return 
 */
+ (NSString*) formatPriceTime:(long)time;

+ (NSString*) formatPriceDate:(NSDate*)date;

/**
 *  入参必须是2015-06-01样式
 *
 *  @param str 2015-06-01样式的时间
 *
 *  @return 1970年以来的s数
 */
+ (int) reformat2PriceTime:(NSString*)str;
+ (NSDate*) reformat2PriceDate:(NSString*)str;
@end
