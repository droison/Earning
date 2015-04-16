//
//  PriceDBMgr.m
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "PriceDBMgr.h"
#import "DBBase.h"

#define TableName @"Price"

@implementation PriceItem


@end

@implementation PriceDBMgr

+ (PriceDBMgr*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static PriceDBMgr* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

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
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('localId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'curPrice' DOUBLE, 'curPriceTime' INTEGER, 'categoryLocalId' INTEGER)", TableName];
    BOOL success = [DefaultDB executeUpdate:createStr];
    if (!success) {
        LogD(@"Create Table Error, TableName %@", TableName);
    }
}

- (void) insert:(PriceItem*)item
{
    //(localId, dealTime, name, code, number, price, fee, curPrice, curPriceTime, curState) VALUES (%d, %d, '%@', '%@', %f, %f, %f, %f, %d, %d)
    NSString *insertStr = [NSString stringWithFormat:@"REPLACE INTO %@ (curPrice, curPriceTime, categoryLocalId) VALUES (%f, %d, %d)", TableName, item.curPrice, item.curPriceTime, item.categoryLocalId];
    
    [EarnDBBase executeUpdateSql:insertStr];
}

- (void) deleteById:(int)localId
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where localId=%d", TableName, localId];
    [EarnDBBase executeUpdateSql:sql];
}

- (void) update:(PriceItem*)item
{
    NSString *sql = [NSString stringWithFormat:@"update %@ set curPrice=%f, curPriceTime=%d, categoryLocalId=%d where localId=%d", TableName, item.curPrice, item.curPriceTime, item.categoryLocalId, item.localId];
    
    [EarnDBBase executeUpdateSql:sql];
    
}

- (NSArray*) selectAll
{
    if (!DefaultDB) {
        return nil;
    }
    
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM %@", TableName];
    
    FMResultSet *result = [DefaultDB executeQuery:queryStr];
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    while ([result next]) {
        PriceItem* item = [[PriceItem alloc]init];
        item.localId = [result intForColumnIndex:0];
        item.curPrice = [result doubleForColumnIndex:1];
        item.curPriceTime = [result intForColumnIndex:2];
        item.categoryLocalId = [result intForColumnIndex:3];
        [resultArr addObject:item];
    }
    [result close];
    return resultArr;
}

@end
