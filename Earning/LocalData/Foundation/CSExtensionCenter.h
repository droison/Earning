//
//  CSExtensionCenter.h
//  MicroMessenger
//
//  Created by yuyu on 11-3-24.
//  Copyright 2011 Tecent. All rights reserved.
//

/*
	扩展中心： 一系列的事件， 每个事件是一个协议， 对应着多个协议实现者（接收事件者）。
 以协议为媒介， 事件产生者和接收者都不知道对方存在。
 
	接收者
 必须实现事件（如ICContactMgrExt）协议
 1 登记 REGISTER_EXTENSION(ICContactMgrExt, self);
 2 取消登记 UNREGISTER_EXTENSION(ICContactMgrExt, self);
 3 在协议函数中处理事件
	产生者
 1 SAFECALL_EXTENSION(ICContactMgrExt, OnAddContact:oContact);
 */

/* 备忘
 
 2、 不知道是谁发起的事件. (真想知道， 自己通过参数传把）
 
 3、相互引用：
	REGISTER_EXTENSION后， 关注者会被引用， 而一般在关注者析构时才会UnRegister。 但因为被引用了， 没办法掉到析构。
	引入MMExtensionObject， 不再对关注者加引用。但带来其他问题：
	如果关注者忘记UnRegister， 则会crash。
 
 4、如果关注者忘记UnRegister然后析构了， 则会crash。
 */

struct objc_method_description;

#import"CSServiceCenter.h"
#import "ObjcRuntimeUtil.h"

/// 为了observer不被增加引用计数，引入一个包装类。
@interface MMExtensionObject : NSObject
{
    CFTypeRef m_Obj;
    BOOL m_deleteMark;
#ifndef NDEBUG
    NSString* m_nsClass;
#endif
}
@property (nonatomic, assign) BOOL m_deleteMark;
#ifndef NDEBUG
@property (nonatomic, retain) NSString* m_nsClass;
#endif

- (void) setObject:(CFTypeRef) Obj;
- (CFTypeRef) getObject;

- (BOOL) isObjectEqual:(CFTypeRef) Obj;

@end


@interface CSExtensionDictionary : NSObject
{
    NSMutableDictionary* m_dic;
    BOOL m_needCleanUp;
}

-(BOOL) registerExtension:(__unsafe_unretained id) oObserver forKey:(id) nsKey;
-(BOOL) unregisterExtension:(__unsafe_unretained id) oObserver forKey:(id) nsKey;
-(BOOL) unregisterKeyExtension:(__unsafe_unretained id)oObserver;
-(NSArray*) getKeyExtensionList:(id) nsKey;

-(void) cleanUp;

@end


/* extension. keep observer list.
 1. Ext -> Observer list
 2. Ext, key -> Observer List.
	key一般用nsstring
 */
@interface MMExtension : NSObject
{
    // protocl
    __unsafe_unretained MMExtKey m_extKey;
    
    // selector
    unsigned int m_methodCount;
    struct objc_method_description* m_methods;
    
    // selector -> array(MMExtensionObject)
    CSExtensionDictionary	*m_dicObserver;
}

- (id) initWithKey:(__unsafe_unretained MMExtKey) oKey;

-(BOOL) registerExtension:(__unsafe_unretained id) oObserver;
-(void) unregisterExtension:(__unsafe_unretained id) oObserver;
-(NSArray *) getExtensionListForSelector:(SEL)selector;

// 为了效率考虑（不每次SAFE_CALL都新建一个NSArray），延迟清理unreg
-(void) cleanUp;

@end

/// extension center. keep extension list
@interface CSExtensionCenter : CSService <CSService>
{
    // map(MMExtKey -> MMExtension)
    NSMutableDictionary *m_dicExtension;
}

- (MMExtension *) getExtension: (__unsafe_unretained MMExtKey) key;

@end

#define REGISTER_EXTENSION(ext, obj)	\
{ MMExtension *__oExt__ = [GET_SERVICE(CSExtensionCenter) getExtension:@protocol(ext)]; \
if (__oExt__) { [__oExt__ registerExtension:obj]; } }

#define UNREGISTER_EXTENSION(ext, obj)	\
{ MMExtension *__oExt__ = [GET_SERVICE(CSExtensionCenter) getExtension:@protocol(ext)]; \
if (__oExt__) { [__oExt__ unregisterExtension:obj]; } }

#define SAFECALL_EXTENSION(ext, sel, func)	\
{\
MMExtension *__oExt__ = [GET_SERVICE(CSExtensionCenter) getExtension:@protocol(ext)]; \
if (__oExt__) { NSArray *__ary__ = [__oExt__ getExtensionListForSelector:sel]; \
for(UInt32 __index__ = 0; __index__ < __ary__.count; __index__++) { \
MMExtensionObject *__obj__ = [__ary__ objectAtIndex:__index__]; \
if(__obj__.m_deleteMark == YES)continue; \
id __oExtObj__ = (__bridge id)[__obj__ getObject]; \
{ \
[__oExtObj__ func]; } \
} \
} \
}

#define THREAD_SAFECALL_EXTENSION(ext, sel, func) \
{ \
if ([NSThread isMainThread]) { \
SAFECALL_EXTENSION(ext, sel, func); \
} else { \
dispatch_sync(dispatch_get_main_queue(), ^{ \
SAFECALL_EXTENSION(ext, sel, func); \
}); \
} \
}
