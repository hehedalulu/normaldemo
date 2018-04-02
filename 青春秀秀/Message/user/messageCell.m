//
//  messageCell.m
//  青春秀秀
//
//  Created by luluwang on 2018/3/31.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "messageCell.h"

@implementation messageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mesageav.layer setCornerRadius:6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
