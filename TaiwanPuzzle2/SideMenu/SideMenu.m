//
//  SideMenu.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "SideMenu.h"
#include "CityModel.h"
@interface SideMenu ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSUserDefaults * user;
    UIImageView * imgView ;
    NSMutableArray * array;
}
@end

@implementation SideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setlayoutHeaderView];
    user=[NSUserDefaults standardUserDefaults];
        
}

- (void)refresh{
    
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenu" forIndexPath:indexPath];
    
    cell.textLabel.text = [user objectForKey:@"MyCity"];
    
    return cell;
}


//set User Info
-(void)setlayoutHeaderView{
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,280,150)];
    imgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    imgView.frame= CGRectMake(20, 30,80, 80);
    imgView.layer.cornerRadius=imgView.frame.size.width/2;
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderWidth = 1.5f;
    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    [imgView setUserInteractionEnabled:YES];
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    UILabel * labelView = [[UILabel alloc] init];
    //姓名
    labelView.text = @"黃立晨";
    labelView.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    labelView.textColor = [UIColor grayColor];
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.frame = CGRectMake(100,30,100,35);
    //目標
    UIButton *qrCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 30,80,80)];
    [qrCodeBtn setBackgroundImage:[UIImage imageNamed:@"55"] forState:UIControlStateNormal];
    //
    UIButton * modify = [[UIButton alloc] initWithFrame:CGRectMake(100, 65, 100,35)];
    [modify setTitle:@"刷新" forState:UIControlStateNormal];
    modify.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:11];
    [modify setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [modify addTarget:self
               action:@selector(refresh)
     forControlEvents:UIControlEventTouchUpInside
     ];
    [mainView addSubview:modify];
    [mainView addSubview:qrCodeBtn];
    [mainView addSubview:imgView];
    [mainView addSubview:labelView];
    self.tableView.tableHeaderView=mainView;
    
}
-(void)clickCategory:(UITapGestureRecognizer* )gestureRecognizer
{
    NSLog(@"點到相片");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更換相片" message:@"請選擇" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *game1 = [UIAlertAction actionWithTitle:@"相機"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

                                                      if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                          imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                                                          imagePicker.delegate = self;
                                                          imagePicker.allowsEditing = YES;
                                           
                                                          [self presentViewController:imagePicker animated:YES completion:^{}];
                                                      }
                                                      else {
                                                    
                                                          NSLog(@"此裝置不支援相機");
                                                      }
                                                      
                                                      
                                                  }];
    UIAlertAction *game2 = [UIAlertAction actionWithTitle:@"相簿"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                      picker.delegate = self;
                        
                                                      picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                      picker.allowsEditing=YES;
                                                      //以動畫方式顯示圖庫
                                                      [self presentViewController:picker animated:YES completion:nil];
                                                      
                                                      
                                                      
                                                      
                                                  }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:game1];
    [alert addAction:game2];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    imgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"最近去過";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    headerView.text = @"最近去過";
    headerView.font = [UIFont fontWithName:@"Helvetica" size:14];
    headerView.textAlignment = NSTextAlignmentCenter;
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    return headerView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

@end
