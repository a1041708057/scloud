//
//  macro.h
//  dcsdk
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//
#import "UIView+Additions.h"

#ifndef macro_h
#define macro_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define ZFBundle_Name @"assets.bundle"
#define ZFBundle_Path [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ZFBundle_Name]
#define ZFBundle [NSBundle bundleWithPath:ZFBundle_Path]

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#endif /* macro_h */
