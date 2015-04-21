//
//  DataFormat.m
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "DateFormat.h"

@implementation DateFormat

+ (NSDateFormatter*)sharedNSDateFormatterInstance
{
    static dispatch_once_t pred = 0;
    __strong static NSDateFormatter* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[NSDateFormatter alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+ (NSString*) formatPriceTime:(int)time
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return [DateFormat formatPriceDate:date];
}

+ (NSString*) formatPriceDate:(NSDate*)date
{
    NSDateFormatter* selectDateFormatter = [self sharedNSDateFormatterInstance];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:date]; // 把date类型转为设置好格式的string类型
    return dateAndTime;
}
@end
