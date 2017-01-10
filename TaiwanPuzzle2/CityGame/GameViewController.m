//
//  GameViewController.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/6.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "GameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "CityGame.h"
#import "CityModel.h"
@import Firebase;
@interface GameViewController ()
@property (strong, nonatomic) IBOutlet SKView *myGameView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CityGame *scene = (CityGame *)[SKScene nodeWithFileNamed:@"CityGame"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [_myGameView presentScene:scene];
    _myGameView.showsFPS = NO;
    _myGameView.showsNodeCount = NO;
    
    
    
    
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
