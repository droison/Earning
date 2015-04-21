//
//  EarningMainService.m
//  Earning
//
//  Created by 淞 柴 on 15/4/17.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "EarningMainService.h"
#import "CategoryDBMgr.h"
#import "DealFlowDBMgr.h"
#import "PriceDBMgr.h"
#import "DataRequest.h"
#import "CSExtensionCenter.h"

@interface EarningMainService ()
{
    CategoryDBMgr* _categoryDBMgr;
    DealFlowDBMgr* _dealFlowDBMgr;
    PriceDBMgr* _priceDBMgr;
    
    DataRequest* _dataRequest;
}

@end

@implementation EarningMainService

+ (EarningMainService*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static EarningMainService* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _categoryDBMgr = [CategoryDBMgr sharedInstance];
        _dealFlowDBMgr = [DealFlowDBMgr sharedInstance];
        _priceDBMgr = [PriceDBMgr sharedInstance];
        _dataRequest = [[DataRequest alloc]init];
    }
    return self;
}

#pragma  - mark Category
- (NSArray*) selectAllCategory
{
    return [_categoryDBMgr selectAll];
}

- (void) updateCategoryItem:(CategoryItem*)item
{
    [_categoryDBMgr update:item];
    SAFECALL_EXTENSION(IDataChangeExt, @selector(categoryUpdate:), categoryUpdate:item);
}

- (void) insertCategoryItem:(CategoryItem*)item
{
    [_categoryDBMgr insert:item];
    SAFECALL_EXTENSION(IDataChangeExt, @selector(categoryInsert), categoryInsert);
}

#pragma  - mark Deal
- (void) insertDealItem:(DealItem*)item
{
    [_dealFlowDBMgr insert:item];
    SAFECALL_EXTENSION(IDataChangeExt, @selector(dealInsert:), dealInsert:item);
}

- (NSArray*) getDealArrayByCategoryId:(int)categoryLocalId
{
    return [_dealFlowDBMgr selectByCategoryId:categoryLocalId];
}

#pragma  - mark net
- (void) requestCategoryCurPrice:(NSArray*)codeArray
{
    if (codeArray && codeArray.count > 0) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:[codeArray componentsJoinedByString:@","] forKey:@"fc"];
        
        [params setObject:[NSNumber numberWithInt:0] forKey:@"pstart"];
        [params setObject:[NSNumber numberWithInt:30] forKey:@"psize"];
        [params setObject:@"kf" forKey:@"t"];
        [params setObject:[NSNumber numberWithLong:time(NULL)] forKey:@"dt"];
        
        [_dataRequest sendRequestWithUrl:DataRequestFavInfo params:params success:^(id item) {
            if (item!=nil && [item isKindOfClass:[NSArray class]])
            {
                for (NSDictionary* dic in item) {
                    int categoryLocalId = [_categoryDBMgr selectLocalIdByCode:dic[@"fundcode"]];
                    if (categoryLocalId == -1) {
                        LogE(@"categoryLocalId不存在 基金或股票代码：%@", dic[@"fundcode"]);
                        continue;
                    }
                    PriceItem* priceItem = [[PriceItem alloc]init];
                    priceItem.curPrice = [dic[@"dwjz"] doubleValue];
                    priceItem.curPriceTime = dic[@"jzrq"];
                    priceItem.categoryLocalId = categoryLocalId;
                    [_priceDBMgr insertOrUpdate:priceItem];
                    
                    CategoryItem* categoryItem = [[CategoryItem alloc]init];
                    
                    categoryItem.code = dic[@"fundcode"];
                    categoryItem.gsPrice = [dic[@"gsz"] doubleValue];
                    categoryItem.gsPriceTime = dic[@"gztime"];
                    categoryItem.curPrice = [dic[@"dwjz"] doubleValue];
                    categoryItem.curPriceTime = dic[@"jzrq"];
                    categoryItem.name = dic[@"name"];
                    categoryItem.shouldAutoSync = YES;
                    [_categoryDBMgr update:categoryItem withCode:dic[@"fundcode"]];
                    
                }
                SAFECALL_EXTENSION(IDataChangeExt, @selector(categoryRefresh), categoryRefresh);
            }
            
        } fail:^(id item) {
            
        }];
    }
}
@end
