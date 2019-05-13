//
//  xcloud.h
//  webview
//
//  Created by XUChenghao on 2019/3/12.
//  Copyright © 2019年 XUChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface xcloud : NSObject
+ (void) registApp: (UIView*) view withAppId: (NSString*) appId widthClientKey: (NSString*) clientKey;
+ (void) show: (NSString*) tableName objectId: (NSString*) obj withKey: (NSString*) field;
@end

NS_ASSUME_NONNULL_END
