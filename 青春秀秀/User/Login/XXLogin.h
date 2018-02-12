//
//  XXLogin.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
@interface XXLogin : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *xxloginNumber;
@property (weak, nonatomic) IBOutlet UITextField *xxloginPassword;

- (IBAction)xxLoginbtn:(UIButton *)sender;

@end
