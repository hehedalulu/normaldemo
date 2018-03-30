//
//  XXShow.m
//  青春秀秀
//
//  Created by luluwang on 2017/12/18.
//  Copyright © 2017年 luluwang. All rights reserved.
//

#import "XXShow.h"

@interface XXShow ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,XXShowCellDelegate>{
    NSMutableArray *XXShowModelList;
    UITableView *XXShowtableView;
    UITextField *_textField;
    NSIndexPath *_currentEditingIndexthPath;
    CGFloat _totalKeybordHeight;
    BOOL AutoScroll;
}

@end

@implementation XXShow

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initXXShowModelList];
    [self initTable];
    AutoScroll = NO;
    
    [self setupTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (XXShowModelList !=nil) {
        [XXShowtableView.mj_header beginRefreshing];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [_textField resignFirstResponder];
}
- (void)dealloc{
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)initTable{
    if (XXShowtableView == nil) {
        double tableviewY = self.navigationController.navigationBar.frame.size.height;
        double tableviewHeight = [[UIScreen mainScreen] bounds].size.height-self.navigationController.navigationBar.frame.size.height;
        XXShowtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,tableviewY,
                                                                     [[UIScreen mainScreen] bounds].size.width,
                                                                     tableviewHeight) style:UITableViewStylePlain];
        [XXShowtableView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        XXShowtableView.showsVerticalScrollIndicator = NO;
        XXShowtableView.dataSource                   = self;
        XXShowtableView.delegate                     = self;
        [self setupRefresh:XXShowtableView];
        [XXShowtableView registerClass:[XXShowCell class] forCellReuseIdentifier:NSStringFromClass([XXShowCell class])];
        NSLog(@"初始化ShowtableView");
        [self.view addSubview:XXShowtableView];
        
        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/4,
                                                                     [UIScreen mainScreen].bounds.size.height*4/5,
                                                                     50, 50)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(jumptoAddShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addBtn];
    }
}
-(void)initXXShowModelList{
    if (!XXShowModelList) {
        XXShowModelList = [NSMutableArray array];
//        [XXShowModelList addObjectsFromArray:[XXShowModel models]];
            //            NSLog(@"初始化");
    }
}

#pragma mark 3个tableView的各项设置
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return XXShowModelList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XXShowModel *moedel = [XXShowModelList objectAtIndex:indexPath.row];
//    NSString *test = moedel.contentText;
    return [tableView cellHeightForIndexPath:indexPath model:moedel keyPath:@"xxshowmodel" cellClass:[XXShowCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class currentClass = [XXShowCell class];
    XXShowCell *cell = nil;
    cell.userInteractionEnabled = YES;
    
    XXShowModel *model = [XXShowModelList objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    cell.xxshowmodel = model;
    
    cell.delegate = self;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 上下拉刷新
-(void)setupRefresh:(UITableView*)tableView{
    __unsafe_unretained __typeof(self) weakSelf = self;
    XXShowtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewLeft];
    }];
    [XXShowtableView.mj_header beginRefreshing];
    XXShowtableView.mj_header.automaticallyChangeAlpha = YES;
    XXShowtableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreLeft];
    }];
}

