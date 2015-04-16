//
//  DBBase.h
//  IMTest
//
//  Created by droison on 14-4-25.
//  Copyright (c) 2014年 QYER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define EarnDBBase [DBBase getInstance]
#define DefaultDB [EarnDBBase createDatabase]
/**
 *  本地消息数据库
 */
@interface DBBase : NSObject
{
    FMDatabase *_db;
}
/**
 *  单例初始化
 *
 *  @return
 */
+ (DBBase*)getInstance;
- (FMDatabase*)createDatabase;
- (void)executeUpdateSql:(NSString*)updateSql;
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
@end
