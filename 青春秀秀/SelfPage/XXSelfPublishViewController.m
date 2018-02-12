//
//  XXSelfPublishViewController.m
//  青春秀秀
//
//  Created by luluwang on 2018/2/11.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXSelfPublishViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XXDemandCell.h"
#import "XXDemandModel.h"
#import "XXDemandDetailVC.h"
@interface XXSelfPublishViewController (){
    NSMutableArray *mypublishArray;
}

@end

@implementation XXSelfPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"XXDemandCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initMyPublishlist];
    [self loadNewList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initMyPublishlist{
    if (!mypublishArray) {
        mypublishArray = [NSMutableArray array];
    }
}
-(void)loadNewList{
    [mypublishArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BmobUser *buser = [BmobUser currentUser];
        BmobQuery *query = [BmobQuery queryWithClassName:@"Demand"];
        [query orderByDescending:@"updatedAt"];
        [query whereKey:@"dType" equalTo:@"0"];
        [query whereKey:@"poster" containedIn:@[buser.objectId]];
        query.limit = 15;
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"-----xxDemandModel error:%@",error);
            }else{
                NSDate *now = [NSDate date];
                for (BmobObject *obj in array) {
                    XXDemandModel *model = [[XXDemandModel alloc]init];
                    NSString *titleStr = [obj objectForKey:@"title"];
                    model.xDemandsTitle = titleStr;
                    NSString *name = [obj objectForKey:@"demandUserName"];
                    model.xDemandsName = name;
                    model.xDemandsContent = [obj objectForKey:@"DemandContent"];
                    model.xDemandState = [obj objectForKey:@"DemandState"];
                    model.xDemandsAvatarStr    = [obj objectForKey:@"demandAvatar"];
                    NSLog(@"time%@",[self calTime:obj.createdAt WithNow:now]);
                    NSString *demandTime = [self calTime:obj.createdAt WithNow:now];
                    model.xDemandsTime     = demandTime;
                    model.xDemandsTruth  = 90;
                    model.xDemandID = obj.objectId;
                    BmobUser *user = [obj objectForKey:@"poster"];
                    model.xDemandUser = user;
                    [mypublishArray addObject:model];
                }
                [self.tableView reloadData];
            }
        }];
    });
}

-(NSString *)calTime:(NSDate *)creatTime WithNow:(NSDate*)now{
    NSTimeInterval time = ([now timeIntervalSinceDate:creatTime]);
    NSString *resultStr;
    if(time > 86400){
        int result = (int)(time/86400);
        resultStr = [NSString stringWithFormat:@"%d天前",result];
    }else if (time <= 86400 & time > 3600) {
        int result = (int)(time/3600);
        resultStr = [NSString stringWithFormat:@"%d小时前",result];
    }else if(time <= 3600 & time >= 60){
        int result = (int)(time/60);
        resultStr = [NSString stringWithFormat:@"%d分钟前",result];
    }else{
        resultStr = @"现在";
    }
    NSLog(@"interval,%@",resultStr);
    return resultStr;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"sss%ld",mypublishArray.count);
    return mypublishArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    XXDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[XXDemandCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (mypublishArray.count>0) {
            cell.xxdemandModel = [mypublishArray objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XXDemandDetailVC *detailVC = [story instantiateViewControllerWithIdentifier:@"Demanddetail"];
    detailVC.xxDemandDetailModel = [mypublishArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
