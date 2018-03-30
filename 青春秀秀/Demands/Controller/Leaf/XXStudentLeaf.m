//
//  XXStudentLeaf.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXStudentLeaf.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XXDemandCell.h"
#import "XXDemandModel.h"
#import "XXDemandDetailVC.h"

@interface XXStudentLeaf ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *Stutableview;
    NSMutableArray *StudentModelList;
    NSMutableArray *CompanyList;
    NSMutableArray *TrainList;
    NSInteger currentIndex;
}

@end

@implementation XXStudentLeaf

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - lifecycle
- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    [super viewDidLoad];
    currentIndex = index;
    [self initStudentModelList];
    [self initTable];
}

-(void)zj_viewWillAppearForIndex:(NSInteger)index{
    NSLog(@"viewWillAppear------%ld", index);
    currentIndex = index;
    if (StudentModelList !=nil) {
        [Stutableview.mj_header beginRefreshing];
    }
}

-(void)zj_viewDidDisappearForIndex:(NSInteger)index{
     [Stutableview.mj_header endRefreshing];
}
#pragma mark - TableView初始化

-(void)initTable{
    if (Stutableview == nil) {
        Stutableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     [[UIScreen mainScreen] bounds].size.width,
                                                                     [[UIScreen mainScreen] bounds].size.height-self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
        [Stutableview setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        Stutableview.showsVerticalScrollIndicator = NO;
        Stutableview.dataSource                   = self;
        Stutableview.delegate                     = self;
//        Stutableview.separatorStyle               = UITableViewCellSeparatorStyleNone;
        [Stutableview registerNib:[UINib nibWithNibName:@"XXDemandCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        NSLog(@"初始化Demands Students ViewController");
        [self setupRefresh:Stutableview];
        [self.view addSubview:Stutableview];
    }
}

-(void)initStudentModelList{
    if (!StudentModelList) {
        NSLog(@"初始化StudentList");
        StudentModelList = [NSMutableArray array];
        CompanyList = [NSMutableArray array];
        TrainList = [NSMutableArray array];
    }
}

#pragma mark 3个tableView的各项设置
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (currentIndex == 0) {
        return StudentModelList.count;
    }else if (currentIndex == 1){
        return CompanyList.count;
    }else if(currentIndex == 2){
        return TrainList.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
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
    if (currentIndex == 0) {
        if (StudentModelList.count>0) {
            cell.xxdemandModel = [StudentModelList objectAtIndex:indexPath.row];
        }
    }else if (currentIndex == 1){
        if (CompanyList.count>0) {
            cell.xxdemandModel = [CompanyList objectAtIndex:indexPath.row];
        }
    }else if (currentIndex == 2){
        if (TrainList.count>0) {
            cell.xxdemandModel = [TrainList objectAtIndex:indexPath.row];
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XXDemandDetailVC *detailVC = [story instantiateViewControllerWithIdentifier:@"Demanddetail"];
    if (currentIndex == 0) {
        detailVC.xxDemandDetailModel = [StudentModelList objectAtIndex:indexPath.row];
    }else if (currentIndex == 1){
        detailVC.xxDemandDetailModel = [CompanyList objectAtIndex:indexPath.row];
    }else if (currentIndex == 2){
        detailVC.xxDemandDetailModel = [TrainList objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 上下拉刷新
-(void)setupRefresh:(UITableView*)tableView{
    __unsafe_unretained __typeof(self) weakSelf = self;
    Stutableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewLeft];
    }];
    [Stutableview.mj_header beginRefreshing];
    Stutableview.mj_header.automaticallyChangeAlpha = YES;
    Stutableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreLeft];
    }];
}

-(void)loadNewLeft{
    if (Stutableview.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (currentIndex == 0) {
            [StudentModelList removeAllObjects];
        }else if (currentIndex == 1){
            [CompanyList removeAllObjects];
        }else if (currentIndex == 2){
            [TrainList removeAllObjects];
        }
    BmobQuery *query = [BmobQuery queryWithClassName:@"Demand"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"dType" equalTo:[NSString stringWithFormat:@"%d",(int)currentIndex]];
    query.limit = 15;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"-----xxDemandModel error:%@",error);
        }else{
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                    if (currentIndex == 0) {
                        [StudentModelList addObject:model];
                    }else if (currentIndex == 1){
                        [CompanyList addObject:model];
                    }else if (currentIndex == 2){
                        [TrainList addObject:model];
                    }
                }
//            });
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [Stutableview.mj_header endRefreshing];
                [Stutableview reloadData];
                Stutableview.mj_footer.state = MJRefreshStateIdle;
//            });
        }
     }];
     });
}
     
-(void)loadMoreLeft{
    if (Stutableview.mj_footer.state ==MJRefreshStateNoMoreData||Stutableview.mj_header.state == MJRefreshStateRefreshing) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Demand"];
    [query orderByDescending:@"updatedAt"];
    
    if (currentIndex == 0) {
        query.skip = StudentModelList.count;
    }else if (currentIndex == 1){
         query.skip = CompanyList.count;
    }else if (currentIndex == 2){
         query.skip = TrainList.count;
    }
    [query whereKey:@"dType" equalTo:[NSString stringWithFormat:@"%d",(int)currentIndex]];
    query.limit = 15;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"-----xxDemandModel error:%@",error);
        }else{
            if(array.count == 0){
                NSLog(@"加载完毕");
                Stutableview.mj_footer.state = MJRefreshStateNoMoreData;
                [Stutableview.mj_footer endRefreshingWithNoMoreData];
            }else{
                NSLog(@"加载ing,%@",array);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDate *now = [NSDate date];
                    for (BmobObject *obj in array) {
                        XXDemandModel *model = [[XXDemandModel alloc]init];
                        NSString *titleStr = [obj objectForKey:@"title"];
                        model.xDemandsTitle = titleStr;
                        NSString *name = [obj objectForKey:@"demandUserName"];
                        model.xDemandsName = name;
                        model.xDemandsContent = [obj objectForKey:@"DemandContent"];
                        model.xDemandsAvatarStr    = [obj objectForKey:@"demandAvatar"];
                         model.xDemandsTime     = [self calTime:obj.createdAt WithNow:now];;
                        model.xDemandsTruth  = 100;
                        model.xDemandState = [obj objectForKey:@"DemandState"];
                        BmobUser *user = [obj objectForKey:@"poster"];
                        model.xDemandUser = user;
                        if (currentIndex == 0) {
                            [StudentModelList insertObject:model atIndex:StudentModelList.count];
                        }else if (currentIndex == 1){
                            [CompanyList insertObject:model atIndex:CompanyList.count];
                        }else if (currentIndex == 2){
                            [TrainList insertObject:model atIndex:TrainList.count];
                        }
                    }
                });
                    [Stutableview.mj_footer endRefreshing];
                    [Stutableview reloadData];
            }
            }
    }];
    });
}


//over 60 min
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
@end
