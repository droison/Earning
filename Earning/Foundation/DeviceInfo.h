//
//  DeviceInfo.h
//  QDaily
//
//  Created by song on 14-10-16.
//  Copyright (c) 2014年 droison. All rights reserved.
//

@interface UIDevice (Hardware)

+ (NSString *) getSysInfoByName:(char *)typeSpeifier;
+ (int) getSysInfo:(uint)typeSpecifier;
- (NSString *) platform;
- (int) cpuCount;
- (int) cpuFrequency;
- (int) busFrequency;
- (int) totalMemory;
- (int) userMemory;
- (int) cacheLine;
- (int) L1ICacheSize;
- (int) L1DCacheSize;
- (int) L2CacheSize;
- (int) L3CacheSize;

@end

@interface DeviceInfo : NSObject {
    
}

+ (NSString *) modelPlatform;
+ (NSString *) DModel;
+ (NSString *) DSystem;
+ (NSString *) DCPU;
+ (NSString *) DMemory;
+ (NSString *) DBus;
+ (NSString *) DCache;
+ (CGFloat) TotalDiskSpaceSize;
+ (CGFloat) FreeDiskSpaceSize;

+ (BOOL) isiPhone;
+ (BOOL) isiPhone2G;
+ (BOOL) isiPhone3G;
+ (BOOL) isiPhone3GS;
+ (BOOL) isiPhone4;
+ (BOOL) isiPhone4S;
+ (BOOL) isiPhone5;
+ (BOOL) isiPhone5S;
+ (BOOL) isiPhone5C;
+ (BOOL) isiPhone6p;
+ (BOOL) isiPhone6;
+ (BOOL) isiPodTouch;
+ (BOOL) isiPodTouch1;
+ (BOOL) isiPodTouch2;
+ (BOOL) isiPodTouch3;
+ (BOOL) isiPodTouch4;
+ (BOOL) isiPodTouch5;
+ (BOOL) isiPad;
+ (BOOL) isiPad1;
+ (BOOL) isiPad2;
+ (BOOL) isiPad3;
+ (BOOL) isiPad4;
+ (BOOL) isiPadMini;
+ (BOOL) isiPadUniversal;
+ (BOOL) isLowPerformanceDevice;
+ (BOOL) isUnderiPhone4s;

+ (BOOL) isiOS8plus;
+ (BOOL) isiOS7_1plus;
+ (BOOL) isiOS7plus;
+ (BOOL) isiOS7;
+ (BOOL) isiOS7Below;
+ (BOOL) isiOS6plus;
+ (BOOL) isiOS6_1plus;
+ (BOOL) isiOS5_1plus;
+ (BOOL) isiOS5plus;

+ (BOOL) is568hScreen;
+ (BOOL) is667hScreen;
+ (BOOL) is736hScreen;
//根据屏幕分辨率判断的是否是6p的标准模式
+ (BOOL) isiPhone6pScreen;
//根据屏幕分辨率判断的是否是6的标准模式
+ (BOOL) isiPhone6Screen;

+ (BOOL)is2xScreen;

+ (BOOL)is3xScreen;

+ (BOOL)is568H2xScreen;

@end
