//
//  MyWebView.m
//  WKWV
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyWebView.h"
#import "macro.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define ZFBundle_Name @"assets.bundle"
#define ZFBundle_Path [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ZFBundle_Name]
#define ZFBundle [NSBundle bundleWithPath:ZFBundle_Path]

@interface MyWebView () <WKUIDelegate,WKNavigationDelegate,UITableViewDataSource,UITableViewDelegate,WKScriptMessageHandler>
    
@end

@implementation MyWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init: (BOOL)isPortrait {
    self.isMenuOn = NO;
    int offsetX = 0;
    int offsetY = 0;
    int offsetWidth = 0;
    CGRect rect;
    int screenWidth = 0;
    int screenHeight = 0;
    if (isPortrait) {
        screenWidth = MIN(ScreenWidth, ScreenHeight);
        screenHeight = MAX(ScreenWidth, ScreenHeight);
    } else {
        screenWidth = MAX(ScreenWidth, ScreenHeight);
        screenHeight = MIN(ScreenWidth, ScreenHeight);
    }
    
    if (isPortrait) {
        offsetX = 0;
        offsetY = 30;
        offsetWidth = 0;
    } else {
        offsetX = 44;
        offsetWidth = 44*2;
        offsetY = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom/2;
    }
    rect = CGRectMake(0, 0, screenWidth, screenHeight);
    self = [super initWithFrame:rect];
    
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        [self performSelector:@selector(initView) withObject:nil afterDelay:0];
//        [self initView];
        //        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

-(void) initView {
    _dataSource = [NSMutableArray arrayWithObjects:@"返回", @"前进", @"刷新", @"取消", nil];
    
    //背影黑罩
    UIView* backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    UITapGestureRecognizer* panBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [backView addGestureRecognizer:panBack];
    self.backView = backView;
    
    
    //算出table的CGRect
    CGRect rect = self.bounds;
    int height = 4 * 44;
    rect.origin.y = rect.size.height - height;
    rect.size.height = height;
    
    _table = [[UITableView alloc]initWithFrame:rect];
    _table.delegate = self;
    _table.dataSource = self;
    [self addSubview:_table];
    
    self.backView.alpha = 0;
    _table.alpha = 0;
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 60)];

    // 创建导航栏组件
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    
    UIButton *backButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.layer.masksToBounds=YES;
    backButton.layer.cornerRadius=3;
//    backButton.titleLabel.font=[UIFont systemFontOfSize:15];
//    [backButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    UIImage *backImg = [UIImage imageNamed:@"a2.png"];
    [backButton setBackgroundImage:  [self scaleToSize:backImg size:CGSizeMake(self.frame.size.width/16, self.frame.size.width/16)] forState:(UIControlState)UIControlStateNormal];
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    UIButton *refreshButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    refreshButton.layer.masksToBounds=YES;
    refreshButton.layer.cornerRadius=3;
//    refreshButton.titleLabel.font=[UIFont systemFontOfSize:15];
//    [refreshButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    UIImage *refreshImg = [UIImage imageNamed:@"a4.png"];
    [refreshButton setBackgroundImage:  [self scaleToSize:refreshImg size:CGSizeMake(self.frame.size.width/16, self.frame.size.width/16)] forState:(UIControlState)UIControlStateNormal];
    
    refreshButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *goButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
//    [goButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIImage *goImg = [UIImage imageNamed:@"a1.png"];
    [goButton setBackgroundImage:  [self scaleToSize:goImg size:CGSizeMake(self.frame.size.width/16, self.frame.size.width/16)] forState:(UIControlState)UIControlStateNormal];
    goButton.layer.masksToBounds=YES;
    goButton.layer.cornerRadius=3;
//    goButton.titleLabel.font=[UIFont systemFontOfSize:15];
//    [goButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    goButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [goButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *homeButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
//    [homeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIImage *homeImg = [UIImage imageNamed:@"a3.png"];
    [homeButton setBackgroundImage:  [self scaleToSize:homeImg size:CGSizeMake(self.frame.size.width/16, self.frame.size.width/16)] forState:(UIControlState)UIControlStateNormal];
    homeButton.layer.masksToBounds=YES;
    homeButton.layer.cornerRadius=3;
//    homeButton.titleLabel.font=[UIFont systemFontOfSize:15];
//    [homeButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    homeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    UIBarButtonItem *go = [[UIBarButtonItem alloc] initWithCustomView:goButton];
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
        spaceItem.width = self.frame.size.width/4;
    
    
    
    
    [navItem setRightBarButtonItems:[NSArray arrayWithObjects: go,spaceItem, refresh,spaceItem,home,spaceItem,back,nil]];
  

    // 把导航栏组件加入导航栏
    [navBar pushNavigationItem:navItem animated:false];
    
    navBar.barTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* bar = [defaults stringForKey:@"bar"];
    
    if([bar isEqual:@"true"]){
        [self addSubview:navBar];
    }
    
    
//    UIWindow* window = [UIApplication sharedApplication].windows[0];
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
//    button.alpha = 0.4f;
//    button.frame = CGRectMake(ScreenWidth - 70, ScreenHeight - 150, 60, 60);
//    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    [button setBackgroundColor:[UIColor orangeColor]];
//    button.layer.cornerRadius = 30;
//    button.layer.masksToBounds = YES;
//    [button addTarget:self action:@selector(resignButton) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
//    self.button = button;
//    
//    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)];
//    [self.button addGestureRecognizer:pan];
}



