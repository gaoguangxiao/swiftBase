//
//  TZShortVideoController.h
//  wisdomstudy
//
//  Created by ggx on 2017/8/24.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZShortVideoController : UIViewController
@property (nonatomic, copy) void (^cancelOperratonBlock)(NSURL *movieUrl);
@end
