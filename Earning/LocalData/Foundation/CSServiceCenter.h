//
//  CSServiceCenter.h
//  QDaily
//
//  Created by song on 14/11/12.
//  Copyright (c) 2014年 droison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSService : NSObject {
    BOOL m_isServiceRemoved;
    BOOL m_isServicePersistent;		// 注销或者退出, 是否还需要驻留内存
}
@property (assign) BOOL m_isServiceRemoved;
@property (assign) BOOL m_isServicePersistent;

@end

/// MMService协议
@protocol CSService<NSObject>

@optional

// call after yourservice create.
-(void) onServiceInit;

// 切换帐号后， 调用。 对应maincontroll的reload.
-(void) onServiceReloadData;

// 进入后台运行
-(void) onServiceEnterBackground;

// 进入前台运行
-(void) onServiceEnterForeground;

// 程序退出
-(void) onServiceTerminate;

// memory fuck.
-(BOOL) onServiceMemoryWarning;

// 退出登录时调用 用于清理资源.
-(void) onServiceClearData;

@end

// 持久对象中心。 用来存放为全局服务的对象。
@interface CSServiceCenter : NSObject
{
    NSMutableDictionary *m_dicService;
    NSRecursiveLock	*m_lock;
}
 // 由app管理本类的生命周期;
+(CSServiceCenter *) defaultCenter;

// 获取服务对象。
// 如果对象不存在， 会自动创建。 但只能创建继承于MMService基类的对象.
-(id) getService:(Class) cls;

// 从core中移除， 但如果引用计数>1。。。凉拌吧。
-(void) removeService:(Class) cls;

// event
-(void) callEnterForeground;
-(void) callEnterBackground;
-(void) callTerminate;
-(void) callClearData;
-(void) callServiceMemoryWarning;
-(void) callReloadData;

@end

#define GET_SERVICE(obj) ((obj*)[[CSServiceCenter defaultCenter] getService:[obj class]])

#define REMOVE_SERVICE(obj) [[CSServiceCenter defaultCenter] removeService:[obj class]]