//
//  XXAddShow.m
//  青春秀秀
//
//  Created by luluwang on 2018/1/13.
//  Copyright © 2018年 luluwang. All rights reserved.
//

#import "XXAddShow.h"
@interface XXAddShow (){
    UIButton *xxshowaddPicBtn;
    NSMutableArray *picArrray;
    NSMutableArray *smallPicArray;
    int margin;
    int length;
    int PicCount;
    UIImage *currentImage;
}

@end

@implementation XXAddShow

- (void)viewDidLoad {
    [super viewDidLoad];
    _XXAddShowContent.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/5+5);
    
    length = ([UIScreen mainScreen].bounds.size.width-25)/4;
    margin = 5;
    PicCount = 1;
    xxshowaddPicBtn = [[UIButton alloc]initWithFrame:CGRectMake(margin, [UIScreen mainScreen].bounds.size.height*2/5-length, length, length)];
    [xxshowaddPicBtn setBackgroundImage:[UIImage imageNamed:@"addPic"] forState:UIControlStateNormal];
    [xxshowaddPicBtn addTarget:self action:@selector(chosephotOrAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xxshowaddPicBtn];
    picArrray = [NSMutableArray array];
    smallPicArray = [NSMutableArray array];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)XXAddNewShoe:(UIBarButtonItem *)sender {
    if (_XXAddShowContent.text == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertController addAction:alert];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self pushNewShow];
    }
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
    popover.sourceView = xxshowaddPicBtn;

    //以下两行处理popover的箭头位置
    popover.sourceRect = xxshowaddPicBtn.bounds;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;

    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *bigimage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [self scaleToSize:bigimage size:CGSizeMake(424, 424*(bigimage.size.height/bigimage.size.width))];
    UIImage *smallimage = [self scaleToSize:bigimage size:CGSizeMake(100, 100*(bigimage.size.height/bigimage.size.width))];
    
    [self ImageTofile:image WithStr:@"image"];
    [self ImageTofile:smallimage WithStr:@"smallImage"];
    
    [self moveFrame:smallimage];
    
    
}
-(void)moveFrame:(UIImage *)smallImage{
        PicCount++;
    NSLog(@"count%i",PicCount);
        UIImageView *picView= [[UIImageView alloc]init];
        picView.userInteractionEnabled =YES;
        picView.backgroundColor = [UIColor greenColor];
    if (PicCount>10) {
        return;
    }
        if (PicCount < 5) {
        [UIView animateWithDuration:0.2 animations:^{
                xxshowaddPicBtn.frame = CGRectMake((margin+length)*(PicCount-1)+5, [UIScreen mainScreen].bounds.size.height*2/5-length, length, length);
        }];
            picView.frame = CGRectMake((margin+length)*(PicCount-2)+5,
                                                                     [UIScreen mainScreen].bounds.size.height*2/5-length,length, length);
        }else if (PicCount ==5) {
                _XXAddShowContent.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/5+10+length);
                xxshowaddPicBtn.frame = CGRectMake(margin, [UIScreen mainScreen].bounds.size.height*2/5+5, length, length);
            picView.frame = CGRectMake((margin+length)*3+5,
                                                                     [UIScreen mainScreen].bounds.size.height*2/5-length,length, length);
        }else if (PicCount<9&&PicCount>5){
        [UIView animateWithDuration:0.2 animations:^{
                xxshowaddPicBtn.frame = CGRectMake((margin+length)*(PicCount-5)+5, [UIScreen mainScreen].bounds.size.height*2/5+5, length, length);
            picView.frame = CGRectMake((margin+length)*(PicCount-6)+5,
                                                                     [UIScreen mainScreen].bounds.size.height*2/5+5,length, length);
        }];
        }else if (PicCount==9){
                _XXAddShowContent.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/5+15+length*2);
                xxshowaddPicBtn.frame = CGRectMake(margin, [UIScreen mainScreen].bounds.size.height*2/5+length+10, length, length);
            picView.frame = CGRectMake((margin+length)*3+5,
                                                                     [UIScreen mainScreen].bounds.size.height*2/5+5,length, length);
        }else if (PicCount==10){
            xxshowaddPicBtn.frame = CGRectMake(0, 0, 0, 0);
            picView.frame = CGRectMake(5,
                                                                     [UIScreen mainScreen].bounds.size.height*2/5+length+10,length, length);
        }
        picView.image = smallImage;
        [self.view addSubview:picView];
}


#pragma mark - compress Pic
//压缩图片
-(UIImage *)scaleToSize:(UIImage *)aImage size:(CGSize)size{
    //创建context,并将其设置为正在使用的context
    UIGraphicsBeginImageContext(size);
    //绘制出图片(大小已经改变)
    [aImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //获取改变大小之后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //context出栈
    UIGraphicsEndImageContext();
    return newImage; //返回获得的图片
}

#pragma mark -- push Show
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
                    if ([ImageStr isEqualToString:@"image"]) {
                        [picArrray addObject:file.url];
                    }else{
                        [smallPicArray addObject:file.url];
                    }
            }
        } withProgressBlock:^(CGFloat progress) {
            NSLog(@"%@:progress %f",ImageStr,progress);
        }];
    });
}

-(void)pushNewShow{
    NSLog(@"--------path %@",picArrray);
    
    BmobObject *show = [[BmobObject alloc] initWithClassName:@"Show"];
    [show setObject:_XXAddShowContent.text forKey:@"ShowContent"];
    [show setObject:picArrray forKey:@"PicArray"];
    [show setObject:smallPicArray forKey:@"SmallPicArray"];
    
    BmobUser *bUser = [BmobUser currentUser];
    [show setObject:bUser forKey:@"ShowUser"];
    [show setObject:[bUser objectForKey:@"avatar"] forKey:@"ShowAvatar"];
    [show setObject:bUser.username forKey:@"ShowName"];
    [show setObject:@"0" forKey:@"likeit"];
    
    [show saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                      if (isSuccessful) {
                                          NSLog(@"----new show----");
                                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *alert  =[UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                              [self.navigationController popViewControllerAnimated:YES];
                                              _xxshowbtn.enabled = NO;
                                          }];
                                          [alertController addAction:alert];
                                          [self presentViewController:alertController animated:NO completion:nil];
                                          
                                      }else{
                                          if (error) {
                                              NSLog(@"----show error,%@",error);
                                          }
                                      }
                                  }];
}
@end
