//
//  UIAlertController+Extend.h
//  SnailPopupControllerDemo
//
//  Created by zhanghao on 2017/3/31.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extend)

+ (void)showAlert:(NSString *)text;
+ (void)showAlert:(NSString *)text inVC:(UIViewController *)vc;

@end
