//
//  CategoryDBMgr.m
//  Earning
//
//  Created by 淞 柴 on 15/4/16.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#import "CategoryDBMgr.h"
#import "DBBase.h"

#define TableName @"Category"

@implementation CategoryDBMgr
+ (CategoryDBMgr*)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static CategoryDBMgr* _sharedObject = nil;
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
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('localId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'name' VARCHAR , 'code' VARCHAR, 'curPrice' DOUBLE, 'curPriceTime' VARCHAR, 'totalNumber' DOUBLE, 'totalPrice' DOUBLE, 'type' INTEGER, 'shouldAutoSync' INTEGER, 'gsPrice' DOUBLE, 'gsPriceTime' INTEGER)", TableName];
    BOOL success = [DefaultDB executeUpdate:createStr];
    if (!success) {
        LogW(@"Create Table Error, TableName '%@'", TableName);
    }
}

- (void) insert:(CategoryItem*)item
{
    //(localId, dealTime, name, code, number, price, fee, curPrice, curPriceTime, curState) VALUES (%d, %d, '%@', '%@', %f, %f, %f, %f, %d, %d)
    NSString *insertStr = [NSString stringWithFormat:@"REPLACE INTO '%@' (name, code, curPrice, curPriceTime, totalNumber, totalPrice, type, shouldAutoSync, gsPrice, gsPriceTime) VALUES ('%@', '%@', %f, '%@', %f, %f, %d, %d, %f, '%@')", TableName, item.name, item.code, item.curPrice, item.curPriceTime, item.totalNumber, item.totalPrice, item.type, item.shouldAutoSync, item.gsPrice, item.gsPriceTime];
    
    [EarnDBBase executeUpdateSql:insertStr];
}

- (void) deleteById:(int)localId
{
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where localId=%d", TableName, localId];
    [EarnDBBase executeUpdateSql:sql];
}

- (void) update:(CategoryItem*)item
{
    NSString *sql = [NSString stringWithFormat:@"update '%@' set name='%@', curPrice=%f, curPriceTime='%@', totalNumber=%f, totalPrice=%f, type=%d, shouldAutoSync=%d, gsPrice=%f, gsPriceTime='%@' where localId=%d", TableName, item.name, item.curPrice, item.curPriceTime, item.totalNumber, item.totalPrice, item.type, item.shouldAutoSync, item.gsPrice, item.gsPriceTime, item.localId];
    
    [EarnDBBase executeUpdateSql:sql];
}

- (void) update:(CategoryItem*)item withCode:(NSString*)code
{
    NSString *sql = [NSString stringWithFormat:@"update '%@' set name='%@', curPrice=%f, curPriceTime='%@', shouldAutoSync=%d, gsPrice=%f, gsPriceTime='%@' where code='%@'", TableName, item.name, item.curPrice, item.curPriceTime, item.shouldAutoSync, item.gsPrice, item.gsPriceTime, item.code];
    [EarnDBBase executeUpdateSql:sql];
}

- (int) selectLocalIdByCode:(NSString*)code
{
    NSString *queryStr = [NSString stringWithFormat:@"SELECT localId FROM '%@' where code=%@", TableName, code];
    FMResultSet *result = [DefaultDB executeQuery:queryStr];
    if ([result next]) {
        int localId = [result intForColumnIndex:0];
        return localId;
    }
    else
    {
        return -1;
    }
}

- (NSArray*) selectAll
{
    if (!DefaultDB) {
        return nil;
    }
    
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM '%@'", TableName];
    
    FMResultSet *result = [DefaultDB executeQuery:queryStr];
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    while ([result next]) {
        CategoryItem* item = [[CategoryItem alloc]init];
        item.localId = [result intForColumnIndex:0];
        item.name = [result stringForColumnIndex:1];
        item.code = [result stringForColumnIndex:2];
        item.curPrice = [result doubleForColumnIndex:3];
        item.curPriceTime = [result stringForColumnIndex:4];
        item.totalNumber = [result doubleForColumnIndex:5];
        item.totalPrice = [result doubleForColumnIndex:6];
        item.type = [result intForColumnIndex:7];
        item.shouldAutoSync = [result boolForColumnIndex:8];
        item.gsPrice = [result doubleForColumnIndex:9];
        item.gsPriceTime = [result stringForColumnIndex:10];
        [resultArr addObject:item];
    }
    [result close];
    return resultArr;
}

@end
