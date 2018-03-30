//
//  messageVC.m
//  青春秀秀
//
//  Created by luluwang on 2018/2/13.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "messageVC.h"
#import "UserInfoTableViewCell.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "ViewUtil.h"
//#import "ChatViewController.h"

@interface messageVC ()


@property (strong, nonatomic) NSMutableArray *userArray;
@end

@implementation messageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupRightBarButtonItem];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessagesVC)];
//    [self.newmessageview addGestureRecognizer:tapRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([BmobUser getCurrentUser]) {
        [self loadRecentConversations];
    }
}

//-(void)setupRightBarButtonItem{
//    UIButton *button = [ViewUtil buttonWithTitle:nil image:[UIImage imageNamed:@"contact_add"] highlightedImage:[UIImage imageNamed:@"contact_add_"]];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    [button addTarget:self action:@selector(toUserVC) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//}

-(void)toUserVC{
    [self performSegueWithIdentifier:@"toUserVC" sender:nil];
}

-(void)loadRecentConversations{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if (array && array.count > 0) {
        [self.userArray setArray:array];
        [self.tableView reloadData];
    }
}

//-(void)toMessagesVC{
//    [self performSegueWithIdentifier:@"newmessage" sender:nil];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserInfoCellID";
    
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    
    [cell setInfo:info];
    
    
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    
    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:info.userId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle =  info.name;
    [self performSegueWithIdentifier:@"toChatVC" sender:conversation];
    
}


@end
