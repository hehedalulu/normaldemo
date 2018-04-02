//
//  XXSelfPageTableViewController.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXSelfPageTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "XXSelfPublishViewController.h"

@interface XXSelfPageTableViewController (){
    UILabel *XselfPhoneNumber;
    UILabel *XselfSex;
    UILabel *XselfID;
}

@end

@implementation XXSelfPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initlist];
}

-(void)initlist{
    List1 = [[NSMutableArray alloc]init];
    [List1 addObject:@"手机号"];
    [List1 addObject:@"性别"];
    [List1 addObject:@"ID"];
    
//    List2 = [[NSMutableArray alloc]init];
//    [List2 addObject:@"学校"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
    }
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *header;
    switch (section) {
        case 1:
            header = @"个人信息设置";
            break;
        case 2:
            header = @"我的订单";
            break;
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
//    if (cell == nil ) {
    BmobUser *bUser = [BmobUser currentUser];
        if (indexPath.section==0) {
            _SelfIcon = [[UIButton alloc]init];
            [_SelfIcon.layer setMasksToBounds:YES];
            [_SelfIcon.layer setCornerRadius:10];
            [_SelfIcon setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/20,
                                           [UIScreen mainScreen].bounds.size.width/40,
                                           [UIScreen mainScreen].bounds.size.width/6,
                                           [UIScreen mainScreen].bounds.size.width/6)];
            if ([bUser objectForKey:@"avatar"]) {
                NSURL *imgurl = [NSURL URLWithString:[bUser objectForKey:@"avatar"]];
                UIImage *imagett = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
                [_SelfIcon setBackgroundImage:imagett forState:UIControlStateNormal];
            }else{
                _SelfIcon.backgroundColor = [UIColor lightGrayColor];
            }
            [cell addSubview:_SelfIcon];
            
            UILabel *SelfName = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                         [UIScreen mainScreen].bounds.size.width/4,
                                                                         [UIScreen mainScreen].bounds.size.width/40,
                                                                         [UIScreen mainScreen].bounds.size.width/3,
                                                                         [UIScreen mainScreen].bounds.size.width/10)];
             SelfName.font = [UIFont systemFontOfSize:22];
            if ([bUser objectForKey:@"nick"]) {
               SelfName.text = [bUser objectForKey:@"nick"];
            }else{
                SelfName.text = @"无名氏";
            }
            [cell addSubview:SelfName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section==1) {
            cell.textLabel.text =[List1 objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            XselfPhoneNumber = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/5,
                                                                        10, 130, 40)];
            if (indexPath.row == 0) {
                XselfPhoneNumber.text = bUser.mobilePhoneNumber;
            }else if (indexPath.row == 1){
                if ([bUser objectForKey:@"Sex"]) {
                    XselfPhoneNumber.text = [bUser objectForKey:@"Sex"];
                }else{
                    XselfPhoneNumber.text = @"未知";
                }
            }else if(indexPath.row == 2){
                XselfPhoneNumber.text = bUser.objectId;
            }
            [cell addSubview:XselfPhoneNumber];
        }
        if (indexPath.section==2) {
            XselfPhoneNumber = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/5,
                                                                        10, 130, 40)];
            if (indexPath.row == 0) {
//                cell.textLabel.text =[List2 objectAtIndex:indexPath.row];
                cell.textLabel.text = @"我发布的订单";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
//                XselfPhoneNumber.text = @"北京大学";
//                [cell addSubview:XselfPhoneNumber];
            }
            if (indexPath.row==1) {
                UIButton *backregist = [[UIButton alloc]initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/10, 10,
                                                                                  [UIScreen mainScreen].bounds.size.width*8/10, 40)];
                backregist.backgroundColor = [UIColor orangeColor];
                [backregist setTitle:@"退出当前用户" forState:UIControlStateNormal];
                [backregist setTintColor:[UIColor whiteColor]];
                [backregist addTarget:self action:@selector(backtoregist) forControlEvents:UIControlEventTouchUpInside];
                cell.userInteractionEnabled = YES;
                [cell addSubview:backregist];
            }
        }
        
//        if (!(indexPath.section==2&&(indexPath.row==1|indexPath.row==2))) {
//            UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width*4/5, 15, [[UIScreen mainScreen] bounds].size.width,60)];
//            [cell addSubview:myswitch];
//        }
    
//    if (indexPath.section==2&&indexPath.row==1) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
//    }
//    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    return cell;
}

-(void)backtoregist{
    [BmobUser logout];
    [self performSegueWithIdentifier:@"backtologin" sender:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中效果
    
    if (indexPath.row==0&&indexPath.section==0) {
        [self performSegueWithIdentifier:@"selfdetail" sender:self];
    }
    if (indexPath.row==0&&indexPath.section==2) {
//                [self performSegueWithIdentifier:@"SelfInformation" sender:self];
//        XXSelfPublishViewController *publishVC = [[XXSelfPublishViewController alloc]init];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XXSelfPublishViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"selfpublish"];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
@end
