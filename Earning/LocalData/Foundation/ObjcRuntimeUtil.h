//
//  ObjcRuntimeUtil.h
//  MicroMessenger
//
//  Created by Guo Ling on 11/26/12.
//  Copyright (c) 2012 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <vector>


typedef Protocol * MMExtKey;

@interface ObjcRuntimeUtil : NSObject

+(BOOL) isClass:(Class)cls inheritsFromClass:(Class)baseClass;

+(std::vector<objc_method_description>) getAllMethodOfProtocol:(Protocol*) proto;

+(NSString*) getCallerMethod;

@end


// using objc_setAssociatedObject to attach/detach object in dynamic
@interface NSObject (ObjcRuntime)

-(void) attachObject:(id)obj forKey:(NSString*)nsKey;

-(id) getAttachedObjectForKey:(NSString*)nsKey;

-(void) detachObjectForKey:(NSString*)nsKey;

-(void)removeAssociatedObjects;

@end