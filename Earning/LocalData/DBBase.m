//
//  DBBase.m
//  IMTest
//
//  Created by droison on 14-4-25.
//  Copyright (c) 2014年 QYER. All rights reserved.
//

#import "DBBase.h"
#import "FMDatabase.h"

#define DBVersion 1  //版本号从1开始，递增处理
#define DefaultName [NSString stringWithFormat:@"Earning%d.db", DBVersion]

@implementation DBBase

static DBBase *instance = nil;

/**
 *  单例初始化
 *
 *  @return
 */

+ (DBBase*)getInstance
{
    @synchronized([DBBase class])
	{
		if (!instance)
			instance = [[self alloc] init];
        return instance;
	}
	return nil;
}

+ (id)alloc
{
	@synchronized([DBBase class])
	{
		NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton.");
		instance = [super alloc];
		return instance;
	}
	return nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

/**
 *  生成数据库文件夹
 *
 *  @param tableName
 *
 *  @return
 */
- (NSString*)dbFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Database"];
    BOOL isDirectory;
    NSError *error = nil;
    NSFileManager *fileMagager = [NSFileManager defaultManager] ;
    BOOL isExist = [fileMagager fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isExist) {
        [fileMagager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return filePath;
}

/**
 *  生成数据库和表
 *
 *  @param tableName 表名
 *
 *  @return
 */
- (FMDatabase*)createDatabase
{
    if (!_db) {
        NSString *filePath = [self dbFilePath];
        NSString *dbPath = [filePath stringByAppendingPathComponent:DefaultName];
        LogD(@"Database Path %@", dbPath);
        _db = [[FMDatabase alloc] initWithPath:dbPath];
        if ([_db open]) {
            return _db;
        }
        else
        {
            LogE(@"Database Open Error!");
            _db = nil;
            return nil;
        }
        
    }
    return _db;
}

/**
 *  编辑数据
 *
 *  @param tableName 表名
 *  @param updateSql 编辑数据的sql语句
 */
- (void)executeUpdateSql:(NSString*)updateSql
{
    FMDatabase* db = [self createDatabase];
    if (!db) {
        return;
    }
    BOOL isSuccess = [db executeUpdate:updateSql];
    if (!isSuccess) {
        LogW(@"executeUpdateWithTableName Error, UpdateSQL %@", updateSql);
    }
}

- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments
{
    FMDatabase* db = [self createDatabase];
    if (!db) {
        return NO;
    }
    BOOL isSuccess = [db executeUpdate:sql withParameterDictionary:arguments];
    if (!isSuccess) {
        LogW(@"executeUpdateWithTableName Error, UpdateSQL %@ and Parameter: %@", sql, arguments);
    }
    return isSuccess;
}

-(void)dealloc
{
    _db = nil;
}
@end
