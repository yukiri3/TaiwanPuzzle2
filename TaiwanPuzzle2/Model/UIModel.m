//
//  UIModel.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/20.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "UIModel.h"

@implementation UIModel
+(UISwitch*)setSwitchUI: (UISwitch*)mySwitch{
   
    mySwitch.onTintColor = [UIColor colorWithRed:2.0/255 green:223.0/255 blue:130.0/255 alpha:1];
    mySwitch.tintColor = [UIColor colorWithRed:255.0/255 green:81.0/255 blue:81.0/255 alpha:1];
    mySwitch.layer.cornerRadius = 16;
    mySwitch.backgroundColor = [UIColor colorWithRed:255.0/255 green:81.0/255 blue:81.0/255 alpha:1];
    return mySwitch;
}
+(UIBarButtonItem*)setBackButtonUI{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:nil];
    newBackButton.tintColor=[UIColor whiteColor];

    return newBackButton;
}
@end
