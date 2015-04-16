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

@implementation CategoryItem


@end

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
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('localId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, 'name' VARCHAR , 'code' VARCHAR, 'curPrice' DOUBLE, 'curPriceTime' INTEGER, 'totalNumber' DOUBLE, 'totalPrice' DOUBLE)", TableName];
    BOOL success = [DefaultDB executeUpdate:createStr];
    if (!success) {
        LogD(@"Create Table Error, TableName %@", TableName);
    }
}

- (void) insert:(CategoryItem*)item
{
    //(localId, dealTime, name, code, number, price, fee, curPrice, curPriceTime, curState) VALUES (%d, %d, '%@', '%@', %f, %f, %f, %f, %d, %d)
    NSString *insertStr = [NSString stringWithFormat:@"REPLACE INTO %@ (name, code, curPrice, curPriceTime, totalNumber, totalPrice) VALUES ('%@', '%@', %f, %d, %f, %f)", TableName, item.name, item.code, item.curPrice, item.curPriceTime, item.totalNumber, item.totalPrice];
    
    [EarnDBBase executeUpdateSql:insertStr];
}

- (void) deleteById:(int)localId
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where localId=%d", TableName, localId];
    [EarnDBBase executeUpdateSql:sql];
}

- (void) update:(CategoryItem*)item
{
    NSString *sql = [NSString stringWithFormat:@"update %@ set name='%@', code='%@', curPrice=%f, curPriceTime=%d, totalNumber=%f, totalPrice=%f where localId=%d", TableName, item.name, item.code, item.curPrice, item.curPriceTime, item.totalNumber, item.totalPrice, item.localId];
    
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
        CategoryItem* item = [[CategoryItem alloc]init];
        item.localId = [result intForColumnIndex:0];
        item.name = [result stringForColumnIndex:1];
        item.code = [result stringForColumnIndex:2];
        item.curPrice = [result doubleForColumnIndex:3];
        item.curPriceTime = [result intForColumnIndex:4];
        item.totalNumber = [result boolForColumnIndex:5];
        item.totalPrice = [result boolForColumnIndex:6];
        [resultArr addObject:item];
    }
    [result close];
    return resultArr;
}

@end
