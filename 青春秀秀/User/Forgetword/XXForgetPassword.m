//
//  XXForgetPassword.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXForgetPassword.h"

@interface XXForgetPassword (){
    NSTimer * xxforgetCountTimer;
    unsigned xxforgetResetsecondsCountDown;
}

@end

@implementation XXForgetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [self.view endEditing:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)xxforgetsendsms:(UIButton *)sender {
    [self SendSMSCode];
}

- (IBAction)xxforgetlogin:(UIButton *)sender {
}


#pragma  mark - 功能区域

-(void)SendSMSCode{
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_xxforgetNumber.text andTemplate:@"bmobmodel" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",number);
            //设置不可点击
            [self setRequestSmsCodeBtnCountDown];
        }
    }];
}


#pragma mark - 点击请求验证码之后button不能够点击 60s后进行点击的相关逻辑

//设置点击验证码后 60秒内不能够点击
-(void)setRequestSmsCodeBtnCountDown{
    [_xxforgetSMSbtn setEnabled:NO];
    //    _xxregistsmsbtn.backgroundColor = [UIColor grayColor];
    xxforgetResetsecondsCountDown = 60;
    
    xxforgetCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [xxforgetCountTimer fire];
}

//60秒之后 可以点击发送验证码
-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (xxforgetResetsecondsCountDown == 0) {
        [_xxforgetSMSbtn setEnabled:YES];
        //        SendSmsBtn.backgroundColor = [UIColor ];
        [_xxforgetSMSbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [xxforgetCountTimer invalidate];
    } else {
        [_xxforgetSMSbtn setTitle:[[NSNumber numberWithInt:xxforgetResetsecondsCountDown] description] forState:UIControlStateNormal];
        xxforgetResetsecondsCountDown--;
    }
}

-(void)verify{
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:_xxforgetNumber.text andSMSCode:_xxforgetSMS.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self login];
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)login{
    [BmobUser loginInbackgroundWithMobilePhoneNumber:_xxforgetSMS.text andSMSCode:_xxforgetSMS.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self performSegueWithIdentifier:@"homebarforget" sender:self];//跳转到tabbar页面
        }
    }];
    
}
@end
