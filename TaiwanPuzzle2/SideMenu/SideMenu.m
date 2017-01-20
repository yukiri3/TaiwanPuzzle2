//
//  SideMenu.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "SideMenu.h"
#include "CityModel.h"
@import Firebase;
@interface SideMenu ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton * myName;
    NSUserDefaults * user;
    UIImageView * imgView ;
    CityModel * cityModel;
}
@property(nonatomic,strong)NSMutableArray* saveCityNameArray;
@property(nonatomic,strong)NSMutableArray* saveCityTimeArray;
@end

@implementation SideMenu
-(void)viewDidAppear:(BOOL)animated{
        [self reloadArrayData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    user=[NSUserDefaults standardUserDefaults];
    [self setlayoutHeaderView];
    [self loadMyRoad];
    [self reloadArrayData];
    
    
}
-(void)reloadArrayData{
    cityModel=[[CityModel alloc] init];
    NSEnumerator* enumeratorKey = [cityModel.cityMyRoad keyEnumerator];
    self.saveCityTimeArray=[[NSMutableArray alloc] init];
    self.saveCityNameArray=[[NSMutableArray alloc] init];
    for (id key in enumeratorKey) {
        id cityTime=[cityModel.cityMyRoad objectForKey:key];
        [self.saveCityNameArray addObject:key];
        [self.saveCityTimeArray addObject:cityTime];
    }
    [self.tableView reloadData];
}
-(void)arrayChange{
    if ([self.saveCityNameArray count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self.saveCityNameArray count] - 1;
    while (i < j) {
        [self.saveCityNameArray exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
    if ([self.saveCityTimeArray count] == 0)
        return;
    NSUInteger ii = 0;
    NSUInteger jj = [self.saveCityTimeArray count] - 1;
    while (ii < jj) {
        [self.saveCityTimeArray exchangeObjectAtIndex:ii
                                    withObjectAtIndex:jj];
        
        ii++;
        jj--;
    }

}

-(void)loadMyRoad{
    cityModel = [[CityModel alloc] init];
    NSString *rootPath1 = [NSSearchPathForDirectoriesInDomains
                           (NSDocumentDirectory,NSUserDomainMask, YES)
                           objectAtIndex:0];
    NSString* nowlocalPath = [rootPath1 stringByAppendingPathComponent:@"nowLocal.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:nowlocalPath])
    {
        nowlocalPath = [[NSBundle mainBundle] pathForResource:@"nowLocal" ofType:@"plist"];
        cityModel.cityMyRoad = [[NSMutableDictionary alloc] initWithContentsOfFile:nowlocalPath];
    }else{
        cityModel.cityMyRoad =[[NSMutableDictionary alloc] initWithContentsOfFile:nowlocalPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return cityModel.cityMyRoad.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenu" forIndexPath:indexPath];
    
    cell.textLabel.text = self.saveCityNameArray[indexPath.row];
    cell.detailTextLabel.text = self.saveCityTimeArray[indexPath.row];
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
    if ([user objectForKey:@"MyImage"]!=nil) {
        NSData * imgData = [user objectForKey:@"MyImage"];
        imgView.image =[UIImage imageWithData:imgData];
    }
    //姓名
    myName = [[UIButton alloc] initWithFrame:CGRectMake(100, 30, 100,35)];
    [myName setTitle:[user objectForKey:@"MyName"] forState:UIControlStateNormal];
    myName.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [myName setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    myName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    myName.layer.borderWidth = 1.0f;
    myName.layer.cornerRadius = 10.0f;
    
    UIButton * modify = [[UIButton alloc] initWithFrame:CGRectMake(100, 70, 100,35)];
    [modify setTitle:@"刷新" forState:UIControlStateNormal];
    modify.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:11];
    [modify setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [modify addTarget:self
               action:@selector(reloadArrayData)
     forControlEvents:UIControlEventTouchUpInside
     ];
    [mainView addSubview:modify];
    [mainView addSubview:imgView];
    [mainView addSubview:myName];
    self.tableView.tableHeaderView=mainView;
    
}
-(void)clickCategory:(UITapGestureRecognizer* )gestureRecognizer
{
    NSLog(@"點到相片");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更換相片" message:@"請選擇" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相機"
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
    UIAlertAction *albums = [UIAlertAction actionWithTitle:@"相簿"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                      picker.delegate = self;
                        
                                                      picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                      picker.allowsEditing=YES;
                                                      [self presentViewController:picker animated:YES completion:nil];
                                                }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:camera];
    [alert addAction:albums];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    imgView.image = image;
    [user setObject:UIImagePNGRepresentation(image) forKey:@"MyImage"];
    [user synchronize];
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

-(void)changeMyName{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改暱稱" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"請輸入你的名字";
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (alert.textFields.firstObject.text!=nil) {
            [user setObject:alert.textFields.firstObject.text forKey:@"MyName"];
            [user synchronize];
            [myName setTitle:[user objectForKey:@"MyName"] forState:UIControlStateNormal];
        }
        else{
        }
       
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
