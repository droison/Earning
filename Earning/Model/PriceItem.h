//
//  PriceItem.h
//  Earning
//
//  Created by 淞 柴 on 15/4/19.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceItem : NSObject

@property (nonatomic, assign) int localId;
@property (nonatomic, assign) double curPrice;
@property (nonatomic, strong) NSString* curPriceTime; //最后一次更新价格的时间 2014-05-01
@property (nonatomic, assign) int categoryLocalId; //外键
@end
