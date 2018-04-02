//
//  XXSettingTableViewController.m
//  青春秀秀
//
//  Created by luluwang on 2018/4/2.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXSettingTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "XXSelfPublishViewController.h"

@interface XXSettingTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *selfdetail;
@property (weak, nonatomic) IBOutlet UIImageView *selfdetailAvatar;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailNick;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailID;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailPhoneNumber;

@end

@implementation XXSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    BmobUser *bUser = [BmobUser currentUser];
    //头像
    if ([bUser objectForKey:@"avatar"]) {
        NSURL *imgurl = [NSURL URLWithString:[bUser objectForKey:@"avatar"]];
        UIImage *imagett = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
        [_selfdetailAvatar setImage:imagett];
        }else{
            _selfdetailAvatar.backgroundColor = [UIColor lightGrayColor];
        }
    //昵称
    if ([bUser objectForKey:@"nick"]) {
        _selfdetailNick.text = [bUser objectForKey:@"nick"];
    }else{
        _selfdetailNick.text = @"无名氏";
    }
    //ID
    _selfdetailID.text = bUser.objectId;
    _selfdetailPhoneNumber.text = bUser.mobilePhoneNumber;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中效果
    
    if (indexPath.section==0) {

    }else if(indexPath.section==0){
        
    }
//    if (indexPath.row==0&&indexPath.section==2) {
//        //                [self performSegueWithIdentifier:@"SelfInformation" sender:self];
//        //        XXSelfPublishViewController *publishVC = [[XXSelfPublishViewController alloc]init];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        XXSelfPublishViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"selfpublish"];
//        [self.navigationController pushViewController:cvc animated:YES];
//    }
}

-(void)changename{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"登录失败，再试试密码" preferredStyle:UIAlertControllerStyleAlert];
    //声明一个确定的按钮
    UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //                [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:alert];//将确定加到警告框中
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
