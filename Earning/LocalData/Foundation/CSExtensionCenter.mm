//
//  ExtensionCenter.m
//  MicroMessenger
//
//  Created by yuyu on 11-3-24.
//  Copyright 2011 Tecent. All rights reserved.
//

#import "CSExtensionCenter.h"
#import "ObjcRuntimeUtil.h"

#define ARC_SAFE_DELETE(obj) if(obj){obj = nil;}

// 每 5min 清理一次
#define EXTENSION_CLEAN_TIME (5*60)

@implementation MMExtensionObject

@synthesize m_deleteMark;
#ifndef NDEBUG
@synthesize m_nsClass;
#endif

- (void) setObject:(CFTypeRef) Obj
{
    // 没有增加引用计数
    m_Obj = Obj;
    
#ifndef NDEBUG
    ARC_SAFE_DELETE(m_nsClass);
    //	m_nsClass = [NSStringFromClass([Obj class]) retain];
    m_nsClass = NSStringFromClass([(__bridge id)Obj class]);
#endif
}

- (CFTypeRef) getObject
{
    return m_Obj;
}

- (BOOL) isObjectEqual:(CFTypeRef) Obj
{
    if (m_deleteMark == YES) {
        return NO;
    }
    
    if (m_Obj == Obj) {
        return YES;
    }
    
    return NO;
}

-(id) initWithObject:(CFTypeRef)Obj {
    if (self = [super init]) {
        m_deleteMark = NO;
        [self setObject:Obj];
    }
    return self;
}

#ifndef NDEBUG
-(void) dealloc {
    m_Obj = NULL;
    
    ARC_SAFE_DELETE(m_nsClass);
    
    //	[super dealloc];
}
#endif

- (NSString *)description
{
#ifndef NDEBUG
    return [NSString stringWithFormat:@"<%@-deleteMark[%d]>", m_nsClass, m_deleteMark];
#else
    return [NSString stringWithFormat:@"<%@-deleteMark[%d]>",m_Obj, m_deleteMark];
#endif
}

@end


@implementation CSExtensionDictionary

-(id) init {
    if (self = [super init]) {
        m_dic = [[NSMutableDictionary alloc] init];
        m_needCleanUp = NO;
    }
    return self;
}

-(void) dealloc {
    ARC_SAFE_DELETE(m_dic);
    
    //	[super dealloc];
}

-(BOOL) registerExtension:(__unsafe_unretained id) oObserver forKey:(id) nsKey
{
    if (oObserver == nil || nsKey == nil) {
        LogW(@"register observer[%@] for key[%@]", oObserver, nsKey);
        assert(0);
        return NO;
    }
    
    NSMutableArray* selectorImplememters = [m_dic objectForKey:nsKey];
    if (selectorImplememters == nil)
    {
        selectorImplememters = [[NSMutableArray alloc] init];
        [m_dic setObject:selectorImplememters forKey:nsKey];
        //		[selectorImplememters release];
    }
    
    for(MMExtensionObject *extObj in selectorImplememters)
    {
        if ([extObj isObjectEqual:(__bridge  CFTypeRef)oObserver])
        {
            LogD(@"registerExtension exist! observer: %@, key: %@", oObserver, nsKey);
            return NO;
        }
    }
    
    MMExtensionObject *extObj = [[MMExtensionObject alloc] initWithObject:(__bridge CFTypeRef)oObserver];
    [selectorImplememters addObject:extObj];
    //	[extObj release];
    
    return YES;
}

