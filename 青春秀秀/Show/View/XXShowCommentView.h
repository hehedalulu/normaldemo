//
//  XXShowCommentView.h
//  青春秀秀
//
//  Created by luluwang on 2018/1/14.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
#import "XXShowModel.h"
#import "UIView+SDAutoLayout.h"

@interface XXShowCommentView : UIView <MLLinkLabelDelegate>
@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;
@end
