//
//  DealFlowDBMgr.h
//  Earning
//
//  Created by 木淼 on 15/4/14.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

typedef enum : int
{
    DealItemStateDefault = 0,
    DealItemStateDelete,
} DealItemState;

@interface DealItem : NSObject
@property (nonatomic, assign) int localId;
@property (nonatomic, assign) int dealTime;
@property (nonatomic, assign) double number;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double fee;
@property (nonatomic, assign) DealItemState curState; //已删除?也许还有别的用
@property (nonatomic, assign) bool sell; //true为买出，false为买入，默认买入
@property (nonatomic, assign) int categoryLocalId; //外键
@end

@interface DealFlowDBMgr : NSObject
+ (DealFlowDBMgr*)sharedInstance;

- (void) insert:(DealItem*)item;
- (void) deleteById:(int)localId;
- (void) update:(DealItem*)item;

- (NSArray*) selectAll;


@end
