//
//  CityRank.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/16.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "CityRank.h"
#import "CityModel.h"
@interface CityRank ()
{
    CityModel * cityModel;
}
@end
@implementation CityRank
- (void) back:(UIBarButtonItem *)sender {
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBackButton{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    newBackButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    cityModel = [[CityModel alloc] init];
    [self addBackButton];
    self.navigationItem.title = @"排行榜";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return cityModel.rankArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityRank" forIndexPath:indexPath];
    
    cell.textLabel.text = [cityModel.rankArray[indexPath.row] objectForKey:@"Name"];
    NSString *string = [[NSString alloc] initWithFormat:@"%@",[cityModel.rankArray[indexPath.row]objectForKey:@"City"]];
    cell.detailTextLabel.text = [string stringByAppendingString:@"/366"];
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_myfriends_first"];
            break;
        case 1:
             cell.imageView.image = [UIImage imageNamed:@"icon_myfriends_second"];
            break;
        case 2:
             cell.imageView.image = [UIImage imageNamed:@"icon_myfriends_third"];
            break;
            
        default:{
             cell.imageView.image = [UIImage imageNamed:@""];
        }
            break;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MyName"]isEqualToString:cell.textLabel.text]) {
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    return cell;
}



@end
