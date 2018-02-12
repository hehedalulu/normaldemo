//
//  XXDemandCell.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXDemandModel.h"
@interface XXDemandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *XXDemandAvatar;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandUser;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandTitle;
//@property (weak, nonatomic) IBOutlet UILabel *XXDemandDistance;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandTime;
@property (weak, nonatomic) IBOutlet UILabel *XXDemandTrust;

@property(nonatomic,strong) XXDemandModel *xxdemandModel;



@end
