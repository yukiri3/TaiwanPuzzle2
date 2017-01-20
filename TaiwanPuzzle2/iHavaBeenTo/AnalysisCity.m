//
//  AnalysisCity.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/17.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "AnalysisCity.h"
#import "CityModel.h"
#import "UIModel.h"
#import "OBShapedButton.h"
@interface AnalysisCity () <UIScrollViewDelegate>
{
    CGFloat scale, rotate;
    CityModel * cityModel;
    
    CGFloat width,height;
}
@property (strong, nonatomic)  UIView *myView;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation AnalysisCity
- (void) back:(UIBarButtonItem *)sender {
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
    self.tabBarController.tabBar.hidden=YES;
 
    self.navigationItem.title = @"城市詳情";
    cityModel = [[CityModel alloc] init];
    OBShapedButton*mainMap = [[OBShapedButton alloc] init];
 
    if ([_cityName isEqualToString:@"屏東縣"]) {
        width=188.0;
        height=362.0;
    }else if([_cityName isEqualToString:@"新北市"]){
        width = 300;
        height = 310;
    }else if([_cityName isEqualToString:@"苗栗縣"]){
        width=305.0;
        height = 237.0;
    }else if([_cityName isEqualToString:@"台東縣"]){
        width=275.0;
        height=350.0;
    }else if([_cityName isEqualToString:@"南投縣"]){
        height=300.0;
        width=250.0;
    }else if([_cityName isEqualToString:@"雲林縣"]){
        height=235.0;
        width=352.0;
        
    }else if([_cityName isEqualToString:@"澎湖縣"]){
        width = 300.8;
        height = 232.9;
    }else if([_cityName isEqualToString:@"高雄市"]){
        width = 248.0;
        height = 302.8;
    }
    else if([_cityName isEqualToString:@"花蓮縣"]){
        width = 214.4;
        height = 376.4;
    }
    else if([_cityName isEqualToString:@"桃園市"]){
        width = 300.4;
        height = 360.4;
    }
    else if([_cityName isEqualToString:@"宜蘭縣"]){
        width = 286.65;
        height = 328.25;
    }
    else{
        width = 300.0;
        height = 300.0;
    }
    
       self.myScrollView.delegate=self;
    [self.myScrollView setMaximumZoomScale:3.0];
    [self.myScrollView setMinimumZoomScale:0.5];
    
    mainMap.frame=CGRectMake(_myView.frame.size.width/2-width/2,0,width,height);
    [mainMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.cityName]] forState:UIControlStateNormal];
    [self.myView addSubview:mainMap];
    for(int i=0;i<self.cityArray.count;i++){
        NSString*key=[self.cityArray objectAtIndex:i];
        OBShapedButton*cityBtn = [[OBShapedButton alloc] init];
        cityBtn.frame = CGRectMake(_myView.frame.size.width/2-width/2,0,width,height);
        [cityBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",key]] forState:UIControlStateNormal];
        if ([[cityModel.cityData objectForKey:key] boolValue] == true ) {
            cityBtn.tag = [key intValue];
            [cityBtn addTarget:self action:@selector(changeLabelText:) forControlEvents:UIControlEventTouchUpInside];
            [self.myView addSubview:cityBtn];
        }
    }
    self.navigationItem.leftBarButtonItem = [UIModel setBackButtonUI:self.navigationItem.leftBarButtonItem];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(back:)];
    _myLabel.text = _cityName;
    [_myScrollView addSubview:_myView];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  {
    return [[scrollView subviews]objectAtIndex:0];
}
-(void)changeLabelText:(UIButton*)button{
        _myLabel.text=[CityModel postCodeToCity:button.tag];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
