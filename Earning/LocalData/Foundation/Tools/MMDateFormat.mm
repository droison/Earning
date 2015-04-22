//
//  MMDateFormat.mm
//  Earning
//
//  Created by 木淼 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "MMDateFormat.h"

@implementation MMDateFormat

+ (NSDateFormatter*)sharedNSDateFormatterInstance
{
    static dispatch_once_t pred = 0;
    __strong static NSDateFormatter* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[NSDateFormatter alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+ (NSString*) formatPriceTime:(long)time
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return [MMDateFormat formatPriceDate:date];
}

+ (NSString*) formatPriceDate:(NSDate*)date
{
    NSDateFormatter* selectDateFormatter = [self sharedNSDateFormatterInstance];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:date]; // 把date类型转为设置好格式的string类型
    return dateAndTime;
}

+ (int) reformat2PriceTime:(NSString*)str
{
    NSDate* date = [MMDateFormat reformat2PriceDate:str];
    return [date timeIntervalSince1970];
}

+ (NSDate*) reformat2PriceDate:(NSString*)str
{
    NSDateFormatter* selectDateFormatter = [self sharedNSDateFormatterInstance];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSDate *date = [selectDateFormatter dateFromString:str]; // 把date类型转为设置好格式的string类型
    return date;
}
@end
