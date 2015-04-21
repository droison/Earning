//
//  CSServiceCenter.m
//  QDaily
//
//  Created by song on 14/11/12.
//  Copyright (c) 2014年 droison. All rights reserved.
//

#import "CSServiceCenter.h"

static __unsafe_unretained CSServiceCenter *g_ServiceCenter = nil;

@implementation CSService
@synthesize m_isServiceRemoved;
@synthesize m_isServicePersistent;

-(void)dealloc
{
    //    CLEAR_DELEGATE_OR_OWNER(self);
    //    [super dealloc];
}

@end

@implementation CSServiceCenter

- (id) init
{
    if(self = [super init])
    {
        LogD(@"Create service center");
        
        m_dicService = [[NSMutableDictionary alloc] init];
        
        m_lock = [[NSRecursiveLock alloc] init];
        
        g_ServiceCenter = self;
    }
    return self;
}

- (void) dealloc
{
    if(m_dicService != nil)
    {
        LogD(@"dealloc service center");
        
        m_dicService = nil;
    }
    
    //	[m_lock release];
    m_lock = nil;
    
    g_ServiceCenter = nil;
    
    //	[super dealloc];
}

+(CSServiceCenter *) defaultCenter
{
    // 由app管理本类的生命周期;
    return g_ServiceCenter;
}

-(id) getService:(Class) cls
{
    [m_lock lock];
    
    id obj = [m_dicService objectForKey:[cls description]];
    
    if (obj == nil)
    {
        // Service必须继承 MMService<MMService>
        if (![cls isSubclassOfClass:[CSService class]]) {
            LogW(@"%@ is not a MMService", NSStringFromClass(cls));
            [m_lock unlock];
            assert(0);
            return nil;
        }
        if (![cls conformsToProtocol:@protocol(CSService)]) {
            LogW(@"%@ do not conforms protocol <MMService>", NSStringFromClass(cls));
            [m_lock unlock];
            assert(0);
            return nil;
        }
        
        //obj = [[cls alloc] init];
        // 将init放在alloc之后， 防止在init里面做了啥有影响的东西。
        obj = [[cls alloc] init];
        
        //[obj init];
        
        [m_dicService setObject:obj forKey:[cls description]];
        
        LogD(@"Create service object: %@", obj);
        
        [m_lock unlock];
        
        // call init
        if ([obj respondsToSelector:@selector(onServiceInit)])
        {
            [obj onServiceInit];
        }
        
        //		[obj release];
    }
    else
    {
        [m_lock unlock];
    }
    
    return obj;
}

-(void) removeService:(Class) cls
{
    [m_lock lock];
    
    CSService<CSService>* obj = [m_dicService objectForKey:[cls description]];
    
    if (obj == nil)
    {
        [m_lock unlock];
        return ;
    }
    
    // ARC版本不能使用retainCount，注释该段警告代码
    //	if ([obj retainCount] > 2)
    //	{
    //		// 因为remove的时候有个数组keep多了一次未读数
    //		CommonWarning(@"ERR: !!! removeService: Service Object retainCount > 2. Object:%@ RetainCount:[ %u ]May be memory leak!!! ", obj, [obj retainCount]);
    //	}
    
    // retain 为了不让在unlock之前调用dealloc.
    //	[obj retain];
    
    [m_dicService removeObjectForKey:[cls description]];
    
    obj.m_isServiceRemoved = YES;
    
    [m_lock unlock];
    
    // 这里才会出发dealloc
    //	[obj release];
    obj = nil;
}

-(void) callEnterForeground
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(id obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceEnterForeground)])
        {
            [obj onServiceEnterForeground];
        }
        
    }
}

-(void) callEnterBackground
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(id obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceEnterBackground)])
        {
            [obj onServiceEnterBackground];
        }
        
    }
}

-(void) callTerminate
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(id obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceTerminate)])
        {
            [obj onServiceTerminate];
        }
        
    }
}

-(void) callServiceMemoryWarning
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(id obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceMemoryWarning)])
        {
            [obj onServiceMemoryWarning];
        }
        
    }
}

-(void) callReloadData
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(id obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceReloadData)])
        {
            [obj onServiceReloadData];
        }
        
    }
}

-(void) callClearData
{
    [m_lock lock];
    NSArray *aryCopy = [m_dicService allValues];
    [m_lock unlock];
    
    for(CSService<CSService>* obj in aryCopy)
    {
        if ([obj respondsToSelector:@selector(onServiceClearData)])
        {
            [obj onServiceClearData];
        }
        
        if (obj.m_isServicePersistent == NO)
        {
            // remove
            [self removeService:[[obj class]description]];
            // 注意：removeService后，obj不能再使用。fase enumeration 中，obj不会增加计数，当obj从数组移除后，obj可能会释放，不能再访问。
        }
        else
        {
            // keep
        }
    }
}
@end