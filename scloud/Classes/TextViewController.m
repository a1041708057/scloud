//
//  TextViewController.m
//  webview
//
//  Created by XUChenghao on 2019/4/9.
//  Copyright © 2019 XUChenghao. All rights reserved.
//

#import "TextViewController.h"
#import "MyWebView.h"
#import "wkbridge.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MyWebView* webview = [[MyWebView alloc] init:self.p];
    [webview openUrl:self.f];
    [self.view addSubview:webview];
    
    [[wkbridge shared] init:self];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.p) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.p) {
        return UIInterfaceOrientationPortrait;
    }
    return UIInterfaceOrientationLandscapeRight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
