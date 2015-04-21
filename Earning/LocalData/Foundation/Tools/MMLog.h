//
//  MMLog.h
//  Earning
//
//  Created by 木淼 on 15/4/14.
//  Copyright (c) 2015年 mumiao. All rights reserved.
//

#define LogV(format, ...) NSLog(@"-[VERBOSE] %s(%d行): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogI(format, ...) NSLog(@"-[INFO] %s(%d行): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogW(format, ...) NSLog(@"-[WARN] %s(%d行): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LogE(format, ...) NSLog(@"-[ERROR] %s(%d行): " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#ifdef DEBUG
#define LogD(format, ...)  LogI(format, ##__VA_ARGS__)
#else
#define LogD(format, ...)
#endif