//
//  XXAddDemandVC.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/27.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXAddDemandVC.h"

@interface XXAddDemandVC ()

@end

@implementation XXAddDemandVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    _XXAddDemandsContent.place
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)XXAddnewDemand:(UIBarButtonItem *)sender {
    if (_XXAddDemandsTitle.text == nil||_XXAddDemandsContent.text == nil||_XXAddDemandsTitle.text == nil|| [_XXAddDemandsTitle.text isEqualToString: @"需求的标题～"]|| [_XXAddDemandsContent.text isEqualToString: @"需求的具体内容～"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertController addAction:alert];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self pushNewDemand];
    }
}
-(void)pushNewDemand{
    BmobObject *demand = [[BmobObject alloc] initWithClassName:@"Demand"];
    [demand setObject:_XXAddDemandsTitle.text forKey:@"title"];
    [demand setObject:_XXAddDemandsContent.text forKey:@"DemandContent"];
    BmobUser *bUser = [BmobUser currentUser];
    [demand setObject:bUser forKey:@"poster"];
    [demand setObject:bUser.username forKey:@"demandUserName"];
    [demand setObject:[bUser objectForKey:@"avatar"] forKey:@"demandAvatar"];
    [demand setObject:@"0" forKey:@"dType"];
    [demand setObject:@"0" forKey:@"DemandState"];
    [demand saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"----new post----");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.navigationController popViewControllerAnimated:YES];
                _XXPublishitem.enabled = NO;
            }];
            [alertController addAction:alert];
            [self presentViewController:alertController animated:NO completion:nil];
        }else{
            if (error) {
                NSLog(@"----post error,%@",error);
            }
        }
    }];
}

@end
