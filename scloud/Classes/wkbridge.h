//
//  WkBridge.h
//  AVOSCloud
//
//  Created by XUChenghao on 2019/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface wkbridge : NSObject
+ (instancetype) shared;


- (void) init: (UIViewController*) view;
- (void) onResume;
- (void) onPause;
@end

NS_ASSUME_NONNULL_END
