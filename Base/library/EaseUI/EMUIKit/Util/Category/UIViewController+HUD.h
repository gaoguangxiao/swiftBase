/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface UIViewController (HUD)
//等待提示
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;
//带有背景的提示文字
- (void)showHint:(NSString *)hint;
//带有图片的提示文字
- (void)showHint:(NSString *)hint andImage:(UIImage *)image;
//仅仅只是提示
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
