//
//  OtherViewController.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/20.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "OtherViewController.h"
#import "UIModel.h"
#import "SVProgressHUD.h"
@interface OtherViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUserDefaults * user;
    NSArray*cellTitleArray;
    }
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.navigationItem.title = @"其他";
    cellTitleArray=@[@"使用說明",@"分享APP",@"關於我們"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
    return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
    if (indexPath.section==0) {
         UISwitch * mySwitch = [[UISwitch alloc] init];
        [mySwitch addTarget:self action:@selector(mainSwitch:) forControlEvents:UIControlEventValueChanged];
          [self checkSwitch:mySwitch];
        mySwitch=[UIModel setSwitchUI:mySwitch];
        cell.accessoryView=mySwitch;
        cell.textLabel.text = @"上傳排行榜";
        cell.detailTextLabel.text = @"附註：上傳排行榜只會將完成度與暱稱上傳";
    }
    else{
    cell.textLabel.text = cellTitleArray[indexPath.row];
    cell.detailTextLabel.text = @"";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:{
            //說明
            
            }
                break;
            case 1:{
            //分享
                NSString *textToShare = @"快來玩臺灣拼圖";
                
                UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);//设置截屏的范围，起点为当前视图的（0，0，0，0）
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *screenShotImage=UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                UIImage *imageToShare = screenShotImage;//截取的当前屏幕的图片可以作为如下imageToShare图片分享出去
                
//                UIImage *imageToShare = [UIImage imageNamed:@""];
                
                NSURL *urlToShare = [NSURL URLWithString:@"https://www.yahoo.com.tw"];
                
                NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
                
                UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                
                activityVC.completionWithItemsHandler = ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
                    
                    NSLog(@" 111activityType = %@ \n completed = %d",activityType,completed);
                    
                    if (completed) {
                        
                        
                        
                    }
                    
                };
                
                activityVC.excludedActivityTypes = @[
                                                     UIActivityTypeMail
                                                     ,UIActivityTypePrint
                                                     ,UIActivityTypeCopyToPasteboard
                                                     ,UIActivityTypeAssignToContact
                                                     ,UIActivityTypeSaveToCameraRoll
                                                     ,UIActivityTypeAddToReadingList
                                                     ,UIActivityTypePostToVimeo
                                                     ,UIActivityTypeAirDrop
                                                     ,UIActivityTypeOpenInIBooks
                                                     ];
                
                [self presentViewController:activityVC animated:TRUE completion:nil];
            }
                break;
            case 2:{
            //
                UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                UIViewController * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContactUs"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"設定";
            break;
            
        case 1:
            return @"其他";
            break;
            
        default:
            return @"";
            break;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (void)mainSwitch:(UISwitch*)sender {
    
        if (sender.on) {
            [user setBool:YES forKey:@"CheckSwitch2"];
            [SVProgressHUD showInfoWithStatus:@"開啟上傳排行榜"];
        }else{
            [user setBool:NO forKey:@"CheckSwitch2"];
            [SVProgressHUD showInfoWithStatus:@"關閉上傳排行榜"];
        }
        [user synchronize];
    
}

-(UISwitch*)checkSwitch: (UISwitch*)mySwitch{
    if ([user boolForKey:@"CheckSwitch2"]==YES) {
            mySwitch.on=YES;
    }else{
        mySwitch.on=NO;
    }
    return mySwitch;
}
@end
