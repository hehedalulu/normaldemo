//
//  XXRegist.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXRegist.h"

@interface XXRegist (){
    NSTimer * xxregistCountTimer;
    unsigned xxregistResetsecondsCountDown;
}

@end

@implementation XXRegist

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"regist";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [self.view endEditing:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)xxregistsendsms:(UIButton *)sender {
    [self SendSMSCode];
}

- (IBAction)xxRegistbtn:(UIButton *)sender {
    
    if (_xxregistNumber.text==nil||_xxregistName.text==nil||_xxregistPassword.text==nil||_xxregistsms==nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填满" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertController addAction:alert];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:_xxregistNumber.text andSMSCode:_xxregistsms.text resultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self verifySMS];
            }else{
                NSLog(@"%@",error);
            }
        }];
        
    }
}

-(void)verifySMS{
    BmobUser *bUser = [[BmobUser alloc] init];
    //    [bUser setObject:_xxregistNumber.text forKey:@"mobilePhoneNumber"];
    [bUser setMobilePhoneNumber:_xxregistNumber.text];
    [bUser setUsername:_xxregistName.text];
    [bUser setPassword:_xxregistPassword.text];
    [bUser setObject:_xxregistNumber.text forKey:@"nick"];

    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"成功注册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self performSegueWithIdentifier:@"homebarregist" sender:self];//跳转到tabbar页面
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:YES completion:nil];

        } else {
            NSLog(@"%@",error);
            UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert2  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertController2 addAction:alert2];//将确定加到警告框中
            [self presentViewController:alertController2 animated:YES completion:nil];

        }
    }];
}

#pragma  mark - 功能区域

- (void)extracted {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alertController addAction:alert];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)SendSMSCode{
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_xxregistNumber.text andTemplate:@"bmobmodel" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [self extracted];
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
    [_xxregistsmsbtn setEnabled:NO];
//    _xxregistsmsbtn.backgroundColor = [UIColor grayColor];
    xxregistResetsecondsCountDown = 60;
    
    xxregistCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES];
    [xxregistCountTimer fire];
}

//60秒之后 可以点击发送验证码
-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (xxregistResetsecondsCountDown == 0) {
        [_xxregistsmsbtn setEnabled:YES];
        //        SendSmsBtn.backgroundColor = [UIColor ];
        [_xxregistsmsbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [xxregistCountTimer invalidate];
    } else {
        [_xxregistsmsbtn setTitle:[[NSNumber numberWithInt:xxregistResetsecondsCountDown] description] forState:UIControlStateNormal];
        xxregistResetsecondsCountDown--;
    }
}

-(void)setPassword{
    BmobUser *buser = [[BmobUser alloc] init];
    buser.mobilePhoneNumber = _xxregistNumber.text;
    buser.password = _xxregistPassword.text;
    
    [buser signUpOrLoginInbackgroundWithSMSCode:_xxregistsms.text block:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {

        }
    }];
}
@end
