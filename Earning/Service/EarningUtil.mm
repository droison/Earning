//
//  EarningUtil.m
//  Earning
//
//  Created by 淞 柴 on 15/4/22.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "EarningUtil.h"
#import "MMDateFormat.h"

@implementation EarningUtil

+ (NSString*) calcTodayEarning:(CategoryItem*)item
{
//    NSString* todayTime = [MMDateFormat formatPriceTime:time(NULL)];
//    BOOL isGS = NO;
//    double earn = 0;
//    NSString* timeStr = nil;
//    if ([item.gsPriceTime isEqualToString:item.curPriceTime])
//    {
//        isGS = NO;
//        earn = item.curZZL * (item.totalNumber * item.curPrice)/(100+item.curZZL);
//        if ([todayTime isEqualToString:item.curPriceTime])
//        {
//            timeStr = @"今日";
//        }
//        else
//        {
//            timeStr = item.curPriceTime;
//        }
//    }
//    else
//    {
//        isGS = YES;
//        earn = item.gsZZL * (item.totalNumber * item.curPrice)/(100+item.gsZZL);
//        if ([todayTime isEqualToString:item.gsPriceTime])
//        {
//            timeStr = @"今日";
//        }
//        else
//        {
//            timeStr = item.gsPriceTime;
//        }
//    }
    /**
     1、估值时间和价格时间一致，说明今天已经是真实值，按照今日百分比算
     2、不一致，按照估算
     **/
    
    double earn = 0;
    BOOL isGS = NO;
    if ([EarningUtil calc:item TodayEarning:&earn isGS:&isGS]) {
        return [NSString stringWithFormat:@"今日%@：%.2f", isGS ?@"估算收益" :@"收益", earn];
    }
    else
    {
        return @"今日无数据";
    }
    
}

+ (BOOL) calc:(CategoryItem*)item TodayEarning:(double*)earn isGS:(BOOL*)isGS
{
    NSString* todayTime = [MMDateFormat formatPriceTime:time(NULL)];

    *earn = 0;
    if ([item.gsPriceTime isEqualToString:item.curPriceTime])
    {
        if (![todayTime isEqualToString:item.curPriceTime]) {
            return NO;
        }
        *isGS = NO;
        *earn = item.curZZL * (item.totalNumber * item.curPrice)/(100+item.curZZL);

    }
    else
    {
        if (![todayTime isEqualToString:item.gsPriceTime])
        {
            return NO;
        }
        *isGS = YES;
        *earn = item.gsZZL * (item.totalNumber * item.curPrice)/(100+item.gsZZL);
        
    }
    return YES;
}
@end
