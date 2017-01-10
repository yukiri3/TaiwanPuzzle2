//
//  AppDelegate.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "AppDelegate.h"
#import "TSMessage.h"
#import <CoreLocation/CoreLocation.h>
#import <TSMessages/TSMessageView.h>
@import Firebase;
@interface AppDelegate ()<CLLocationManagerDelegate,TSMessageViewProtocol>
@property (strong,nonatomic) CLLocationManager * manager ;
@property (strong,nonatomic) NSString * currentCity;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    UIImage *NavigationLandscapeBackground = [[UIImage imageNamed:@"g3"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:NavigationLandscapeBackground forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
 
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
 
}


- (void)applicationWillTerminate:(UIApplication *)application {

}
//Location Manager


/*獲取新位置時調用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    NSString * str = [NSString stringWithFormat:@"精度:%f,緯度:%f",location.coordinate.latitude,location.coordinate.longitude];
    NSLog(@"定位到了：%@",str);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
     CLLocation *newLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                
                // 城市
                NSString *city = placemark.locality;
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                
                if (! city) {
                    // 6
                    city = placemark.administrativeArea;
                }
                self.currentCity = city;
                [user setObject:self.currentCity forKey:@"MyCity"];
                [user synchronize];
            } else if ([placemarks count] == 0) {
//                [TSMessage showNotificationWithTitle:@"GPS故障"
//                                            subtitle:@"定位城市失败"
//                                                type:TSMessageNotificationTypeError];
           
            }
        } else {
//            [TSMessage showNotificationWithTitle:@"網路錯誤"
//                                        subtitle:@"請檢查網路"
//                                            type:TSMessageNotificationTypeError];
        }
    }];
}
/**不能獲取新位置時調用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失敗");
}

@end