//改变图片的大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (void)resignButton {
    if (self.isMenuOn) {
        [self hide];
    } else {
        [self show:self.superview];
    }
    self.isMenuOn = !self.isMenuOn;
}

-(void) changePosition: (UIPanGestureRecognizer*) pan {
    CGPoint point = [pan translationInView:self.button];
    CGRect originalFrame = self.button.frame;
    CGFloat width = ScreenWidth;
    CGFloat height = ScreenHeight;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y + originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.button.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:_button];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _button.enabled = NO;
        _button.alpha = 1.0f;
    } else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        CGRect frame = _button.frame;
        //是否越界
        BOOL isOver = NO;
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            isOver = YES;
        } else if (frame.origin.x+frame.size.width > width) {
            frame.origin.x = width - frame.size.width;
            isOver = YES;
        } else {
            if (frame.origin.x > 0 && frame.origin.x < width / 2) {
                frame.origin.x = 0;
                isOver = YES;
            } else {
                frame.origin.x = width - frame.size.width;
                isOver = YES;
            }
        }
        if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > height) {
            frame.origin.y = height - frame.size.height;
            isOver = YES;
        }
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self->_button.frame = frame;
                self->_button.alpha = 0.4f;
            }];
        }
        _button.enabled = YES;
        
    }
}

-(void) hideMenu: (UITapGestureRecognizer*) pan {
    [self hide];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    int offsetX = 0;
    int offsetY = 0;
    CGRect rect;
    if (IsPortrait) {
        offsetX = 0;
        offsetY = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
    } else {
        offsetX = 44;
        offsetY = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
    }
    rect = CGRectMake(-offsetX, 0, ScreenWidth+offsetX*2, ScreenHeight+offsetY);

    self = [super initWithFrame:[[UIApplication sharedApplication] delegate].window.bounds];

    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        //        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

-(void)openUrl: (NSString*) url {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* bar = [defaults stringForKey:@"bar"];
    if([bar isEqual:@"true"]){
        self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height-60)];
    }else{
        self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    }
//    self.webview.allowsBackForwardNavigationGestures = YES;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSDictionary* reqheader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    request.allHTTPHeaderFields = reqheader;
    [self.webview loadRequest:request];
    
    [self addSubview:self.webview];
    
    self.webview.delegate = self;
    
//    self.webview.UIDelegate=self;
//    self.webview.navigationDelegate=self;
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if(navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


//显示
- (void) show:(UIView*)parent
{
    UIView* parentView = parent;
    
    //先隐藏backView,table
    self.backView.alpha = 0;
    _table.alpha = 0;
    
    //移动table
    [_table setTransform:CGAffineTransformMakeTranslation(0, _table.frame.size.height)];
    
    //父窗口添加本view，---这个会调用viewDidLoad
//    [parentView.superview addSubview:self];
    
    //添加动画，添加到父窗口中，使之从下移动上
    [UIView animateWithDuration:0.3 animations:^{
        //父窗口缩小
//        CGAffineTransform t = CGAffineTransformMakeScale(0.9, 0.9);
//        [parentView setTransform:t];
        
        //显示backview,table
        self.backView.alpha = 1;
        _table.alpha = 1;
        
        //移动table,CGAffineTransformIdentity还原原始坐标
        [_table setTransform:CGAffineTransformIdentity];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}
//隐藏
- (void) hide
{
    //添加动画，添加到父窗口中，使之从下移动上
    [UIView animateWithDuration:0.3 animations:^{
        //父窗口还原
        CGAffineTransform t = CGAffineTransformIdentity;
        [self.parentView setTransform:t];
        
        //显示backview,table
        self.backView.alpha = 0;
        _table.alpha = 0;
        
        //移动table
        [_table setTransform:CGAffineTransformMakeTranslation(0, _table.frame.size.height)];
        
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ( [request.URL.absoluteString hasPrefix:@"alipay://"]||[request.URL.absoluteString hasPrefix:@"weixin://"]) {
        return [[UIApplication sharedApplication]openURL:request.URL];
    }
    return YES;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString* scheme = navigationAction.request.URL.scheme;
    if (![scheme containsString:@"http"] && ![scheme containsString:@"https"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:^(BOOL success) {}];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)click_back{
    [self.webview goBack];
}
-(void)click_exit {
    [self removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _dataSource[indexPath.section];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)go{
    if ([self.webview canGoForward]) {
        [self.webview goForward];
    }
    [self hide];
}

-(void)back{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }
    [self hide];
}

-(void)refresh{
    [self.webview reload];
    [self hide];
}

-(void)home{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* url = [defaults stringForKey:@"xcloud"];
    [self openUrl:url];
    [self hide];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if ([self.webview canGoBack]) {
                [self.webview goBack];
            }
            [self hide];
            break;
        case 1:
            if ([self.webview canGoForward]) {
                [self.webview goForward];
            }
            [self hide];
            break;
        case 2:
            [self.webview reload];
            [self hide];
            break;
        case 3:
            [self hide];
            break;
            
        default:
            break;
            
        
    }
}

@end
