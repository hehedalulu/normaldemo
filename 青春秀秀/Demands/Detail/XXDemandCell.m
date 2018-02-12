//
//  XXDemandCell.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXDemandCell.h"
#import <SDWebImage/UIButton+WebCache.h>
@implementation XXDemandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.XXDemandAvatar.layer setCornerRadius:27];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setXxdemandModel:(XXDemandModel *)xxdemandModel{
    if (xxdemandModel.xDemandsAvatarStr) {
//        NSLog(@"xxdemandModel.xDemandsAvatarStr is %@",xxdemandModel.xDemandsAvatarStr);
        NSURL *imgurl = [NSURL URLWithString:xxdemandModel.xDemandsAvatarStr];
        [_XXDemandAvatar sd_setBackgroundImageWithURL:imgurl forState:UIControlStateNormal];
    }

    _XXDemandUser.text = xxdemandModel.xDemandsName;
    _XXDemandTitle.text = xxdemandModel.xDemandsTitle;
    _XXDemandTime.text =  xxdemandModel.xDemandsTime;
    _XXDemandTrust.text = [NSString stringWithFormat:@"%d",xxdemandModel.xDemandsTruth];
}


@end
