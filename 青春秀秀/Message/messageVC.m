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
#import "RecentTableViewCell.h"
#import "messageCell.h"
#import "InfoTableViewCell.h"
#import "ChatViewController.h"
#import "SystemMessageViewController.h"

@interface messageVC ()
@property (strong, nonatomic) IBOutlet UITableView *recenttableview;


@property (strong, nonatomic) NSMutableArray *userArray;
@end

@implementation messageVC
static NSString *RecentCellID = @"RecentCellID";
static NSString *msgCellID = @"msgCellID";
static NSString *newfriendCellID = @"newfriendCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    _userArray = [[NSMutableArray alloc] init];
    [_recenttableview registerNib:[UINib nibWithNibName:@"RecentTableViewCell" bundle:nil] forCellReuseIdentifier:RecentCellID];
    [_recenttableview registerNib:[UINib nibWithNibName:@"messageCell" bundle:nil] forCellReuseIdentifier:msgCellID];
    [_recenttableview registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:newfriendCellID];
    _recenttableview.backgroundColor = kDefaultViewBackgroundColor;
    _recenttableview.rowHeight = 75;
//    [self setupRightBarButtonItem];
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessagesVC)];
//    [self.newmessageview addGestureRecognizer:tapRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([BmobUser currentUser]) {
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
        [self.recenttableview reloadData];
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
    return self.userArray.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecentCellID];
    messageCell *cell2 = [tableView dequeueReusableCellWithIdentifier:msgCellID];
    InfoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:newfriendCellID];
    if(cell == nil) {
        if (indexPath.row == 0) {
            cell2 = [[messageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:msgCellID];
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            cell3 = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newfriendCellID];
            cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecentCellID];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell3.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        return cell2;
    }else if(indexPath.row == 1){
        return cell3;
    }else{
        BmobIMConversation *conversation = self.userArray[indexPath.row-2];
        [cell setEntity:conversation];
    }
    return cell;
    
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {

    }else if (indexPath.row == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SystemMessageViewController *sysmes = [storyboard instantiateViewControllerWithIdentifier:@"Sysmessage"];
        
        [self.navigationController pushViewController:sysmes animated:YES];
        
    }else{
//        BmobIMUserInfo *info = self.userArray[indexPath.row-1];
//        BmobIMConversation *conversation = [BmobIMConversation conversationWithId:info.userId conversationType:BmobIMConversationTypeSingle];
//        conversation.conversationTitle =  info.name;
//        BmobIMConversation *conversation = self.userArray[indexPath.row-1];
//        [self performSegueWithIdentifier:@"toChatVC" sender:conversation];
        BmobIMConversation *conversation = self.userArray[indexPath.row-2];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        cvc.conversation = conversation;
        [self.navigationController pushViewController:cvc animated:YES];
    }

}


@end
