//
//  XXDemandDetailVC.m
//  青春秀秀
//
//  Created by luluwang on 2018/1/14.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXDemandDetailVC.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>



@interface XXDemandDetailVC ()

@end

@implementation XXDemandDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self setUI];

}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    UITabBarController * tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tabbar.tabBar.hidden =  YES;
//}

-(void)setUI{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;

    UITabBarController *tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    int tabBarHeight = tabBarController.tabBar.bounds.size.height;
    
    _XXDemandDetailUserBg.frame = CGRectMake(0,
                                            rectStatus.size.height+rectNav.size.height,
                                            [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/5);
    
    
    _XXDemandDetailAvatar.backgroundColor = [UIColor lightGrayColor];
    _XXDemandDetailAvatar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.05,
                                             rectStatus.size.height+rectNav.size.height+10,
                                             [UIScreen mainScreen].bounds.size.width/7, [UIScreen mainScreen].bounds.size.width/7);
    NSURL *imgurl = [NSURL URLWithString:_xxDemandDetailModel.xDemandsAvatarStr];
    [_XXDemandDetailAvatar sd_setBackgroundImageWithURL:imgurl forState:UIControlStateNormal];
    
    [_XXDemandDetailUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailAvatar).offset(5);
        make.left.equalTo(_XXDemandDetailAvatar).offset([UIScreen mainScreen].bounds.size.width/7+20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    _XXDemandDetailUserName.text = _xxDemandDetailModel.xDemandsName;
    
    [_XXDemandDetailTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailUserName).offset(30);
        make.left.equalTo(_XXDemandDetailUserName);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    _XXDemandDetailTime.text = _xxDemandDetailModel.xDemandsTime;
    
    [_XXDemandDetailDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailTime);
        make.left.equalTo(_XXDemandDetailTime).offset(70);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    [_XXDemandDetailClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-tabBarHeight);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
    }];
    
    [_XXDemandDetailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailUserBg.mas_bottom).offset(2);
        make.left.equalTo(self.view);
        make.bottom.equalTo(_XXDemandDetailClickBtn.mas_top);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 300));
    }];
    
    _XXDemandDetailTitle.textAlignment = NSTextAlignmentLeft;
    [_XXDemandDetailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailBgView).offset(10);
        make.left.equalTo(_XXDemandDetailAvatar);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width*4/5, 60));
    }];

    
    [_XXDemandDetailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_XXDemandDetailTitle.mas_bottom);
        make.left.equalTo(_XXDemandDetailAvatar);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width*4/5,  [UIScreen mainScreen].bounds.size.width*3/5));
    }];
    _XXDemandDetailContent.text = _xxDemandDetailModel.xDemandsContent;
    

    if ([_xxDemandDetailModel.xDemandState isEqualToString:@"0"]) {
        [_XXDemandDetailClickBtn setTitle:@"点击回应" forState:UIControlStateNormal];
    }else if([_xxDemandDetailModel.xDemandState isEqualToString:@"1"]){
        [_XXDemandDetailClickBtn setTitle:@"正在进行中" forState:UIControlStateNormal];
        [_XXDemandDetailClickBtn setBackgroundColor:[UIColor greenColor]];
        [_XXDemandDetailClickBtn setEnabled:NO];
    }else{
        [_XXDemandDetailClickBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [_XXDemandDetailClickBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_XXDemandDetailClickBtn setEnabled:NO];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)XXDemandDetailresponse:(UIButton *)sender {

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Demand"];
    [bquery getObjectInBackgroundWithId:_xxDemandDetailModel.xDemandID block:^(BmobObject *object,NSError *error){
        if (error){
            NSLog(@"Detail get DemandModelState error%@",error);
        }else{
            if (object) {
                [object setObject:@"1" forKey:@"DemandState"];
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        NSLog(@"Detail change DemandModelState error%@",error);
                    }else{
                        [_XXDemandDetailClickBtn setTitle:@"正在进行中" forState:UIControlStateNormal];
                        [_XXDemandDetailClickBtn setBackgroundColor:[UIColor greenColor]];}
                }];
            }
        }
    }];
}
@end
