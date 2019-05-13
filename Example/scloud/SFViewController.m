//
//  SFViewController.m
//  scloud
//
//  Created by 1041708057@qq.com on 05/13/2019.
//  Copyright (c) 2019 1041708057@qq.com. All rights reserved.
//

#import "SFViewController.h"
#import <xcloud.h>

@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [xcloud registApp:self.view withAppId:@"u8PMWdpfdxwAFky6hTfiny4G-gzGzoHsz" widthClientKey:@"7lg6NP6bVfSOXLVKi0gWsJel"];
    [xcloud show:@"IndonesianEnglish" objectId:@"5cd652b70237d70069cdc800" withKey:@"url"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
