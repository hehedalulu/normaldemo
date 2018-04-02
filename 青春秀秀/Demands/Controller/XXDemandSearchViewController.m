//
//  XXDemandSearchViewController.m
//  青春秀秀
//
//  Created by luluwang on 2018/4/2.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXDemandSearchViewController.h"
#import "XXDemandCell.h"
#import "XXDemandModel.h"
#import "XXDemandDetailVC.h"
#import "MBProgressHUD.h"
#import "UIViewController+DKHUD.h"

@interface XXDemandSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>{
    MBProgressHUD *searchhud;
}

@property (nonatomic, strong) UITableView *SeatableView;

@property (nonatomic, strong) UISearchController * SeaController;
@property (strong,nonatomic) NSMutableArray  *searchList;

@end

@implementation XXDemandSearchViewController
static NSString *SearchCellID = @"SearchCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.title = @"查找需求";
    _SeatableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,
                                                                  [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain];
    _SeatableView.backgroundColor = [UIColor whiteColor];
    _SeatableView.delegate = self;
    _SeatableView.dataSource = self;
    [self.SeatableView registerNib:[UINib nibWithNibName:@"XXDemandCell" bundle:nil] forCellReuseIdentifier:SearchCellID];
    [self.view addSubview:_SeatableView];
    
    
    //UISearchController
    _SeaController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _SeaController.searchResultsUpdater = self;
    _SeaController.delegate = self;
    _SeaController.dimsBackgroundDuringPresentation = NO;
    _SeaController.hidesNavigationBarDuringPresentation = NO;
    
    _SeaController.searchBar.placeholder = @"输入你想查找的内容";
    _SeaController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    //_searchController.searchBar.prompt = @"prompt"; //提示语
    _SeaController.searchBar.showsCancelButton = YES;
    //_searchController.searchBar.showsBookmarkButton = YES;
    //_searchController.searchBar.showsSearchResultsButton = YES;
    
    //ScopeBar
    //_searchController.searchBar.showsScopeBar = YES;
    //_searchController.searchBar.scopeButtonTitles = @[@"BookmarkButton" ,@"ScopeButton",@"ResultsListButton",@"CancelButton",@"SearchButton"];
    
    _SeaController.searchBar.delegate = self;
    _SeaController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    _SeatableView.tableHeaderView = _SeaController.searchBar;
    
    //解决：退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    
}


// FIXME: ---------
#pragma mark UISearchResultsUpdating
// 每次更新搜索框里的文字，就会调用这个方法
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
// 根据输入的关键词及时响应：里面可以实现筛选逻辑  也显示可以联想词
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSLog(@"%s",__func__);
}


#pragma mark UISearchBarDelegate



// called when keyboard search button pressed 键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    NSString *searchString = searchBar.text;
    if (searchString.length > 0) {
        //清除搜索结果
        [_searchList removeAllObjects];
    }
    //显示搜索结果
    [self searchNew:searchBar.text];
    [_SeaController.searchBar resignFirstResponder];
    [self showHUD:@"正在查询"];
}



// MARK: 懒加载


- (NSMutableArray *) searchList {
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXDemandCell *cell=[tableView dequeueReusableCellWithIdentifier:SearchCellID];
    if (cell==nil) {
        cell=[[XXDemandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchCellID];
    }
    //    [cell.textLabel setText:self.results[indexPath.row]];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.xxdemandModel = self.searchList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XXDemandDetailVC *detailVC = [story instantiateViewControllerWithIdentifier:@"Demanddetail"];
    detailVC.xxDemandDetailModel = [self.searchList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)searchNew:(NSString *)key{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        [self.results removeAllObjects];
        self.searchList = [NSMutableArray array];
        BmobQuery *query = [BmobQuery queryWithClassName:@"Demand"];
        [query orderByDescending:@"updatedAt"];
        [query whereKey:@"title" equalTo:key];
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
                    [self.searchList addObject:model];
                }
                
                [self.SeatableView reloadData];
                [self hideHUD];
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

@end
