//
//  CityModel.h
//  TaiwanPuzzle2
//
//  Created by user on 2016/12/9.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (strong,nonatomic) NSMutableDictionary * cityData;
@property(strong,nonatomic) NSMutableDictionary * cityMyRoad;
@property (strong,nonatomic) NSArray * cityComlpeteArr;
@property (strong,nonatomic)NSMutableArray*rankArray;
+(NSDictionary*)computeCity: (NSMutableDictionary*)cityData;
+(NSString*)postCodeToCity:(NSInteger)postcode;
+(NSString*)computePercentage: (int)city;
+(int)upDateComplete: (NSMutableDictionary*)dict;

@end
