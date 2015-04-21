//
//  DataFormat.h
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormat : NSObject

/**
 *  会将时间格式化为2015:06:01样式
 *
 *  @param time 时间 1970年以后的秒数
 *
 *  @return 
 */
+ (NSString*) formatPriceTime:(int)time;

+ (NSString*) formatPriceDate:(NSDate*)date;
@end
