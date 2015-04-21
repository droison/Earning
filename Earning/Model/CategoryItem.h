//
//  CategoryItem.h
//  Earning
//
//  Created by 淞 柴 on 15/4/19.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int{
    CategoryEnumFund = 0, //基金
    CategoryEnumStock = 1, //股票
} CategoryEnum;

@interface CategoryItem : NSObject

@property (nonatomic, assign) int localId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, assign) double curPrice; //保存一份，应该和PriceDB中对应的最后一条相同
@property (nonatomic, strong) NSString* curPriceTime; //保存一份，应该和PriceDB中对应的最后一条相同
@property (nonatomic, assign) double totalNumber; //总持股数量，每次增删后统计
@property (nonatomic, assign) double totalPrice; //总成本，名字没有起好 （总价值只需要curPrice*totalNumber就好了，不需要单独存）
@property (nonatomic, assign) CategoryEnum type;
@property (nonatomic, assign) BOOL shouldAutoSync; //是否何以自动查询数据，默认为NO
@property (nonatomic, assign) double gsPrice; //估算值保存一份，应该和PriceDB中对应的最后一条相同
@property (nonatomic, strong) NSString* gsPriceTime; //估算时间保存一份，应该和PriceDB中对应的最后一条相同
@end