-(BOOL) unregisterExtension:(__unsafe_unretained id) oObserver forKey:(id) nsKey
{
    if (oObserver == nil /*|| nsKey == nil*/) {
        LogW(@"unregister observer[%@] for key[%@]", oObserver, nsKey);
        assert(0);
        return NO;
    }
    
    NSArray *ary = [m_dic objectForKey:nsKey];
    for(MMExtensionObject *extObj in ary)
    {
        //		if ([extObj isObjectEqual:oObserver])
        if (extObj.m_deleteMark == NO && [extObj getObject] == (__bridge  CFTypeRef)oObserver)
        {
            extObj.m_deleteMark = YES;
            
            m_needCleanUp = YES;
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) unregisterKeyExtension:(__unsafe_unretained id)oObserver
{
    BOOL bFound = NO;
    
    for(NSArray* selectorImplememters in [m_dic allValues])
    {
        for(MMExtensionObject *extObj in selectorImplememters)
        {
            //			if ([extObj isObjectEqual:oObserver])
            if (extObj.m_deleteMark == NO && [extObj getObject] == (__bridge  CFTypeRef)oObserver)
            {
                extObj.m_deleteMark = YES;
                
                bFound = YES;
                break;
            }
        }
    }
    
    if (bFound) {
        m_needCleanUp = YES;
    }
    return bFound;
}

-(NSArray *) getKeyExtensionList:(id) nsKey
{
    return [m_dic objectForKey:nsKey];
}

-(void) cleanUp
{
    if (!m_needCleanUp) {
        return;
    }
    m_needCleanUp = YES;
    
    for (id oKey in [m_dic allKeys])
    {
        NSMutableArray* arrExt = [m_dic objectForKey:oKey];
        NSMutableIndexSet* delIndexSet = [[NSMutableIndexSet alloc] init];
        for(NSInteger index = 0; index < arrExt.count;index++)
        {
            MMExtensionObject* extObj = [arrExt objectAtIndex:index];
            if (extObj.m_deleteMark)
            {
                [delIndexSet addIndex:index];
            }
        }
        
        [arrExt removeObjectsAtIndexes:delIndexSet];
        //        [delIndexSet release];
        
        if (arrExt.count == 0)
        {
            [m_dic removeObjectForKey:oKey];
        }
    }
}

@end


@implementation MMExtension

- (id) initWithKey:(__unsafe_unretained MMExtKey) oKey
{
    if(self = [super init])
    {
        m_dicObserver = nil;
        m_extKey = oKey;
        
        // copy all selectors
        std::vector<objc_method_description> arrMethods = [ObjcRuntimeUtil getAllMethodOfProtocol:oKey];
        
        m_methodCount = arrMethods.size();
        if (m_methodCount > 0)
        {
            m_methods = new objc_method_description[m_methodCount];
            std::copy(arrMethods.begin(), arrMethods.end(), m_methods);
        }
    }
    return self;
}

- (void) dealloc
{
    ARC_SAFE_DELETE(m_dicObserver);
    
    if (m_methods != NULL) {
        delete []m_methods;
        m_methods = NULL;
    }
    
    //	[super dealloc];
}

-(BOOL) registerExtension:(__unsafe_unretained id) oObserver
{
    if ([oObserver conformsToProtocol:m_extKey] == NO) {
        LogD(@"registerExtension: <%@> not implemented by %@ ", NSStringFromProtocol(m_extKey), oObserver);
        return NO;
    }
    if (m_dicObserver == nil) {
        m_dicObserver = [[CSExtensionDictionary alloc] init];
    }
    
    Class cls = [oObserver class];
    for (unsigned int index = 0; index < m_methodCount; index++)
    {
        objc_method_description* method = &m_methods[index];
        
        if (class_respondsToSelector(cls, method->name))
        {
            //			CommonDebug(@"%@", NSStringFromSelector(method->name));
            [m_dicObserver registerExtension:oObserver forKey:NSStringFromSelector(method->name)];
        }
    }
    //	CommonDebug(@"registerExtension ok. observer:%@ ext:%@", oObserver, m_extKey);
    
    return YES;
}

-(void) unregisterExtension:(__unsafe_unretained id) oObserver
{
    BOOL bFound = [m_dicObserver unregisterKeyExtension:oObserver];
    
    if (bFound) {
        //		CommonDebug(@"unregisterExtension ok. observer:%@ ext:%@", oObserver, m_extKey);
    } else {
        //		CommonDebug(@"unregisterExtension no found object. %@", oObserver);
    }
}


-(NSArray *) getExtensionListForSelector:(SEL)selector
{
    return [m_dicObserver getKeyExtensionList:NSStringFromSelector(selector)];
}

-(void) cleanUp
{
    [m_dicObserver cleanUp];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ => {\n%@,\n}",NSStringFromProtocol(m_extKey),m_dicObserver];
}

@end


@implementation CSExtensionCenter

- (id) init
{
    if(self = [super init])
    {
        m_isServicePersistent = YES;
        
        m_dicExtension = [[NSMutableDictionary alloc] init];
        
        [self performSelector:@selector(cleanUp) withObject:nil afterDelay:EXTENSION_CLEAN_TIME];
        
        LogD(@"ExtensionCenter Create.");
    }
    return self;
}

- (void) dealloc
{
    LogD(@"ExtensionCenter release.");
    
    if (m_dicExtension) {
        //        [m_dicExtension release];
        m_dicExtension = nil;
    }
    
    //	[super dealloc];
}

- (MMExtension *) getExtension: (__unsafe_unretained MMExtKey) oKey
{
    NSString *key = NSStringFromProtocol(oKey);
    
    MMExtension *ext = [m_dicExtension objectForKey:key];
    
    if (ext == nil)
    {
        ext = [[MMExtension alloc] initWithKey:oKey];
        
        [m_dicExtension setObject:ext forKey:key];
        
        //		[ext release];
    }
    
    return ext;
}

-(void) cleanUp {
    for (MMExtension* ext in [m_dicExtension allValues]) {
        [ext cleanUp];
    }
    [self performSelector:@selector(cleanUp) withObject:nil afterDelay:EXTENSION_CLEAN_TIME];
}

@end
