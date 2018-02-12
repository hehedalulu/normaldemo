//
//  XXLogin.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXLogin.h"

@interface XXLogin ()

@end

@implementation XXLogin

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//代码实现轻触背景关闭键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [self.view endEditing:YES];
    }
}
//换行关闭
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)xxLoginbtn:(UIButton *)sender {
    [BmobUser loginInbackgroundWithAccount:_xxloginNumber.text andPassword:_xxloginPassword.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"%@",user);
            [self performSegueWithIdentifier:@"homebarlogin" sender:self];
        } else {
            NSLog(@"%@",error);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"登录失败，再试试密码" preferredStyle:UIAlertControllerStyleAlert];
            //声明一个确定的按钮
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alert];//将确定加到警告框中
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}



@end
