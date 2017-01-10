//
//  Init.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "Init.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMdrawerVisualState.h"
#import "CityModel.h"
@interface Init ()
{
    NSUserDefaults * user;
}
@property MMDrawerController *drawerController;
@end

@implementation Init
-(void)viewDidAppear:(BOOL)animated{
    //iverson1234tw
    if ([user boolForKey:@"first"]==false) {
       
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIStoryboard* sideMenu = [UIStoryboard storyboardWithName:@"SideMenu" bundle: nil];
        _drawerController = [[MMDrawerController alloc] initWithCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarContoller"] leftDrawerViewController:[sideMenu instantiateViewControllerWithIdentifier:@"SideMenu"]];
        [_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
        [_drawerController setMaximumLeftDrawerWidth:280.0];
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
        [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        _drawerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _drawerController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:_drawerController animated:NO completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
