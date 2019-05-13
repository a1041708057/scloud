//
//  MyWebView.h
//  WKWV
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UIView+Additions.h"

@interface MyWebView : UIView
@property(nonatomic) UIButton* button;
@property(nonatomic) UITableView* table;
@property(nonatomic) UIWebView* webview;
@property(nonatomic) UIView* backView;
@property(nonatomic) UIView* parentView;
@property(nonatomic) NSMutableArray* dataSource;
@property(nonatomic) BOOL isMenuOn;

-(instancetype)init: (BOOL)isPortrait;
-(void)openUrl: (NSString*) url;
- (void)resignButton;
@end
