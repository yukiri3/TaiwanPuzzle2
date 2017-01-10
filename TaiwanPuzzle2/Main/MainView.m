//
//  MainView.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/12/8.
//  Copyright © 2016年 LiChen. All rights reserved.
//
#import "CityModel.h"
#import "TSMessage.h"
#import "MainView.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import<CoreLocation/CoreLocation.h>
#import "TSMessageView.h"
@interface MainView () <TSMessageViewProtocol>

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
  
}
- (IBAction)addNewButton:(id)sender {
   
}
- (IBAction)addNewData:(id)sender {
   
}
- (CGFloat)messageLocationOfMessageView:(TSMessageView *)messageView
{
    return 44.0; // any calculation here
}

- (void)customizeMessageView:(TSMessageView *)messageView
{
    messageView.alpha = 0.5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (IBAction)mainSwitch:(UISwitch*)sender {
    
    if (sender.on) {
        
           }else{
               
             
    }
}


-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerButton.tintColor=[UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}








@end