-(void)loadNewLeft{
    [XXShowModelList removeAllObjects];
    if (XXShowtableView.mj_footer.state == MJRefreshStateRefreshing) {
        return;
    }
    BmobQuery *query = [BmobQuery queryWithClassName:@"Show"];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"-----xxShowModel error:%@",error);
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDate *now = [NSDate date];
                for (BmobObject *obj in array) {
                    XXShowModel *model = [[XXShowModel alloc]init];
                    model.showOjectId = obj.objectId;
                    if ([[obj objectForKey:@"likeit"] isEqualToString:@"0"]) {
                        model.iLikeit = NO;
                    }else{
                        model.iLikeit = YES;
                    }
                    model.usernameLB = [obj objectForKey:@"ShowName"];
                    model.xxshowmodelAvatarStr = [obj objectForKey:@"ShowAvatar"];
                    model.contentText = [obj objectForKey:@"ShowContent"];
                    model.xxshowmodeltime = [self calTime:obj.createdAt WithNow:now];
                    model.picNamesArray = [obj objectForKey:@"SmallPicArray"];
//                    model.commentArray =;
                    NSArray *ComArray  = [obj objectForKey:@"CommentArray"];
                    NSMutableArray *TemArray = [NSMutableArray array];
                    for (NSArray *ary in ComArray) {
                        XXShowCommentItemModel *commentItemModel = [XXShowCommentItemModel new];
                        commentItemModel.firstUserName = ary[0];
                        commentItemModel.commentString = ary[1];
                        commentItemModel.firstUserId = ary[2];
                        [TemArray addObject:commentItemModel];
                    }
                    
                    model.commentArray = [TemArray copy];
                    
                    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
                    BmobObject *post = [BmobObject objectWithoutDataWithClassName:@"Show" objectId:obj.objectId];
                    [bquery whereObjectKey:@"likes" relatedTo:post];
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (error) {
                            NSLog(@"%@",error);
                        } else {
                            NSMutableArray *tempArray = [NSMutableArray array];
                            for (BmobObject *user in array) {
                                XXShowLikeItemModel *likemodel = [[XXShowLikeItemModel alloc]init];
                                likemodel.userId = user.objectId;
                                likemodel.userName = [user objectForKey:@"username"];
                                [tempArray addObject:likemodel];
                            }
                            NSLog(@"点赞列表=------%@",tempArray);
                            model.likeArray = (NSArray *)tempArray;
                        }
                    }];
//                    model.commentArray = [obj objectForKey:@"commentArray"];
                    [XXShowModelList addObject:model];
                }
            });
        }

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XXShowtableView reloadData];
            [XXShowtableView.mj_header endRefreshing];
            XXShowtableView.mj_footer.state = MJRefreshStateIdle;
        });
    }];
    
}
-(void)loadMoreLeft{
    if (XXShowtableView.mj_footer.state ==MJRefreshStateNoMoreData||XXShowtableView.mj_header.state == MJRefreshStateRefreshing) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Show"];
    [query orderByDescending:@"createdAt"];
    query.skip = XXShowModelList.count;
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"-----xxShowModel error:%@",error);
        }else{
            if(array.count == 0){
                NSLog(@"加载完毕");
                XXShowtableView.mj_footer.state = MJRefreshStateNoMoreData;
                [XXShowtableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDate *now = [NSDate date];
                    for (BmobObject *obj in array) {
                        XXShowModel *model = [[XXShowModel alloc]init];
                        model.showOjectId = obj.objectId;
                        model.iLikeit = [obj objectForKey:@"likeit"];
                        model.usernameLB = [obj objectForKey:@"ShowName"];
                        model.xxshowmodelAvatarStr = [obj objectForKey:@"ShowAvatar"];
                        model.contentText = [obj objectForKey:@"ShowContent"];
                        model.xxshowmodeltime = [self calTime:obj.createdAt WithNow:now];
                        NSLog(@"test%@",model.xxshowmodeltime);
                        model.picNamesArray = [obj objectForKey:@"SmallPicArray"];
//                        model.likeArray = [obj objectForKey:@"likeArray"];
//                        model.commentArray = [obj objectForKey:@"commentArray"];
                        [XXShowModelList insertObject:model atIndex:XXShowModelList.count];
                    }
                });
            }
        }
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XXShowtableView reloadData];
            [XXShowtableView.mj_header endRefreshing];
//        });
    }];
    });
}

