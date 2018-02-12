//
//  XXFind.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXFind.h"
#import "linshiwebview.h"

@interface XXFind ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UIScrollView *xxfindscrollView;
@property (strong, nonatomic) UITableView *xxfindtableView;
@property (strong, nonatomic)  UIPageControl *xxfindpageControl;
@property (nonatomic,strong) NSTimer *xxfindtimer;
@end

@implementation XXFind
@synthesize xxfindscrollView;
@synthesize xxfindpageControl;
@synthesize xxfindtableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self findlistInit];
    [self initfindScrollView];
    [self initfindTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - 轮播图

-(void)initfindScrollView{
    xxfindscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height,
                                                                     [[UIScreen mainScreen] bounds].size.width,
                                                                     [[UIScreen mainScreen] bounds].size.height/3)];
    [self.view insertSubview:xxfindscrollView atIndex:1 ];
    
    [xxfindscrollView setBackgroundColor:[UIColor blackColor]];
    [xxfindscrollView setCanCancelContentTouches:NO];
    xxfindscrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    xxfindscrollView.clipsToBounds  = YES;    //生成五个动态的imgeview
    int count = 5;
    //    CGSize size = self.scrollView.frame.size;
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/3);
    
    for (int i = 0; i<count; i++) {
        UIImageView *iconView = [[UIImageView alloc]init];
        [xxfindscrollView insertSubview:iconView atIndex:0];
        
        NSString  *imgName = [NSString stringWithFormat:@"IMG_%02d",i+1];
        iconView.image = [UIImage imageNamed:imgName];
        
        CGFloat x = i*size.width;
        iconView.frame = CGRectMake(x, 0, size.width, size.height);
        
    }
    xxfindpageControl = [[UIPageControl alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen] bounds].size.height/5, [[UIScreen mainScreen]bounds].size.width, 20)];
    [xxfindpageControl setBackgroundColor:[UIColor blackColor]];
//    [self.view insertSubview:xxfindpageControl atIndex:2];
    
    xxfindscrollView.contentSize = CGSizeMake(count *size.width , 0);
    xxfindscrollView.showsHorizontalScrollIndicator = NO;
    xxfindscrollView.pagingEnabled = YES;
    xxfindpageControl.numberOfPages = count;
    xxfindscrollView.delegate = self;
    //定时器
    [self addTimer0];
    xxfindscrollView.pagingEnabled  = YES;
    xxfindscrollView.scrollEnabled  = YES;
    xxfindscrollView.delegate       = self;
    xxfindscrollView.tag            = 1;
    xxfindscrollView.showsHorizontalScrollIndicator   = NO;
    
}

#pragma mark - scrollView Delegate
- (void)addTimer0{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    _xxfindtimer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void) nextImage{
    NSInteger page = xxfindpageControl.currentPage;
    if (page == xxfindpageControl.numberOfPages - 1) {
        page = 0;
    }
    else{
        page++;
    }
    CGFloat offsetX = page  * xxfindscrollView.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        xxfindscrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = xxfindscrollView.contentOffset.x /xxfindscrollView.frame.size.width;
    xxfindpageControl.currentPage = page;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_xxfindtimer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer0];
}

-(void)findlistInit{
    list = [[NSMutableArray alloc]init];
    [list addObject:@"校园风光"];
//    [list addObject:@"通讯录"];
//    [list addObject:@"圈子"];
//    [list addObject:@"群组"];
//    [list addObject:@"附近的人"];
//    [list addObject:@"扫一扫"];
}
-(void)initfindTableView{
    xxfindtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height/3+self.navigationController.navigationBar.bounds.size.height,
                                                                    [[UIScreen mainScreen] bounds].size.width,
                                                                    [[UIScreen mainScreen] bounds].size.height*2/3-self.navigationController.navigationBar.bounds.size.height)];
    xxfindtableView.delegate = self;
    xxfindtableView.dataSource = self;
    [self.view addSubview:xxfindtableView];
}
#pragma mark - TableView

//返回有多少个区块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [list count];
}
//返回每个区块有多少行
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{}

////实现表头信息
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:32];
    //细节显示
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //删除多余的分割线
    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    linshiwebview *lin = [[linshiwebview alloc]init];
    [self.navigationController pushViewController:lin animated:YES];
//    if (indexPath.row == 1) {
//[self performSegueWithIdentifier:@"contactView" sender:self];
        
//    }
    // 取消选中效果
}


@end
