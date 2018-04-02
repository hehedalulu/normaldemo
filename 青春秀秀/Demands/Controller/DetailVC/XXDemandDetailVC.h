//
//  XXDemandDetailVC.h
//  青春秀秀
//
//  Created by luluwang on 2018/1/14.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXDemandModel.h"

@interface XXDemandDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollview;
@property (weak, nonatomic) IBOutlet UIView *XXDemandDetailUserBg;
@property (weak, nonatomic) IBOutlet UIView *XXDemandDetailBgView;
@property (weak, nonatomic) IBOutlet UIButton *XXDemandDetailAvatar;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandDetailUserName;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandDetailTime;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandDetailDistance;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandDetailTitle;
@property (weak, nonatomic) IBOutlet UITextView *XXDemandDetailContent;
@property (weak, nonatomic) IBOutlet UIButton *XXDemandDetailClickBtn;
- (IBAction)XXDemandDetailresponse:(UIButton *)sender;

@property (strong) XXDemandModel *xxDemandDetailModel;

@end
