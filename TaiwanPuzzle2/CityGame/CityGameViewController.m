//
//  CityGameViewController.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/6.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "CityGameViewController.h"
#import "CityModel.h"
@import Firebase;
@interface CityGameViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation CityGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _label.text=@"下載題庫中";
    self.ref = [[FIRDatabase database] reference];
    [[_ref child:@"game1"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        CityModel * cityModel=[[CityModel alloc] init];
        //        cityModel.gameDict = [[NSDictionary alloc] init];
        cityModel.gameDict = snapshot.value;
        _label.text=@"下載完畢";
//        NSLog(@"這裡：%@",cityModel.gameDict);
        _button.enabled = YES;
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"錯誤：%@", error.localizedDescription);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
