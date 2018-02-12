//
//  XXForgetPassword.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

@interface XXForgetPassword : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *xxforgetNumber;
@property (weak, nonatomic) IBOutlet UITextField *xxforgetSMS;
@property (weak, nonatomic) IBOutlet UIButton *xxforgetSMSbtn;
- (IBAction)xxforgetsendsms:(UIButton *)sender;
- (IBAction)xxforgetlogin:(UIButton *)sender;

@end
