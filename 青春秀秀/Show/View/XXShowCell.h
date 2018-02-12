//
//  XXShowCell.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXShowPicView.h"
#import "XXShowModel.h"

#import "UIView+SDAutoLayout.h"

@protocol XXShowCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

@end

@class  XXShowModel;

@interface XXShowCell : UITableViewCell

@property (nonatomic, weak) id<XXShowCellDelegate> delegate;

@property (nonatomic,strong) XXShowModel *xxshowmodel;
@property (nonatomic, strong) NSIndexPath *xxshowindexPath;
@property (nonatomic, strong)UIButton *XXShowlikeIt;    //点赞
@property (nonatomic, strong)UIButton *XXShowcommentIt;    //评论
//@property (nonatomic, copy) NSString *showtext;

@end
