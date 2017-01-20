//
//  MainView.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/12/8.
//  Copyright © 2016年 LiChen. All rights reserved.
//
#import "CityModel.h"
#import "MainView.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import<CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "M13ProgressViewImage.h"
#import "SVProgressHUD.h"
#import "OBShapedButton.h"

@import Firebase;
@interface MainView () <CLLocationManagerDelegate,UNUserNotificationCenterDelegate>
{
    NSMutableArray * completeArr;
    CityModel * cityModel;
    CLLocationManager * locationManager;
    NSUserDefaults * user;
    NSString *city;
    int x;
    }
@property (nonatomic, retain)IBOutlet  M13ProgressViewImage *progressView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UILabel *completeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    x=0;
    [self setupLeftMenuButton];
    user = [NSUserDefaults standardUserDefaults];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.pausesLocationUpdatesAutomatically=NO;
    [locationManager requestWhenInUseAuthorization]; //
    locationManager.delegate = self; //設置代理
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter=300;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self checkSwitch];
    [self loadCityData];
    [self setSwitch];
    [self setTaiwanBar];
   
    
}
-(void)setTaiwanBar{
   
    [_progressView setProgressImage:[UIImage imageNamed:@"test123.png"]];
    CGFloat progressValue = [[CityModel computePercentage:x-1] floatValue]/100;
    [_progressView setProgress:progressValue animated:YES];
}
-(void)loadCityData{
    cityModel = [[CityModel alloc] init];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains
                          (NSDocumentDirectory,NSUserDomainMask, YES)
                          objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TaiwanMap.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"TaiwanMap" ofType:@"plist"];
        cityModel.cityData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }else{
        cityModel.cityData =[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
   [self upDateCompleteLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)mainSwitch:(UISwitch*)sender {
    if (sender.on) {
        [user setBool:YES forKey:@"CheckSwitch"];
        if(![CLLocationManager locationServicesEnabled]){
            UIAlertController * alertController=[self addAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        [locationManager startUpdatingLocation];//開始調用地理位置
       [SVProgressHUD showInfoWithStatus:@"開啟定位"];
        }else{
        [user setBool:NO forKey:@"CheckSwitch"];
            [locationManager stopUpdatingLocation];
        [SVProgressHUD showInfoWithStatus:@"關閉定位"];
        }
    [user synchronize];
}

-(void)checkSwitch{
    if ([user boolForKey:@"CheckSwitch"]==YES) {
        if(![CLLocationManager locationServicesEnabled]){
           UIAlertController*alertController=[self addAlert];
        [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        _mySwitch.on=YES;
        [locationManager startUpdatingLocation];
    }else{
        _mySwitch.on=NO;
        [locationManager stopUpdatingLocation];
    }
}
-(void)upDateCompleteLabel{
    x=[CityModel upDateComplete:cityModel.cityData];
    self.completeLabel.text=[NSString stringWithFormat:@"Complete\n%i/366",x-1];
    _percentageLabel.text=[CityModel computePercentage:x-1];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    UIAlertController*alertController=[self addAlert];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [locationManager requestWhenInUseAuthorization];
            NSLog(@"未詢問用戶是否授權");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"未授權 家長監控");
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"未授權 用戶拒絕");
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Safe ~~~~~~~同意授權always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Safe ~~~~~~~同意授權When I use");
            break;
        default:
            break;
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

/*獲取新位置時調用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                city = placemark.locality;
                NSString*postalCode=placemark.postalCode;
                if (! city) {
                    city = placemark.administrativeArea;
                }
                //check nowCity and nextCity
                if ([cityModel.cityData objectForKey:@"nowLocal"]!=postalCode) {
                     [cityModel.cityData setValue:postalCode forKey:@"nowLocal"];
                    NSString *saveRootPath = [NSSearchPathForDirectoriesInDomains
                                              (NSDocumentDirectory,NSUserDomainMask, YES)
                                              objectAtIndex:0];
                    NSString *savePath = [saveRootPath stringByAppendingPathComponent:@"TaiwanMap.plist"];
                    NSString *savePath2 = [saveRootPath stringByAppendingPathComponent:@"nowLocal.plist"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
                    if ([[cityModel.cityData objectForKey:postalCode] boolValue]==NO) {
                        [self registerNotification:1];
                    }
                    [cityModel.cityMyRoad setObject:strDate forKey:placemark.locality];
                    [cityModel.cityData setObject:[NSNumber numberWithBool:YES] forKey:postalCode];
                    [cityModel.cityMyRoad writeToFile:savePath2 atomically:YES];
                    [cityModel.cityData writeToFile:savePath atomically:YES];
                    [self upDateCompleteLabel];
                }
                
            }
        }
    }];
}
/**不能獲取新位置時調用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失敗");
}
-(void)registerNotification:(NSInteger )alerTime{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"你到新地方了!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey: city
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:alerTime repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你到新地方了！" message: city preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
   
}
-(void)setSwitch{
    self.mySwitch.onTintColor = [UIColor colorWithRed:2.0/255 green:223.0/255 blue:130.0/255 alpha:1];
    self.mySwitch.tintColor = [UIColor colorWithRed:255.0/255 green:81.0/255 blue:81.0/255 alpha:1];
   self.mySwitch.layer.cornerRadius = 16;
    self.mySwitch.backgroundColor = [UIColor colorWithRed:255.0/255 green:81.0/255 blue:81.0/255 alpha:1];
}
-(UIAlertController*)addAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"您未開啟定位功能" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        return ;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"設定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    return alertController;
}
@end
