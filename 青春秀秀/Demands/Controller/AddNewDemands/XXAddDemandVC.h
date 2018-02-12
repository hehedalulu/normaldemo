//
//  XXAddDemandVC.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/27.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
@interface XXAddDemandVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *XXAddDemandsTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *XXPublishitem;
@property (weak, nonatomic) IBOutlet UITextView *XXAddDemandsContent;
- (IBAction)XXAddnewDemand:(UIBarButtonItem *)sender;

@end
