//
//  XXDemandModel.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface XXDemandModel : NSObject
@property (strong) NSString *xDemandsName;
@property (strong) NSString *xDemandsAvatarStr;
@property (strong) NSString *xDemandsTitle;
@property (strong) NSString *xDemandsContent;
@property (strong) BmobUser *xDemandUser;
@property (strong) NSString *xDemandsTime;
//@property (assign) int xDemandsDistance;
@property (assign) int xDemandsTruth;

@property (strong) NSString *xDemandID;
@property (strong) NSString *xDemandState;





@end
