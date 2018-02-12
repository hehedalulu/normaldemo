//
//  XXShowCell.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXShowCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "XXShowCommentView.h"
#import "XXShowCommentView.h"

CGFloat maxContentLabelHeight = 0;
@implementation XXShowCell{
    UIButton *XXShowAvatarBtn;    //头像
    UILabel *XXShowNameLB;    //用户名
    UILabel *XXShowdistanceLB;    //距离
    UILabel *XXShowtimeLB;    //时间
    UILabel *XXShowcontentLB;    //内容
    XXShowPicView *XXShowcontenImageView;    //图片
    XXShowCommentView *_commentView;

}
@synthesize XXShowlikeIt;
@synthesize XXShowcommentIt;


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {\
        [self setupMain];
    }
    
    return self;
}

-(void)setupMain{
    //头像
//    xxshowmodel
    XXShowAvatarBtn = [[UIButton alloc]init];
    [XXShowAvatarBtn setBackgroundColor:[UIColor orangeColor]];
    [XXShowAvatarBtn.layer setCornerRadius:20];
    [self.contentView addSubview:XXShowAvatarBtn];
    XXShowAvatarBtn.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(40)
    .widthIs(40);
    
    //用户名
    XXShowNameLB = [[UILabel alloc]init];
    XXShowNameLB.textColor = [UIColor redColor];
    XXShowNameLB.font = [UIFont systemFontOfSize:20];
    XXShowNameLB.text = @"text";
    [self.contentView addSubview:XXShowNameLB];
    XXShowNameLB.sd_layout
    .leftSpaceToView(XXShowAvatarBtn,20)
    .topEqualToView(XXShowAvatarBtn)
    .heightIs(20)
    .widthIs(100);
   
    
    //秀秀发送时间
    XXShowtimeLB = [[UILabel alloc]init];
    XXShowtimeLB.textColor =[UIColor grayColor];
    XXShowtimeLB.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:XXShowtimeLB];
    XXShowtimeLB.sd_layout
    .rightEqualToView(self.contentView)
    .topEqualToView(XXShowNameLB)
    .widthIs(60)
    .heightIs(20);
    
    //地点
    XXShowdistanceLB = [[UILabel alloc]init];
    XXShowdistanceLB.textColor = [UIColor grayColor];
    XXShowdistanceLB.font = [UIFont systemFontOfSize:13];
    XXShowdistanceLB.text = @"distance";
    [self.contentView addSubview:XXShowdistanceLB];
    XXShowdistanceLB.sd_layout
    .leftEqualToView(XXShowNameLB)
    .topSpaceToView(XXShowNameLB,0)
    .widthIs(200);
    
    //内容
    XXShowcontentLB = [[UILabel alloc]init];
    XXShowcontentLB.font = [UIFont systemFontOfSize:15];
    XXShowcontentLB.numberOfLines = 0;
//    if (maxContentLabelHeight == 0) {
//        maxContentLabelHeight = XXShowcontentLB.font.lineHeight * 3;
//    }
    [self.contentView addSubview:XXShowcontentLB];
    XXShowcontentLB.sd_layout
    .leftEqualToView(XXShowNameLB)
    .topSpaceToView(XXShowdistanceLB,0)
    .rightSpaceToView(self.contentView,30)
    .autoHeightRatio(0);
    
    
//    图片
    XXShowcontenImageView = [[XXShowPicView alloc]init];
//    XXShowcontenImageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:XXShowcontenImageView];
    XXShowcontenImageView.sd_layout
    .leftEqualToView(XXShowNameLB)
    .topSpaceToView(XXShowcontentLB,10);
    
    //点赞
    XXShowlikeIt = [[UIButton alloc]init];
    [XXShowlikeIt setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.contentView addSubview:XXShowlikeIt];
    XXShowlikeIt.sd_layout
    .leftEqualToView(XXShowcontenImageView)
    .topSpaceToView(XXShowcontenImageView,8)
    .widthRatioToView(XXShowAvatarBtn,0.57)
    .heightRatioToView(XXShowAvatarBtn,0.47);
     [XXShowlikeIt addTarget:self action:@selector(clicklike) forControlEvents:UIControlEventTouchUpInside];
    
    //评论
    XXShowcommentIt = [[UIButton alloc]init];
    [XXShowcommentIt setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.contentView addSubview:XXShowcommentIt];
    XXShowcommentIt.sd_layout
    .leftSpaceToView(XXShowlikeIt,20)
    .topEqualToView(XXShowlikeIt)
    .widthRatioToView(XXShowAvatarBtn,0.57)
    .heightRatioToView(XXShowAvatarBtn,0.47);
    [XXShowcommentIt addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    _commentView = [[XXShowCommentView alloc]init];
    [self.contentView addSubview:_commentView];
    _commentView.sd_layout
    .leftEqualToView(XXShowNameLB)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(XXShowcommentIt, 0); // 已经在内部实现高度自适应所以不需要再设置高度
    
    [self setupAutoHeightWithBottomView:XXShowlikeIt bottomMargin:10];
}



-(void)setXxshowmodel:(XXShowModel *)xxshowmodel{
    _xxshowmodel = xxshowmodel;
    
    [_commentView setupWithLikeItemsArray:xxshowmodel.likeArray commentItemsArray:xxshowmodel.commentArray];
    
    XXShowNameLB.text = xxshowmodel.usernameLB;
    XXShowcontentLB.text  = xxshowmodel.contentText;
    XXShowdistanceLB.text = @"不知名地点";
    NSURL *imgurl = [NSURL URLWithString:xxshowmodel.xxshowmodelAvatarStr];
    [XXShowAvatarBtn sd_setBackgroundImageWithURL:imgurl forState:UIControlStateNormal];
    
    XXShowtimeLB.text     = xxshowmodel.xxshowmodeltime;
//    XXShowdistanceLB.text = xxshowmodel.distanceString;
    XXShowcontenImageView.picPathStringsArray = xxshowmodel.picNamesArray;
    
    if (xxshowmodel.iLikeit) {
        [XXShowlikeIt setEnabled:NO];
        [XXShowlikeIt setBackgroundImage:[UIImage imageNamed:@"like_select"] forState:UIControlStateNormal];
    }else{
        [XXShowlikeIt setEnabled:YES];
        [XXShowlikeIt setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    UIView *bottomView;
    if (!xxshowmodel.likeArray.count && !xxshowmodel.commentArray.count) {
        bottomView = XXShowlikeIt;
    } else {
        bottomView = _commentView;
    }
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    XXShowNameLB.text = nil;
    XXShowcontentLB.text  = nil;
    XXShowtimeLB.text     = nil;
    XXShowdistanceLB.text = nil;
    XXShowcontenImageView.picPathStringsArray = nil;
}


-(void)clicklike{
    if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
        [self.delegate didClickLikeButtonInCell:self];
        
        NSLog(@"传送喜欢");
    }
}
-(void)clickComment{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
        [self.delegate didClickcCommentButtonInCell:self];
        NSLog(@"传送评论");
    }
}

@end
