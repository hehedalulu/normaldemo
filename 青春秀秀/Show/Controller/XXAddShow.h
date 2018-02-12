//
//  XXAddShow.h
//  青春秀秀
//
//  Created by luluwang on 2018/1/13.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

@interface XXAddShow : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *XXAddShowContent;
- (IBAction)XXAddNewShoe:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *xxshowbtn;

@end


