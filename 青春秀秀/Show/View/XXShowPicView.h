//
//  XXShowPicView.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/19.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"

@interface XXShowPicView : UIView<SDPhotoBrowserDelegate>
//图片名字数组
@property (nonatomic,strong) NSArray *picPathStringsArray;
//imageview数组
@property (nonatomic,strong) NSMutableArray *imageViewArray;

@end
