//
//  UIViewController+DKHUD.m
//  DKProgressHUD
//
//  Created by huanghao on 16/1/13.
//  Copyright (c) 2016年 huanghao. All rights reserved.
//

#import "UIViewController+DKHUD.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

@implementation NSObject (DKHUD)
/**
 *  显示成功提示框
 *
 *  @param title 需要显示的title
 */
- (void)showSuccess:(NSString *)title
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [[UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0x00FF00) >> 8))/255.0 blue:((float)(0x000000 & 0x0000FF))/255.0 alpha:1]colorWithAlphaComponent:0.8];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self pathOfIsSuccess:YES]]];
    hud.labelText = title;
    [hud hide:YES afterDelay:1.0];
}

/**
 *  显示失败提示框
 *
 *  @param title 需要显示的title
 */
- (void)showError:(NSString *)title
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [[UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0x00FF00) >> 8))/255.0 blue:((float)(0x000000 & 0x0000FF))/255.0 alpha:1]colorWithAlphaComponent:0.8];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self pathOfIsSuccess:NO]]];
    hud.labelText = title;
    [hud hide:YES afterDelay:1.0];
}

/**
 *  显示加载HUD，默认为‘菊花’转动
 *
 *  @param title 需要显示的title
 */
- (void)showHUD:(NSString *)title
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [[UIColor colorWithRed:((float)((0x000000 & 0xFF0000) >> 16))/255.0 green:((float)((0x000000 & 0x00FF00) >> 8))/255.0 blue:((float)(0x000000 & 0x0000FF))/255.0 alpha:1]colorWithAlphaComponent:0.8];
    hud.labelText = title;
}

//- (void)showGIFHUD:(NSString *)title
//{
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    [MBProgressHUD hideAllHUDsForView:view animated:YES];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.color = [UIColor clearColor];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"F"]];
//}

/**
 *  隐藏提示框
 */
- (void)hideHUD
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

/**
 *  加载资源路径
 *
 *  @param isSuccess 是否是成功
 *
 *  @return 资源路径
 */
- (NSString *)pathOfIsSuccess:(BOOL)isSuccess
{
    
    NSString *imageName = isSuccess? @"success-white" : @"error-white";
    
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"DKExtensions" ofType:@"bundle"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DKProgressHUD.bundle/%@",imageName]];
    
    if (!path) {
        path = [[[NSBundle mainBundle] pathForResource:@"DKProgressHUD" ofType:@"bundle"] stringByAppendingPathComponent:imageName];
    }
    
    return path;
}

- (UIWindow *)getKeyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

@end










