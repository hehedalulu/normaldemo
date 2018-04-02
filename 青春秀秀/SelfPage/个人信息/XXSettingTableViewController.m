//
//  XXSettingTableViewController.m
//  青春秀秀
//
//  Created by luluwang on 2018/4/2.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXSettingTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "XXSelfPublishViewController.h"
#import "UIViewController+DKHUD.h"

@interface XXSettingTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *selfdetail;
@property (weak, nonatomic) IBOutlet UIImageView *selfdetailAvatar;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailNick;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailID;
@property (weak, nonatomic) IBOutlet UILabel *selfdetailPhoneNumber;

@end

@implementation XXSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    BmobUser *bUser = [BmobUser currentUser];
    //头像
    if ([bUser objectForKey:@"avatar"]) {
        NSURL *imgurl = [NSURL URLWithString:[bUser objectForKey:@"avatar"]];
        UIImage *imagett = [UIImage imageWithData: [NSData dataWithContentsOfURL:imgurl]];
        [_selfdetailAvatar setImage:imagett];
        }else{
            _selfdetailAvatar.backgroundColor = [UIColor lightGrayColor];
        }
    //昵称
    if ([bUser objectForKey:@"nick"]) {
        _selfdetailNick.text = bUser.username;
    }else{
        _selfdetailNick.text = @"无名氏";
    }
    //ID
    _selfdetailID.text = bUser.objectId;
    _selfdetailPhoneNumber.text = bUser.mobilePhoneNumber;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];// 取消选中效果
    
    if (indexPath.row==0) {
        [self chosephotOrAlbum];
    }else if(indexPath.row==1){
        [self changename];
    }
//    if (indexPath.row==0&&indexPath.section==2) {
//        //                [self performSegueWithIdentifier:@"SelfInformation" sender:self];
//        //        XXSelfPublishViewController *publishVC = [[XXSelfPublishViewController alloc]init];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        XXSelfPublishViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"selfpublish"];
//        [self.navigationController pushViewController:cvc animated:YES];
//    }
}

-(void)changename{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"修改用户名"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         for(UITextField *text in alertController.textFields){
                                                             NSLog(@"text = %@", text.text);
                                                             [self updateName:text.text];
                                                             [self showHUD:@"正在修改用户名中"];
                                                         }
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             NSLog(@"action = %@", alertController.textFields);
                                                         }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)chosephotOrAlbum{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self chosephoto];//拍照
    }];
    [alertController addAction:photo];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self choseAlbum];//从相册选择
    }];
    [alertController addAction:album];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)chosephoto{
    //判断设备是否装配相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        //设置照片来源是设备上的相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置imagepicker的代理是自己
        imagePicker.delegate = self;
        //打开相机界面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"cancel choose");
    
}

-(void)choseAlbum{
    UIPopoverPresentationController *popover;
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    //设置照片来源为移动设备内的相册
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    //设置显示模式popover
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    popover = imagePicker.popoverPresentationController;
    
    //设置popover窗口与哪一个view组件有关联
    popover.sourceView = _selfdetailAvatar;
    
    //以下两行处理popover的箭头位置
    popover.sourceRect = _selfdetailAvatar.bounds;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *bigimage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *smallicon = [self clipImage:bigimage toRect:CGSizeMake(100, 100)];
//    _selfdetailAvatar.image = smallicon;
    [self ImageTofile:smallicon WithStr:@"useravatar"];
    [self showHUD:@"修改头像中"];
    
}

-(UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size{
    if (image.size.width*size.height <= image.size.height*size.width) {
        
        //以被剪裁图片的宽度为基准，得到剪切范围的大小
        CGFloat width  = image.size.width;
        CGFloat height = image.size.width * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake(0, (image.size.height -height)/2, width, height)];
        
    }else{ //被切图片宽比例比高比例大，以图片高进行剪裁
        
        // 以被剪切图片的高度为基准，得到剪切范围的大小
        CGFloat width  = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
        return [self imageFromImage:image inRect:CGRectMake((image.size.width -width)/2, 0, width, height)];
    }
    return nil;
}


-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

-(void)ImageTofile:(UIImage *)image WithStr:(NSString *)ImageStr{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int count = 0;
        NSData   *imageData = UIImagePNGRepresentation(image);
        //临时path及命名
        NSArray  *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cacPath objectAtIndex:0];
        NSString *pathstring = [ImageStr stringByAppendingString:[NSString stringWithFormat:@"%d.png",count]];
        NSString *path   = [cachePath stringByAppendingPathComponent:pathstring];//大图
        
        count++;
        [imageData writeToFile:path atomically:NO];
        
        BmobFile *file = [[BmobFile alloc]initWithFilePath:path];
        [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                NSLog(@"file upload error %@",error);
            }else if (isSuccessful){
                NSLog(@"头像上传成功url为%@",file.url);
                BmobUser *bUser = [BmobUser currentUser];
                [bUser setObject: file.url forKey:@"avatar"];
                [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if(isSuccessful){
                        [self showSuccess:@"修改头像成功"];
                        _selfdetailAvatar.image = image;
                    }else{
                        [self showError:@"修改头像失败，请检查网络"];
                        NSLog(@"refresh头像失败");
                    }
                }];
                
            }
        } withProgressBlock:^(CGFloat progress) {
            NSLog(@"%@:progress %f",ImageStr,progress);
        }];
    });
}


- (void)updateName:(NSString *)NewName{
    BmobUser *bUser = [BmobUser currentUser];
    [bUser setUsername:NewName];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if(isSuccessful){
            [self showSuccess:@"修改成功"];
            _selfdetailNick.text = NewName;
        }else{
            [self showError:@"修改昵称失败，请检查网络"];
            NSLog(@"refresh头像失败");
        }
    }];
}
@end
