//
//  UIView+UiView_Additions.h
//  dcsdk
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)
-(void)WIDTH: (CGFloat) constant;
-(void)HEIGHT: (CGFloat) constant;
-(void)CENTER_X: (CGFloat) constant;
-(void)CENTER_Y: (CGFloat) constant;
-(void)LEFT: (CGFloat) constant;
-(void)RIGHT: (CGFloat) constant;
-(void)TOP: (CGFloat) constant;
-(void)LEFT: (UIView*)item dis: (CGFloat) constant;
-(void)TOP: (UIView*)item dis: (CGFloat) constant;
-(void)BOTTOM: (UIView*)item dis: (CGFloat) constant;
-(void)WRAP_WIDTH: (CGFloat) constant;
-(void)WRAP_HEIGHT: (CGFloat) constant;

-(void)transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view;
@end
