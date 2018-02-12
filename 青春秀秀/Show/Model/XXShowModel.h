//
//  XXShowModel.h
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XXShowLikeItemModel, XXShowCommentItemModel;

@interface XXShowModel : NSObject
//用户名串
@property (nonatomic,copy) NSString *usernameLB;
@property (nonatomic) NSString *xxshowmodelAvatarStr;
//内容串
@property (nonatomic) NSString *contentText;
//发送时间串
@property NSString *xxshowmodeltime;

@property (nonatomic,copy) NSString *showOjectId;
//位置串
@property (nonatomic,copy) NSString *distanceString;
//图片数组
@property (nonatomic,copy) NSArray  *picNamesArray;

@property (nonatomic,copy) NSArray *likeArray;
@property (nonatomic,copy) NSArray *commentArray;

@property (assign) BOOL iLikeit;


@end


@interface XXShowLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface XXShowCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
