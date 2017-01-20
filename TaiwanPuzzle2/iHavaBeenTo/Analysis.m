//
//  Analysis.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/13.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "Analysis.h"
#import "CityModel.h"
#import "AnalysisCell.h"
#import "SVProgressHUD.h"
#import "AnalysisCity.h"
@import Firebase;
@interface Analysis ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CityModel * cityModel;
    NSArray * cityImgArr;
    NSArray * cityTitleArr;
    NSString * iphone;
    AnalysisCell * cell2;
    CGFloat width;
    CGFloat height;
    bool i;
}
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
@implementation Analysis
-(void) viewDidAppear:(BOOL)animated{
    cityModel=[[CityModel alloc] init];
    NSMutableDictionary*test =  cityModel.cityData;
    cityModel.cityComlpeteArr=(NSArray*)[CityModel computeCity:test];
    [self.collectionView reloadData];
}
- (IBAction)button2:(UIBarButtonItem *)sender {
    x=[CityModel upDateComplete:cityModel.cityData];
    self.ref = [[FIRDatabase database] reference];
    [SVProgressHUD show];
  
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"CheckSwitch2"] boolValue]==YES) {
        NSString *key = [user objectForKey:@"MyName"];
        NSDictionary *post = @{@"City":[NSNumber numberWithInt:x-1]};
        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/Rank/%@/", key]: post};
        [_ref updateChildValues:childUpdates];
    }

    FIRDatabaseQuery *queryOrderedByChild = [[self.ref child:@"Rank"]queryOrderedByValue];
    [queryOrderedByChild observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableDictionary * dict = snapshot.value;
        NSMutableArray * test = [[NSMutableArray alloc] init];
        NSArray * allKeys = [dict allKeys];
        for (int ii=0; ii<allKeys.count; ii++) {
          NSString * newCity = [[dict objectForKey:allKeys[ii]] objectForKey:@"City"];
            [test addObject:@{@"City":newCity,@"Name":allKeys[ii]}];
        }
        NSSortDescriptor *sort;
        sort = [NSSortDescriptor sortDescriptorWithKey:@"City" ascending:NO];
        [test sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        cityModel.rankArray = test;
        [SVProgressHUD dismiss];
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CityRank"];
        [self.navigationController pushViewController:vc animated:YES];
    } withCancelBlock:^(NSError * _Nonnull error) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[FIRDatabase database] reference];
    [self addCityArray];
    [self.collectionView setBackgroundColor:[UIColor lightGrayColor]];
    iphone=@"AnalysisCell";
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self checkPhoneSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 19;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(width,height);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,12,0,12);
    
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row % 2 != 0) {
            cell.transform = CGAffineTransformTranslate(cell.transform,self.view.frame.size.width/2, 10);
        }else{
            cell.transform = CGAffineTransformTranslate(cell.transform,-self.view.frame.size.width/2, -10);
        }
        cell.alpha = 0.0;
        [UIView animateWithDuration:0.7 animations:^{
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (i==0) {
        cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:iphone forIndexPath:indexPath];
    }
    else{
        [collectionView registerNib:[UINib nibWithNibName:iphone bundle:nil] forCellWithReuseIdentifier:iphone];
        cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:iphone forIndexPath:indexPath];
    }
    cell2.imageView.image=[UIImage imageNamed:cityImgArr[indexPath.row]];
    cell2.cityTitle.text = cityTitleArr[indexPath.row];
    cell2.complete.text  = cityModel.cityComlpeteArr[indexPath.row];
    [cell2 setBackgroundColor:[UIColor whiteColor]];
    cell2.layer.borderWidth=2.5f;
    cell2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell2.layer.cornerRadius = 10;
    return cell2;
}
//點擊觸發方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    AnalysisCity * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AnalysisCity"];
    switch (indexPath.row) {
        case 0:{
        //台北市
        vc.cityName=@"台北市";
        vc.cityArray=@[@"100",@"103",@"104",@"105",@"106",@"108",@"110",@"111",@"112",@"114",@"115",@"116"];
            break;
        }
        case 1:{
            vc.cityName=@"新北市";
            vc.cityArray=@[@"207",@"208",@"220",@"221",@"222",@"223",@"224",@"226",@"227",@"228",@"231",@"232",@"233",@"234",@"235",@"236",@"237",@"238",@"239",@"241",@"242",@"243",@"244",@"247",@"248",@"249",@"251",@"252",@"253"];
        }
            break;
        case 2:{
            vc.cityName=@"基隆市";
            vc.cityArray=@[@"200",@"201",@"202",@"203",@"204",@"205",@"206"];
        }
            break;
        case 3:{
            vc.cityName=@"桃園市";
        vc.cityArray=@[@"320",@"324",@"325",@"326",@"327",@"328",@"330",@"333",@"334",@"335",@"336",@"337",@"338"];
        }
            break;
        case 4:{
            vc.cityName=@"新竹縣市";
            vc.cityArray=@[@"300",@"302",@"303",@"304",@"305",@"306",@"307",@"308",@"310",@"311",@"312",@"313",@"314",@"315"];
        }
            
            break;
        case 5:{
            vc.cityName=@"苗栗縣";
            vc.cityArray=@[@"350",@"351",@"352",@"353",@"354",@"356",@"357",@"358",@"360",@"361",@"362",@"363",@"364",@"365",@"366",@"367",@"368",@"369"];
        }
            
            break;
        case 6:{
            vc.cityName=@"台中市";
            vc.cityArray=@[@"400",@"401",@"402",@"403",@"404",@"406",@"407",@"408",@"411",@"412",@"413",@"414",@"420",@"421",@"422",@"423",@"424",@"426",@"427",@"428",@"429",@"432",@"433",@"434",@"435",@"436",@"437",@"438",@"439"];
        }
            
            break;
        case 7:{
            vc.cityName=@"南投縣";
            vc.cityArray=@[@"540",@"541",@"542",@"544",@"545",@"546",@"551",@"552",@"553",@"555",@"556",@"557",@"558"];
        }
            
            break;
        case 8:{
            
            vc.cityName=@"彰化縣";
            vc.cityArray=@[@"500",@"502",@"503",@"504",@"505",@"506",@"507",@"508",@"509",@"510",@"511",@"512",@"513",@"514",@"515",@"516",@"520",@"521",@"522",@"523",@"524",@"525",@"526",@"527",@"528",@"530"];
        }
            
            break;
        case 9:{
            vc.cityName=@"雲林縣";
            vc.cityArray=@[@"630",@"631",@"632",@"633",@"634",@"635",@"636",@"637",@"638",@"640",@"643",@"646",@"647",@"648",@"649",@"651",@"652",@"653",@"654",@"655"];
        }
            
            break;
        case 10:{
            vc.cityName=@"嘉義縣市";
            vc.cityArray=@[@"600",@"602",@"603",@"604",@"605",@"606",@"607",@"608",@"611",@"612",@"613",@"614",@"615",@"616",@"621",@"622",@"623",@"624",@"625"];
        }
            
            break;
        case 11:{
            vc.cityName=@"台南市";
            vc.cityArray=@[@"700",@"701",@"702",@"704",@"708",@"709",@"710",@"711",@"712",@"713",@"714",@"715",@"716",@"717",@"718",@"719",@"720",@"721",@"722",@"723",@"724",@"725",@"726",@"727",@"730",@"731",@"732",@"733",@"734",@"735",@"736",@"737",@"741",@"742",@"743",@"744",@"745"];
        }
            
            break;
        case 12:{
            vc.cityName=@"高雄市";
            vc.cityArray=@[@"800",@"801",@"802",@"803",@"804",@"805",@"806",@"807",@"811",@"812",@"813",@"814",@"815",@"820",@"821",@"822",@"823",@"824",@"825",@"826",@"827",@"828",@"829",@"830",@"831",@"832",@"833",@"840",@"842",@"843",@"844",@"845",@"846",@"847",@"848",@"849",@"851",@"852"];
        }
            
            break;
        case 13:{
            vc.cityName=@"屏東縣";
            vc.cityArray=@[@"900",@"901",@"902",@"903",@"904",@"905",@"906",@"907",@"908",@"909",@"911",@"912",@"913",@"920",@"921",@"922",@"923",@"924",@"925",@"926",@"927",@"928",@"929",@"931",@"932",@"940",@"941",@"942",@"943",@"944",@"945",@"946",@"947"];
        }
            
            break;
        case 14:{
            vc.cityName=@"台東縣";
            vc.cityArray=@[@"950",@"951",@"952",@"953",@"954",@"955",@"956",@"957",@"958",@"959",@"961",@"962",@"963",@"964",@"965",@"966"];
        }
            
            break;
        case 15:{
            vc.cityName=@"花蓮縣";
            vc.cityArray=@[@"970",@"971",@"972",@"973",@"974",@"975",@"976",@"977",@"978",@"979",@"981",@"982",@"983"];
        }
            
            break;
        case 16:{
            vc.cityName=@"宜蘭縣";
            vc.cityArray=@[@"260",@"261",@"262",@"263",@"264",@"265",@"266",@"267",@"268",@"269",@"270",@"272"];
        }
            
            break;
        case 17:{
            vc.cityName=@"澎湖縣";
            vc.cityArray=@[@"880",@"881",@"882",@"883",@"884",@"885"];
        }
            
            break;
        case 18:{
            vc.cityName=@"金門縣";
            vc.cityArray=@[@"890",@"891",@"892",@"893",@"894",@"896"];
        }
            
            break;
        case 19:{
            vc.cityName=@"連江縣";
            vc.cityArray=@[@"209",@"210",@"211",@"212"];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)changeView:(id)sender {
    if (i==NO) {
        i = YES;
        [self checkPhoneSize];
        
    }
    else if(i==YES){
        i=NO;
        [self checkPhoneSize];
    }
    [_collectionView reloadData];
}
-(void)checkPhoneSize{
    if (i==NO) {
        if (self.view.frame.size.width==320) {
            width=140;
            height=160;
        }
        else if(self.view.frame.size.width==375){
            width=170;
            height=180;
        }
        else if(self.view.frame.size.width==414){
            width=190;
            height=200;
        }
         iphone = @"AnalysisCell";
    }
    else if(i==YES){
        if (self.view.frame.size.width==320) {
            width=320;
            height=80;
        }
        else if(self.view.frame.size.width==375){
            width=375;
            height=80;
        }
        else if(self.view.frame.size.width==414){
            width=414;
            height=80;
        }
        iphone = @"AnalysisTableCell";
    }
}
-(void)addCityArray{
    cityImgArr = @[@"taipei.jpg",@"newTaipei.jpg",@"kilong.jpg",@"taoyuan.jpg",@"hsinChu.jpg",@"miaoLi.jpg",@"taiChug.jpg",@"nantou.jpg",@"chanHua.jpg",@"yunLin.jpg",@"jiaYi.jpg",@"taiNan.jpg",@"kaoShun.jpg",@"pinTung.jpg",@"taiTung.jpg",@"huaLian.jpg",@"eLan.jpg",@"ponHu.jpg",@"kingMan.jpg",@"kingMan.jpg"];
    cityTitleArr = @[@"台北市",@"新北市",@"基隆市",@"桃園市",@"新竹縣市",@"苗栗縣",@"台中市",@"南投縣",@"彰化縣",@"雲林縣",@"嘉義縣市",@"台南市",@"高雄市",@"屏東縣",@"台東縣",@"花蓮縣",@"宜蘭縣",@"澎湖縣",@"金門縣",@"連江縣"];
//    cityCompleteArr = cityModel.cityComlpeteArr;
 
}
@end
