//
//  DealFlowDBMgr.m
//  Earning
//
//  Created by 木淼 on 15/4/14.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "DealFlowDBMgr.h"
#import "DBBase.h"

#define TableName @"DealFlow"

@implementation DealFlowDBMgr

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self createTable];
    }
    return self;
}


/**
 *  如果表不存在，生成
 *
 *  @param tableName 表名
 *  @param db
 */
- (void)createTable
{
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('localId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'dealTime' VARCHAR, 'number' DOUBLE, 'price' DOUBLE, 'fee' DOUBLE, 'curState' INTEGER, 'sell' INTEGER, 'categoryLocalId' INTEGER)", TableName];
    BOOL success = [DefaultDB executeUpdate:createStr];
    if (!success) {
        LogD(@"Create Table Error, TableName '%@'", TableName);
    }
}

#pragma - mark public method

+ (DealFlowDBMgr*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static DealFlowDBMgr* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

- (void) insert:(DealItem*)item
{
    //(localId, dealTime, name, code, number, price, fee, curPrice, curPriceTime, curState) VALUES (%d, %d, '%@', '%@', %f, %f, %f, %f, %d, %d)
    NSString *insertStr = [NSString stringWithFormat:@"REPLACE INTO '%@' (dealTime, number, price, fee, curState, sell, categoryLocalId) VALUES ('%@', %f, %f, %f, %d, %d, %d)", TableName, item.dealTime, item.number, item.price, item.fee, item.curState, item.sell, item.categoryLocalId];
    
    [EarnDBBase executeUpdateSql:insertStr];
}

- (void) deleteById:(int)localId
{
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where localId=%d", TableName, localId];
    [EarnDBBase executeUpdateSql:sql];
}

- (void) update:(DealItem*)item
{
    NSString *sql = [NSString stringWithFormat:@"update '%@' set dealTime='%@', number=%f, price=%f, fee=%f, curState=%d, sell=%d where localId=%d", TableName, item.dealTime, item.number, item.price, item.fee, item.curState, item.sell, item.localId];
    
    [EarnDBBase executeUpdateSql:sql];

}

- (NSArray*) selectAll
{
    return [self selectByCategoryId:-1];
}

- (NSArray*) selectByCategoryId:(int)categoryLocalId
{
    if (!DefaultDB) {
        return nil;
    }
    NSString *queryStr = nil;
    if (categoryLocalId == -1) {
        queryStr = [NSString stringWithFormat:@"SELECT * FROM '%@'", TableName];
    }
    else
    {
        queryStr = [NSString stringWithFormat:@"SELECT * FROM '%@' where categoryLocalId=%d", TableName, categoryLocalId];
    }
    FMResultSet *result = [DefaultDB executeQuery:queryStr];
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    while ([result next]) {
        DealItem* item = [[DealItem alloc]init];
        item.localId = [result intForColumnIndex:0];
        item.dealTime = [result stringForColumnIndex:1];
        item.number = [result doubleForColumnIndex:2];
        item.price = [result doubleForColumnIndex:3];
        item.fee = [result doubleForColumnIndex:4];
        item.curState = [result intForColumnIndex:5];
        item.sell = [result boolForColumnIndex:6];
        item.categoryLocalId = [result intForColumnIndex:7];
        [resultArr addObject:item];
    }
    [result close];
    return resultArr;
}

@end
