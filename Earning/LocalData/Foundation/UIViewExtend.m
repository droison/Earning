//
//  UIViewExtend.m
//  QDaily
//
//  Created by song on 14/10/24.
//  Copyright (c) 2014年 droison. All rights reserved.
//

#import "UIViewExtend.h"

@implementation UIView(ViewFrameGeometry)
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) x
{
    return self.frame.origin.x;
}

- (void) setX: (CGFloat) x
{
    CGRect newframe = self.frame;
    newframe.origin.x = x;
    self.frame = newframe;
}

- (CGFloat) y
{
    return self.frame.origin.y ;
}

- (void) setY: (CGFloat) y
{
    CGRect newframe = self.frame;
    newframe.origin.y = y ;
    self.frame = newframe;
}


- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

- (void) fitTheSubviews
{
    CGFloat fWidth = 0 ;
    CGFloat fHeight = 0 ;
    for( UIView * subview in self.subviews )
    {
        fWidth = MAX( fWidth , subview.right ) ;
        fHeight = MAX( fHeight , subview.bottom ) ;
    }
    self.size = CGSizeMake( fWidth , fHeight ) ;
}

- (void) ceilAllSubviews
{
    for (UIView *subView in self.subviews)
    {
        subView.frame = CGRectMake(ceilf(subView.left), ceilf(subView.top), ceilf(subView.width), ceilf(subView.height));
    }
}

-(void) frameIntegral
{
    self.frame = CGRectIntegral(self.frame) ;
}



-(void) removeAllSubViews{
    for( UIView * subView in self.subviews ){
        [subView removeFromSuperview];
    }
}

-(void) removeSubViewWithTag : (UInt32) uiTag {
    UIView * subView = [self viewWithTag:uiTag];
    while( subView ){
        [subView removeFromSuperview];
        subView = [self viewWithTag:uiTag];
    }
}

-(void) removeSubViewWithClass : (Class) oClass {
    for( UIView * subView in self.subviews ){
        if( [subView isKindOfClass:oClass] ){
            [subView removeFromSuperview] ;
        }
    }
}

@end