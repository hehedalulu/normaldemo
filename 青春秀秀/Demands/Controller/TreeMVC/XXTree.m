//
//  XXTree.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/17.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXTree.h"
#import "XXStudentLeaf.h"
#import "XXDemandDetailVC.h"
#import "XXDemandSearchViewController.h"

@interface XXTree (){
    NSArray *titles;
    UIButton *treeAddBtn;
    UIButton *searchBtn;
}
@property (strong,nonatomic) ZJScrollPageView *demandScrollView;

@end

@implementation XXTree

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = YES;
    style.segmentViewBounces = NO;
    style.gradualChangeTitleColor = YES;
    style.normalTitleColor   = [UIColor colorWithRed:206.0/255.0  green:206.0/255.0  blue:206.0/255.0  alpha:1];
    style.selectedTitleColor = [UIColor colorWithRed:255.0/255.0  green:255.0/255.0  blue:255.0/255.0  alpha:1];
    style.coverBackgroundColor = [UIColor colorWithRed:96.0/255.0  green:189.0/255.0  blue:106.0/255.0  alpha:1];
    style.titleMargin = 10;
    style.coverHeight = [UIScreen mainScreen].bounds.size.height/20;
    style.coverCornerRadius = [UIScreen mainScreen].bounds.size.height/38;
    style.showExtraButton = NO;
    
    style.titleFont = [UIFont systemFontOfSize:16];
    style.segmentHeight = [UIScreen mainScreen].bounds.size.height/10;
    titles = @[@"学生",@"企业",@"培训"
                        ];
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:titles parentViewController:self delegate:self];
    scrollPageView.backgroundColor  = [UIColor blackColor];
    self.demandScrollView = scrollPageView;
    __weak typeof(self) weakSelf = self;
    
    self.demandScrollView.extraBtnOnClick = ^(UIButton *extraBtn){
        weakSelf.title = @"点击了extraBtn";
        
    };
    [self.view addSubview:self.demandScrollView];
    [self initTreeAddBtn];
//    [self setStatusBarBackgroundColor:[UIColor blackColor]];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)initTreeAddBtn{
    if (!treeAddBtn) {
        double AddY = [UIScreen mainScreen].bounds.size.height/32 + [UIApplication sharedApplication].statusBarFrame.size.height;
        double AddX = [UIScreen mainScreen].bounds.size.width-40;
        double AddSide = [UIScreen mainScreen].bounds.size.height/28;
        treeAddBtn  = [[UIButton alloc]initWithFrame:CGRectMake(AddX, AddY, AddSide, AddSide)];
        [treeAddBtn setBackgroundImage: [UIImage imageNamed:@"add_navbar"] forState:UIControlStateNormal];
        [treeAddBtn addTarget:self action:@selector(jumptoAddVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:treeAddBtn];
        
        searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(AddX-AddSide*1.4, AddY, AddSide, AddSide)];
        [searchBtn setBackgroundImage: [UIImage imageNamed:@"search_home"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(jumptoSearchVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:searchBtn];
        
        
    }
}
-(void)jumptoAddVC{
    [self performSegueWithIdentifier:@"xxadddemand" sender:nil];
}

-(void)jumptoSearchVC{
    XXDemandSearchViewController *searchvc = [[XXDemandSearchViewController alloc]init];
    [self.navigationController pushViewController:searchvc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (NSInteger)numberOfChildViewControllers {
    return 3;// 传入页面的总数, 推荐使用titles.count
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
//    NSLog(@"%ld---------", index);
    if (index == 0) {
        XXStudentLeaf *childVc = (XXStudentLeaf *)reuseViewController;
        if (childVc == nil) {
            childVc = [[XXStudentLeaf alloc] init];
        }
//        childVc.leafdelegate = self;
        return childVc;
        
    } else if (index == 1) {
        XXStudentLeaf *childVc = (XXStudentLeaf *)reuseViewController;
        if (childVc == nil) {
            childVc = [[XXStudentLeaf alloc] init];
            childVc.view.backgroundColor = [UIColor redColor];
        }
//        childVc.leafdelegate = self;
        return childVc;
    } else {
        XXStudentLeaf *childVc = (XXStudentLeaf *)reuseViewController;
        if (childVc == nil) {
            childVc = [[XXStudentLeaf alloc] init];
            childVc.view.backgroundColor = [UIColor greenColor];
        }
        
        if (index%2==0) {
            childVc.view.backgroundColor = [UIColor orangeColor];
        }
//        childVc.leafdelegate = self;
        return childVc;
    }
}

-(void)didClickDetail:(XXDemandModel *)xxDemandDetailModel{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XXDemandDetailVC *detailVC = [story instantiateViewControllerWithIdentifier:@"Demanddetail"];
    detailVC.xxDemandDetailModel = xxDemandDetailModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
