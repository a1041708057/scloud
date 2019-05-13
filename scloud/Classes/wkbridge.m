//
//  WkBridge.m
//  AVOSCloud
//
//  Created by XUChenghao on 2019/4/4.
//

#import "wkbridge.h"
#import "Alert.h"
#import <WebKit/WebKit.h>
#import <AdSupport/AdSupport.h>
#import "SSKeychain.h"

@interface wkbridge () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic) UIViewController* uiviewctrl;
@property(nonatomic) WKWebView* webview;
@end

static wkbridge* bridge = NULL;

@implementation wkbridge

+ (instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge = [[self alloc] init];
    });
    return bridge;
}

- (void) init: (UIViewController*) vc {
    self.uiviewctrl = vc;
    UIView* view = vc.view;
    for (UIView* sub in view.subviews) {
        BOOL find = NO;
        for (UIView* subsub in sub.subviews) {
            if ([subsub isKindOfClass:WKWebView.class]) {
                self.webview = (WKWebView*)subsub;
                
                self.webview.UIDelegate=self;
                self.webview.navigationDelegate=self;
                
                [self initJS];
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
    }
}

- (void) initJS {
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"paste"];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"saveImage"];
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"openUrl"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString* scheme = navigationAction.request.URL.scheme;
    if (![scheme containsString:@"http"] && ![scheme containsString:@"https"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:^(BOOL success) {}];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"paste"]) {
        NSString* msg = message.body;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = msg;
        [self.webview evaluateJavaScript:@"alert('复制成功')" completionHandler:^(id _Nullable item, NSError * _Nullable error){
            NSLog(@"复制成功");
        }];
    } else if ([message.name isEqualToString:@"saveImage"]) {
        NSURL* url=[NSURL URLWithString:message.body];
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:), NULL);
    } else if ([message.name isEqualToString:@"openUrl"]) {
        NSURL* url = [NSURL URLWithString:message.body];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if ([prompt isEqualToString:@"uuid"]) {
        NSString *uuid = [SSKeychain passwordForService:@"qpuuid" account:@"uuid"];
        if (uuid == NULL) {
            uuid = [[NSUUID UUID] UUIDString];
            [SSKeychain setPassword:uuid forService:@"qpuuid" account:@"uuid"];
        }
//        NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        completionHandler(uuid);
    } else if ([prompt isEqualToString:@"writeToFile"]) {
        NSData* data = [defaultText dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            completionHandler(@"2");
            return;
        }
        NSString* filename = json[@"file"];
        NSString* content = json[@"content"];
        
        NSString* docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString* txtPath = [docPath stringByAppendingPathComponent:filename];
        BOOL isSuccess = [content writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (isSuccess) {
            completionHandler(@"0");
        } else {
            completionHandler(@"1");
        }
    } else if ([prompt isEqualToString:@"readFromFile"]) {
        NSString* docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString* txtPath = [docPath stringByAppendingPathComponent:defaultText];
        //读取文件
        NSString* readString = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
        completionHandler(readString);
    } else if ([prompt isEqualToString:@"readFromPaste"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteboard.string != NULL) {
            completionHandler(pasteboard.string);
        } else {
            completionHandler(@"");
        }
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    Alert *alertController = [Alert alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self.uiviewctrl presentViewController:alertController animated:YES completion:nil];
}


- (void) onResume {
    if (self.webview != NULL) {
        [self.webview evaluateJavaScript:@"onGameResume()" completionHandler:^(id _Nullable item, NSError * _Nullable error){
            NSLog(@"enter foreground");
        }];
    }
    
}
- (void) onPause {
    if (self.webview != NULL) {
        [self.webview evaluateJavaScript:@"onGamePause()" completionHandler:^(id _Nullable item, NSError * _Nullable error){
            NSLog(@"enter background");
        }];
    }
}

- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error){
        //保存失败
        [self.webview evaluateJavaScript:@"alert('保存失败')" completionHandler:^(id _Nullable item, NSError * _Nullable error){
            NSLog(@"保存失败");
        }];
    }else {
        //保存成功
        [self.webview evaluateJavaScript:@"alert('保存成功')" completionHandler:^(id _Nullable item, NSError * _Nullable error){
            NSLog(@"保存成功");
        }];
    }
}


@end
