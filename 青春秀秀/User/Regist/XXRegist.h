//
//  XXRegist.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
@interface XXRegist : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *xxregistNumber;
@property (weak, nonatomic) IBOutlet UITextField *xxregistName;
@property (weak, nonatomic) IBOutlet UITextField *xxregistPassword;
@property (weak, nonatomic) IBOutlet UITextField *xxregistsms;
@property (weak, nonatomic) IBOutlet UIButton *xxregistsmsbtn;
- (IBAction)xxregistsendsms:(UIButton *)sender;
- (IBAction)xxRegistbtn:(UIButton *)sender;

@end
