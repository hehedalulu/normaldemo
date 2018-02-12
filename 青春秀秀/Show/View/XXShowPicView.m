//
//  XXShowPicView.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/19.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXShowPicView.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation XXShowPicView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPicsArray];
//        NSLog(@"pic%@",_picPathStringsArray);
        [self setupMain];
    }
    return self;
}

//初始化每一个imageView
-(void)setupMain{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    //把imageView加到背景self里面
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        //用tag标志 添加点击手势
        imageView.userInteractionEnabled = YES;
        //imageView的tag判断当前点击图片
        imageView.tag = i;
        imageView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    self.imageViewArray = [temp copy];
}

-(void)initPicsArray{
    //把没有图片名的imageView遍历隐藏
    for (long i = _picPathStringsArray.count; i <self.imageViewArray.count; i++) {
        UIImageView *imageView = [self.imageViewArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    //如果没有图片 容器View的高度设置为0
    if (_picPathStringsArray.count==0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    //根据图片数目判断宽度
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
        NSURL *imgurl = [NSURL URLWithString:_picPathStringsArray.firstObject];
        //        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
        UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:imgurl]];
//        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
        if (image.size.width) {
            //按比例缩放
            itemH = image.size.height /image.size.width *itemW;
        }
    }else{
        itemH =itemW;
    }
    //判断列数
    long perRowsItemsCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    //同步执行测量
    [_picPathStringsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //设置每一个imageview的坐标
        long columnIndex = idx % perRowsItemsCount;
        long rowIndex    = idx /perRowsItemsCount;
        UIImageView *imageView = [_imageViewArray objectAtIndex:idx];
        imageView.hidden = NO;
        NSURL *imgurl = [NSURL URLWithString:obj];
//        imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
        [imageView sd_setImageWithURL:imgurl];
        imageView.frame  = CGRectMake(columnIndex *(itemW+margin), rowIndex * (itemH +margin), itemW, itemH);
    }];
    //view的宽度 ＝ 列数 ＊ 每一个imageView的宽度 ＋ (列数－1) ＊ 间隙宽度
    CGFloat w = perRowsItemsCount * itemW +(perRowsItemsCount-1)*margin;
    //行数 不小于（图片数除以列数）最小的数
    int columnCount = ceilf( _picPathStringsArray.count * 1.0 / perRowsItemsCount );
    CGFloat h = columnCount *itemH +(columnCount - 1) *margin;
    self.width  = w;
    self.height = h;
    
    
    self.fixedWidth  = @(w);
    self.fixedHeight = @(h);
}
//设置图片名的数组
-(void)setPicPathStringsArray:(NSArray *)picPathStringsArray{
    _picPathStringsArray = picPathStringsArray;
//    NSLog(@"pic%@",_picPathStringsArray);
//    for (UIView *view in [self subviews]) {
//        [view removeFromSuperview];
//    }
    [self initPicsArray];
//    [self setupMain];
}

#pragma mark - private actions

//点击之后打开图片浏览器
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //当前点击图片
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    //图片浏览器的个数
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    //一张图
    if (array.count == 1) {
        return 150;
    } else {
        //多张图不同宽度
        CGFloat w = [UIScreen mainScreen].bounds.size.width*0.25;
        return w;
    }
}
// 判断多少列
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
