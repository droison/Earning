//
//  UiUtil.m
//  QDaily
//
//  Created by song on 14-10-16.
//  Copyright (c) 2014年 droison. All rights reserved.
//

#import "UiUtil.h"

BOOL g_isTaskBarHidden = YES;
BOOL g_isStatusBarLandscape = NO;
UIStatusBarStyle g_currentStatusBarStyle;
CGSize g_screenSize = CGSizeZero;

@implementation UiUtil

#pragma mark - UI Parameter

CGFloat g_statusBarHeight = 20;

+(CGFloat) statusBarHeight {
    return [UiUtil statusBarHeight:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGFloat) statusBarHeight:(UIInterfaceOrientation)orientation {
    // iOS8上的状态栏高度已改成设备方向相关
    CGFloat statusBarHeight = 0;
    if ([DeviceInfo isiOS8plus]) {
        if (![UIApplication sharedApplication].statusBarHidden) {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        else {
            // ios8上当statusBar隐藏时，statusBarFrame的宽高为零，取出上一次的结果作为返回值
            statusBarHeight = g_statusBarHeight;
        }
    }
    else {
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
        }
        else {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    g_statusBarHeight = statusBarHeight;
    return statusBarHeight;
}

+(CGFloat) screenHeight {
    if ([DeviceInfo isiOS8plus]) {
        if (CGSizeEqualToSize(g_screenSize, CGSizeZero)) {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        else {
            return g_screenSize.height;
        }
    }
    else {
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

+(CGFloat) screenHeightCurOri {
    return [UiUtil screenHeight:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGFloat) screenHeight:(UIInterfaceOrientation)orientation {
    // iOS8上的屏幕大小已改成设备方向相关
    if ([DeviceInfo isiOS8plus]) {
        if (CGSizeEqualToSize(g_screenSize, CGSizeZero)) {
            // 横竖屏方向不一致，取width作为height
            if((UIInterfaceOrientationIsPortrait(orientation) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
               || (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) && UIInterfaceOrientationIsLandscape(orientation))) {
                return [[UIScreen mainScreen] bounds].size.width;
            }
            return [[UIScreen mainScreen] bounds].size.height;
        }
        else {
            return g_screenSize.height;
        }
    }
    else {
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.width;
        }
        return [[UIScreen mainScreen] bounds].size.height;
    }
}

+(CGFloat) screenWidth {
    if ([DeviceInfo isiOS8plus]) {
        if (CGSizeEqualToSize(g_screenSize, CGSizeZero)) {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        else {
            return g_screenSize.height;
        }
    }
    else {
        return [[UIScreen mainScreen] bounds].size.width;
    }
}

+(CGFloat) screenWidthCurOri {
    return [UiUtil screenWidth:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGFloat) screenWidth:(UIInterfaceOrientation)orientation
{
    // iOS8上的屏幕大小已改成设备方向相关
    if ([DeviceInfo isiOS8plus]) {
        if (CGSizeEqualToSize(g_screenSize, CGSizeZero)) {
            // 横竖屏方向不一致，取height作为width
            if((UIInterfaceOrientationIsPortrait(orientation) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
               || (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) && UIInterfaceOrientationIsLandscape(orientation))) {
                return [[UIScreen mainScreen] bounds].size.height;
            }
            return [[UIScreen mainScreen] bounds].size.width;
        }
        else {
            return g_screenSize.width;
        }
    }
    else {
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        return [[UIScreen mainScreen] bounds].size.width;
    }
}

+ (void)setScreenSize:(CGSize)screenSize
{
    g_screenSize = screenSize;
}

+(CGSize) screenSize
{
    return CGSizeMake(QDScreenWidth, QDScreenHeight);
}

+(CGSize) screenSizeOri:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(QDScreenWidthOri(orientation), QDScreenHeightOri(orientation));
}

+(CGRect) screenBounds
{
    return CGRectMake(0, 0, QDScreenWidth, QDScreenHeight);
}

+(CGRect) screenBoundsOri:(UIInterfaceOrientation)orientation
{
    return CGRectMake(0, 0, QDScreenWidthOri(orientation), QDScreenHeightOri(orientation));
}

+ (UIWindow*)getTopVisibleWindow
{
    NSArray* windows = [[UIApplication sharedApplication] windows];
    UIWindowLevel topWindowLevel = FLT_MIN;
    UIWindow* topWindow = nil;
    for (UIWindow* window in windows) {
        if (!window.hidden && topWindowLevel <= window.windowLevel) {
            topWindowLevel = window.windowLevel;
            topWindow = window;
        }
    }
    return topWindow;
}

#pragma mark - StatusBar

+ (BOOL)isStatusBarHidden {
    
    //    if ([DeviceInfo isiOS7plus]) {
    //        return g_isStatusBarHidden;
    //    }
    
    return [UIApplication sharedApplication].statusBarHidden;
}

+ (BOOL)isStatusBarLandscape {
    return g_isStatusBarLandscape;
}

+ (void)setStatusBarHidden:(BOOL)bHidden {
    [UiUtil setStatusBarHidden:bHidden withAnimation:UIStatusBarAnimationNone];
}

+ (void)setStatusBarHidden:(BOOL)bHidden withAnimation:(UIStatusBarAnimation)aAnimation {
    
    // iOS7之前
    if( [[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)] ) {
        
        if (aAnimation == UIStatusBarAnimationNone) {
            [[UIApplication sharedApplication] setStatusBarHidden:bHidden] ;
        }
        else {
            [[UIApplication sharedApplication] setStatusBarHidden:bHidden withAnimation:aAnimation];
        }
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:bHidden] ;
    }
}

+ (UIInterfaceOrientation)getRotatedOrientation
{
    return [UiUtil isStatusBarLandscape] ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
}

+(CGFloat) dynamicFontSize:(CGFloat)size
{
    if ([DeviceInfo isiPhone6pScreen]) {
        return size * 1.2;
    }
    return size;
}

#pragma mark - status bar & navigation bar style

+ (void)setStatusBarFontWhite
{
    if([DeviceInfo isiOS7plus])
    {
        [UiUtil setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

+ (void)setStatusBarFontBlack
{
    [UiUtil setStatusBarStyle:UIStatusBarStyleDefault];
}

+ (void)setStatusBarStyle : (UIStatusBarStyle)style
{
    if(![DeviceInfo isiOS7plus]) return;
    
    if (g_currentStatusBarStyle != style) // 如果有TaskBar，先忽略黑字体，等TaskBar消失时再设回来。
    {
            g_currentStatusBarStyle = style;
            [[UIApplication sharedApplication] setStatusBarStyle:style];
    }
}

@end
