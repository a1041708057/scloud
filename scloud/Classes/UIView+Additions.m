//
//  UiView+Additions.m
//  dcsdk
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIView+Additions.h"
#import <objc/runtime.h>

@implementation UIView (Addition)

-(void)WIDTH: (CGFloat) constant {
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:constant];
    [self addConstraint:widthConstraint];
    [self layoutIfNeeded];
}
-(void)HEIGHT: (CGFloat) constant {
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:constant];
    [self addConstraint:heightConstraint];
    [self layoutIfNeeded];
}
-(void)CENTER_X:(CGFloat)constant {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:constant];
    [self.superview addConstraint:leftConstraint];
}
-(void)CENTER_Y: (CGFloat) constant {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
    [self.superview addConstraint:topConstraint];
}
-(void)LEFT: (CGFloat) constant {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:constant];
    [self.superview addConstraint:leftConstraint];
}
-(void)RIGHT: (CGFloat) constant {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-constant];
    [self.superview addConstraint:leftConstraint];
}
-(void)TOP: (CGFloat) constant {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant];
    [self.superview addConstraint:topConstraint];
}
-(void)LEFT: (UIView*)item dis: (CGFloat) constant {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeLeft multiplier:1.0 constant:constant];
    [self.superview addConstraint:leftConstraint];
}
-(void)TOP: (UIView*)item dis: (CGFloat) constant {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant];
    [self.superview addConstraint:topConstraint];
}
-(void)BOTTOM: (UIView*)item dis: (CGFloat) constant {
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-constant];
    [self.superview addConstraint:topConstraint];
}
-(void)WRAP_WIDTH: (CGFloat) constant {
    CGFloat width = self.superview.bounds.size.width - constant * 2;
    [self WIDTH:width];
}
-(void)WRAP_HEIGHT: (CGFloat) constant {
    CGFloat height = self.superview.bounds.size.height - constant * 2;
    [self HEIGHT:height];
}

-(void)transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.5;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}
@end