-(NSString *)calTime:(NSDate *)creatTime WithNow:(NSDate *)now{
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
-(void)jumptoAddShow{
    [self performSegueWithIdentifier:@"addShow" sender:self];
}



- (void)setupTextField{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.backgroundColor = [UIColor lightGrayColor];
    
    
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark - XXShowCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [XXShowtableView indexPathForCell:cell];
//    NSLog(@"user like----");
    [self adjustTableViewToFitKeyboard];
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell{
        NSIndexPath *index = [XXShowtableView indexPathForCell:cell];
        XXShowModel *model = XXShowModelList[index.row];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeArray];
        NSLog(@"click great");
        if (!model.iLikeit) {
            XXShowLikeItemModel *likeModel = [XXShowLikeItemModel new];
            BmobUser *user = [BmobUser currentUser];
            likeModel.userName = user.username;
            likeModel.userId = user.objectId;
            [temp addObject:likeModel];
            
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Show"];
            [bquery getObjectInBackgroundWithId:model.showOjectId block:^(BmobObject *object,NSError *error){
                if (error){
                    NSLog(@"获取点赞表失败----%@",error);
                }else{
                    if (object) {
                        [object setObject:@"1" forKey:@"likeit"];

                        BmobRelation *relation = [[BmobRelation alloc] init];
                        [relation addObject:[BmobObject objectWithoutDataWithClassName:@"_User" objectId:user.objectId]];
                        //添加关联关系到likes列中
                        [object addRelation:relation forKey:@"likes"];
                        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (error) {
                                NSLog(@"点赞失败%@",error);
                            }else{
                                NSLog(@"点赞成功");
                                model.iLikeit = YES;
                                [XXShowModelList setObject:model   atIndexedSubscript:index.row];
                                [XXShowtableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                            }
                        }];
                    }
                }
            }];
        } else {
            XXShowLikeItemModel *tempLikeModel = nil;
            for (XXShowLikeItemModel *likeModel in model.likeArray) {
                if ([likeModel.userId isEqualToString:@"gsdios"]) {
                    tempLikeModel = likeModel;
                    break;
                }
            }
            [temp removeObject:tempLikeModel];
            model.iLikeit = NO;
        }
        model.likeArray = [temp copy];
    
}


-(void)adjustTableViewToFitKeyboard{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XXShowCell *cell = [XXShowtableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = XXShowtableView.contentOffset;
    offset.y += delta;
    NSLog(@"contentoffset%f",offset.y);
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [XXShowtableView setContentOffset:offset animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        XXShowModel *model =  XXShowModelList[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentArray];
        
        XXShowCommentItemModel *commentItemModel = [XXShowCommentItemModel new];
        BmobUser *bUser = [BmobUser currentUser];
        commentItemModel.firstUserName = bUser.username;
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = bUser.objectId;
        [temp addObject:commentItemModel];
        
        [self uploadCommentWithModel:model AndCommentmodel:commentItemModel];
        
        model.commentArray = [temp copy];
        

        _textField.text = @"";
        return YES;
    }
    return NO;
}

-(void)uploadCommentWithModel:(XXShowModel *)model AndCommentmodel:(XXShowCommentItemModel *)commentItemModel{
    __block NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:
                          commentItemModel.firstUserName,
                          commentItemModel.commentString,
                          commentItemModel.firstUserId,
                          nil];
    __block NSMutableArray *oldArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Show"];
        [bquery getObjectInBackgroundWithId:model.showOjectId block:^(BmobObject *object,NSError *error){
            if (error){
                NSLog(@"获取评论表失败----%@",error);
            }else{
                if (object) {
                    if([object objectForKey:@"CommentArray"]){
                        oldArray = [object objectForKey:@"CommentArray"];
                    }
                    [oldArray addObject:tempArray];
                    [object setObject: oldArray forKey:@"CommentArray"];
                    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            NSLog(@"评论失败%@",error);
                        }else{
                            NSLog(@"评论成功");
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [XXShowtableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
                            });
                            
                        }
                    }];
                }
            }
        }];
    });

    
}


- (void)keyboardNotification:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - 40, rect.size.width, 40);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
       _textField.frame = textFieldRect;
    } completion:^(BOOL finished) {
        NSLog(@"_textField Height is %f",rect.origin.y);
        if (rect.origin.y != [UIScreen mainScreen].bounds.size.height) {
             AutoScroll = YES;
        }else{
            AutoScroll = NO;
        }
    }];
    
    
    CGFloat h = rect.size.height + 40;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (AutoScroll) {
        [_textField resignFirstResponder];
    }
    
}
@end
