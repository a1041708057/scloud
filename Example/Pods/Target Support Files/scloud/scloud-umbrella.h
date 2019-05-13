#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Alert.h"
#import "macro.h"
#import "MyWebView.h"
#import "SSKeychain.h"
#import "TextViewController.h"
#import "UIView+Additions.h"
#import "wkbridge.h"
#import "xcloud.h"

FOUNDATION_EXPORT double scloudVersionNumber;
FOUNDATION_EXPORT const unsigned char scloudVersionString[];

