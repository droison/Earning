//
//  UIViewExtend.h
//  QDaily
//
//  Created by song on 14/10/24.
//  Copyright (c) 2014年 droison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(ViewFrameGeometry)
@end

@interface UIView (FindUIViewController)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat x ;
@property CGFloat y ;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

- (void) fitTheSubviews ;
- (void) ceilAllSubviews ;
-(void) frameIntegral ;

-(void) removeAllSubViews;
-(void) removeSubViewWithTag : (UInt32) uiTag;
-(void) removeSubViewWithClass : (Class) oClass;
@end
