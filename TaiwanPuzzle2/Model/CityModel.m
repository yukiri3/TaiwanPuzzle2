//
//  CityModel.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/12/9.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}
+(NSArray*)computeCity: (NSMutableDictionary *)cityData{
    NSArray * dict = [[NSArray alloc] init];
    int a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,j=0,k=0,l=0,m=0,n=0,o=0,p=0,q=0,r=0,s=0,t=0,u=0;
    NSArray * taipei = @[@"100",@"103",@"104",@"105",@"106",@"108",@"110",@"111",@"112",@"114",@"115",@"116"];
    NSArray * taipeiNew =@[@"207",@"208",@"220",@"221",@"222",@"223",@"224",@"226",@"227",@"228",@"231",@"232",@"233",@"234",@"235",@"236",@"237",@"238",@"239",@"241",@"242",@"243",@"244",@"247",@"248",@"249",@"251",@"252",@"253"];
    NSArray*kilong = @[@"200",@"201",@"202",@"203",@"204",@"205",@"206"];
    NSArray * taoyuan =@[@"320",@"324",@"325",@"326",@"327",@"328",@"330",@"333",@"334",@"335",@"336",@"337",@"338"];
    NSArray * hsinchu =@[@"300",@"302",@"303",@"304",@"305",@"306",@"307",@"308",@"310",@"311",@"312",@"313",@"314",@"315"];
    NSArray * miaoli =@[@"350",@"351",@"352",@"353",@"354",@"356",@"357",@"358",@"360",@"361",@"362",@"363",@"364",@"365",@"366",@"367",@"368",@"369"];
    NSArray*taichung =@[@"400",@"401",@"402",@"403",@"404",@"406",@"407",@"408",@"411",@"412",@"413",@"414",@"420",@"421",@"422",@"423",@"424",@"426",@"427",@"428",@"429",@"432",@"433",@"434",@"435",@"436",@"437",@"438",@"439"];
    NSArray*nantau=@[@"540",@"541",@"542",@"544",@"545",@"546",@"551",@"552",@"553",@"555",@"556",@"557",@"558"];
    NSArray * changhua = @[@"500",@"502",@"503",@"504",@"505",@"506",@"507",@"508",@"509",@"510",@"511",@"512",@"513",@"514",@"515",@"516",@"520",@"521",@"522",@"523",@"524",@"525",@"526",@"527",@"528",@"530"];
    NSArray*yinlin=@[@"630",@"631",@"632",@"633",@"634",@"635",@"636",@"637",@"638",@"640",@"643",@"646",@"647",@"648",@"649",@"651",@"652",@"653",@"654",@"655"];
    NSArray * chiayi =@[@"600",@"602",@"603",@"604",@"605",@"606",@"607",@"608",@"611",@"612",@"613",@"614",@"615",@"616",@"621",@"622",@"623",@"624",@"625"];
    NSArray*tainan=@[@"700",@"701",@"702",@"704",@"708",@"709",@"710",@"711",@"712",@"713",@"714",@"715",@"716",@"717",@"718",@"719",@"720",@"721",@"722",@"723",@"724",@"725",@"726",@"727",@"730",@"731",@"732",@"733",@"734",@"735",@"736",@"737",@"741",@"742",@"743",@"744",@"745"];
    NSArray*kaohsiung=@[@"800",@"801",@"802",@"803",@"804",@"805",@"806",@"807",@"811",@"812",@"813",@"814",@"815",@"820",@"821",@"822",@"823",@"824",@"825",@"826",@"827",@"828",@"829",@"830",@"831",@"832",@"833",@"840",@"842",@"843",@"844",@"845",@"846",@"847",@"848",@"849",@"851",@"852"];
    NSArray * pingtung=@[@"900",@"901",@"902",@"903",@"904",@"905",@"906",@"907",@"908",@"909",@"911",@"912",@"913",@"920",@"921",@"922",@"923",@"924",@"925",@"926",@"927",@"928",@"929",@"931",@"932",@"940",@"941",@"942",@"943",@"944",@"945",@"946",@"947"];
    NSArray*taitung=@[@"950",@"951",@"952",@"953",@"954",@"955",@"956",@"957",@"958",@"959",@"961",@"962",@"963",@"964",@"965",@"966"];
    NSArray*hualien=@[@"970",@"971",@"972",@"973",@"974",@"975",@"976",@"977",@"978",@"979",@"981",@"982",@"983"];
        NSArray*yilan=@[@"260",@"261",@"262",@"263",@"264",@"265",@"266",@"267",@"268",@"269",@"270",@"272"];
        NSArray*penghu=@[@"880",@"881",@"882",@"883",@"884",@"885"];
        NSArray*kingman=@[@"890",@"891",@"892",@"893",@"894",@"896"];
        NSArray * Lianjiang =  @[@"209",@"210",@"211",@"212"];
    for (id object in cityData) {
        if ([object isEqualToString:@"nowLocal"]) {
        }
        else if ([[cityData objectForKey:object] boolValue]==YES) {
            if ([taipei indexOfObject:object] != NSNotFound) {
                    a++;
                }
               else if ([taipeiNew indexOfObject:object] != NSNotFound) {
                    b++;
                }
               else if ([kilong indexOfObject:object] != NSNotFound) {
                    c++;
                }
              else  if ([taoyuan indexOfObject:object] != NSNotFound) {
                    d++;
                }
               else if ([hsinchu indexOfObject:object] != NSNotFound) {
                    e++;
                }
              else  if ([miaoli indexOfObject:object] != NSNotFound) {
                    f++;
                }
              else  if ([taichung indexOfObject:object] != NSNotFound) {
                    g++;
                }
               else if ([nantau indexOfObject:object] != NSNotFound) {
                    h++;
                }
             else   if ([changhua indexOfObject:object] != NSNotFound) {
                    j++;
                }
               else if ([yinlin indexOfObject:object] != NSNotFound) {
                    k++;
                }
               else if ([chiayi indexOfObject:object] != NSNotFound) {
                    l++;
                }
               else if ([tainan indexOfObject:object] != NSNotFound) {
                    m++;
                }
               else if ([kaohsiung indexOfObject:object] != NSNotFound) {
                    n++;
                }
               else if ([pingtung indexOfObject:object] != NSNotFound) {
                    o++;
                }
              else  if ([taitung indexOfObject:object] != NSNotFound) {
                    p++;
                }
              else  if ([hualien indexOfObject:object] != NSNotFound) {
                    q++;
                }
              else  if ([yilan indexOfObject:object] != NSNotFound) {
                    r++;
                }
              else  if ([penghu indexOfObject:object] != NSNotFound) {
                    s++;
                }
            else  if ([kingman indexOfObject:object] != NSNotFound) {
                    t++;
                }
            else  if ([Lianjiang indexOfObject:object] != NSNotFound) {
                u++;
            }
        }
    }
    dict=@[[NSString stringWithFormat:@"%i/12",a],
           [NSString stringWithFormat:@"%i/29",b],
           [NSString stringWithFormat:@"%i/7",c],
           [NSString stringWithFormat:@"%i/13",d],
           [NSString stringWithFormat:@"%i/14",e],
           [NSString stringWithFormat:@"%i/18",f],
           [NSString stringWithFormat:@"%i/29",g],
           [NSString stringWithFormat:@"%i/13",h],
           [NSString stringWithFormat:@"%i/26",j],
           [NSString stringWithFormat:@"%i/20",k],
           [NSString stringWithFormat:@"%i/19",l],
           [NSString stringWithFormat:@"%i/37",m],
           [NSString stringWithFormat:@"%i/38",n],
           [NSString stringWithFormat:@"%i/33",o],
           [NSString stringWithFormat:@"%i/16",p],
           [NSString stringWithFormat:@"%i/13",q],
           [NSString stringWithFormat:@"%i/12",r],
           [NSString stringWithFormat:@"%i/6",s],
           [NSString stringWithFormat:@"%i/6",t],
           [NSString stringWithFormat:@"%i/4",u]];
   
    return dict;
}
+(NSString*)postCodeToCity: (NSInteger)postcode{
    NSDictionary * dict = [[NSDictionary alloc] init];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains
                          (NSDocumentDirectory,NSUserDomainMask, YES)
                          objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"PostCode2.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"PostCode2" ofType:@"plist"];
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }else{
        dict =[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    NSString * string = [dict objectForKey:[NSString stringWithFormat:@"%ld",postcode]];
    
    
    return string;
}
+(NSString*)computePercentage: (int)city{
    float x=city*0.273224043716;
    NSString * string = [NSString stringWithFormat:@"%.1f %%",x];
    return string;
}
+(int)upDateComplete: (NSMutableDictionary*)dict{
    int x=0;
    NSEnumerator* enumeratorKey = [dict keyEnumerator];
    for (id key in enumeratorKey) {
        if ([[dict objectForKey:key] boolValue]==YES) {
            x++;
        }
    }
    return x;
}
@end
