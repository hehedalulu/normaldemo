//
//  AppDelegate.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/6.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
#import "BmobIMDemoPCH.h"
#import "XXHomeBarController.h"
#import "XXLogin.h"
#import "UserService.h"

@interface AppDelegate ()<BmobIMDelegate>
@property (strong, nonatomic) BmobIM *sharedIM;
@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *appKey = @"6ba9ad32cd474f43b377b569d6ede704";
    [Bmob registerWithAppKey:appKey];
    self.sharedIM = [BmobIM sharedBmobIM];
    [self.sharedIM registerWithAppKey:appKey];
    
    [self chooseRootViewController];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([self.sharedIM isConnected]) {
        [self.sharedIM disconnect];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (self.userId && self.userId.length > 0) {
        [self connectToServer];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)chooseRootViewController{
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
//        [self performSegueWithIdentifier:@"homebarlogin" sender:self];
        self.userId = bUser.objectId;
        [self connectToServer];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        XXHomeBarController *home = [story instantiateViewControllerWithIdentifier:@"homebar"];
        self.window.rootViewController = home;

    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin:) name:@"Login" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:@"Logout" object:nil];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *login = [story instantiateViewControllerWithIdentifier:@"loginNav"];
        self.window.rootViewController = login;
    }
    self.sharedIM.delegate = self;
    //注册推送，iOS 8的推送机制与iOS 7有所不同，这里需要分别设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc]init];
        //注意：此处的Bundle ID要与你申请证书时填写的一致。
        categorys.identifier=@"cn.bmob.BmobIMDemo";
        
        UIUserNotificationSettings *userNotifiSetting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys,nil]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:userNotifiSetting];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        //注册远程推送
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    BmobUser *user = [BmobUser currentUser];
    if (user) {
        [self connectToServer];
    }
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    BmobUser *user = [BmobUser currentUser];
    if (user) {
        NSString *string = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
        self.token = [[[string stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
        [self connectToServer];
    }
    
    //注册成功后上传Token至服务器
    BmobInstallation  *currentIntallation = [BmobInstallation installation];
    [currentIntallation setDeviceTokenFromData:deviceToken];
    [currentIntallation saveInBackground];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    NSLog(@"userInfo %@",userInfo);
}

-(void)userLogin:(NSNotification *)noti{
    NSString *userId = noti.object;
    self.userId = userId;
    [self connectToServer];
}

-(void)userLogout:(NSNotification *)noti{
    [self.sharedIM disconnect];
}

-(void)connectToServer{
    [self.sharedIM setupBelongId:self.userId];
    [self.sharedIM setupDeviceToken:self.token];
    [self.sharedIM connect];
}
#pragma mark - delegate

-(void)didRecieveMessage:(BmobIMMessage *)message withIM:(BmobIM *)im{
    
    BmobIMUserInfo *userInfo = [self.sharedIM userInfoWithUserId:message.fromId];
    if (!userInfo) {
        [UserService loadUserWithUserId:message.fromId completion:^(BmobIMUserInfo *result, NSError *error) {
            if (result) {
                [self.sharedIM saveUserInfo:result];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageFromer object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessagesNotifacation object:message];
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessagesNotifacation object:message];
    }
}


-(void)didGetOfflineMessagesWithIM:(BmobIM *)im{
    
    NSArray *objectIds = [self.sharedIM allConversationUsersIds];
    if (objectIds && objectIds.count > 0) {
        [UserService loadUsersWithUserIds:objectIds completion:^(NSArray *array, NSError *error) {
            if (array && array.count > 0) {
                [self.sharedIM saveUserInfos:array];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageFromer object:nil];
            }
        }];
    }
    
}



@end
