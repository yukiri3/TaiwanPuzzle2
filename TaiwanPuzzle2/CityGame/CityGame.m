//
//  CityGame.m
//  TaiwanPuzzle2
//
//  Created by user on 2017/1/6.
//  Copyright © 2017年 LiChen. All rights reserved.
//

#import "CityGame.h"
#import "CityModel.h"
@implementation CityGame
{
    SKShapeNode *_spinnyNode;
    SKSpriteNode*winBackground;//勝利背景黑畫面
    SKLabelNode * timeLabel;//時間Label
    NSString * answer;//答案
    SKLabelNode * question;// 問題Label
    SKSpriteNode * option1;//選項1
    SKSpriteNode * option2;//選項2
    SKSpriteNode * option3;//選項3
    SKSpriteNode * option4;//選項4
    SKLabelNode * option1Label;// 選項1Label
    SKLabelNode * option2Label;// 選項2Label
    SKLabelNode * option3Label;// 選項3Label
    SKLabelNode * option4Label;// 選項4Label
    SKSpriteNode * resultBg;//過場背景
    SKSpriteNode * result;//答題結果對
    SKSpriteNode * wrong;//答題結果錯
    SKAction * changeColor;//換顏色
    SKAction * perfectImg;//答對的
    SKAction * failImg;//答錯的
    SKAction * failAns;//答錯的答對的
    SKSpriteNode * winnerBG;//閃光背景圖
    SKSpriteNode * winnerHappy;//過關高興圖
    SKSpriteNode * winnerSad;//過關難過圖
    SKSpriteNode * winnerBBG;//過關背景
    NSMutableArray * questionArray;//問題集
    SKAudioNode*sayYes;//答對音效
    SKAudioNode*sayNo;//答錯音效
    SKAudioNode*backgroundSound;
    SKAudioNode*result1;
    SKAudioNode*resultUp;
    int i;//紀錄目前題數
    int time;//時間
    int y;//指針倒數
    int timeGG;//時間倒數
    int sum;//記答對題數
    bool canTouch; //判斷是否可點擊了
 
}
- (void)didMoveToView:(SKView *)view {
    questionArray = [[NSMutableArray alloc] init];
    CityModel * cityModel = [[CityModel alloc] init];
    NSArray * allKeys = [cityModel.gameDict allKeys];
    for (int k=1; k<=[allKeys count]; k++) {
        [questionArray addObject:[cityModel.gameDict objectForKey:allKeys[k-1]]];
    }
    sayYes = [[SKAudioNode alloc] initWithFileNamed:@"Yes.mp3"];
    sayYes.autoplayLooped = false;
    [self addChild:sayYes];
    sayNo = [[SKAudioNode alloc] initWithFileNamed:@"No.mp3"];
    sayNo.autoplayLooped = false;
    [self addChild:sayNo];
    backgroundSound = [[SKAudioNode alloc] initWithFileNamed:@"BackgroundSound.mp3"];
    backgroundSound.autoplayLooped = false;
    [self addChild:backgroundSound];
    result1 = [[SKAudioNode alloc] initWithFileNamed:@"Result.mp3"];
    result1.autoplayLooped = false;
    [self addChild:result1];
    resultUp = [[SKAudioNode alloc] initWithFileNamed:@"ResultUp.mp3"];
    resultUp.autoplayLooped = false;
    [self addChild:resultUp];
    i = 0;
    timeGG = 23;
    canTouch = YES;
    NSMutableArray * perfectImgArr = [NSMutableArray arrayWithCapacity:2];
    SKTexture *texture = [SKTexture textureWithImageNamed:@"button_game02_question_correct.png"];
    SKTexture *texture2 =[SKTexture textureWithImageNamed:@"button_game02_question.png"];
    [perfectImgArr addObject: texture];
    [perfectImgArr addObject:texture2];
    perfectImg = [SKAction animateWithTextures:perfectImgArr timePerFrame:1.5];
    NSMutableArray * failImgArr = [NSMutableArray arrayWithCapacity:2];
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"button_game02_question_wrong_frame.png"];
    SKTexture *texture4 =[SKTexture textureWithImageNamed:@"button_game02_question.png"];
    [failImgArr addObject: texture3];
    [failImgArr addObject:texture4];
    failImg = [SKAction animateWithTextures:failImgArr timePerFrame:1.5];
    NSMutableArray * failAnsArr = [NSMutableArray arrayWithCapacity:2];
    SKTexture *texture5 = [SKTexture textureWithImageNamed:@"button_game02_question_wrong.png"];
    SKTexture *texture6 =[SKTexture textureWithImageNamed:@"button_game02_question.png"];
    [failAnsArr addObject: texture5];
    [failAnsArr addObject:texture6];
    failAns = [SKAction animateWithTextures:failAnsArr timePerFrame:1.5];
    changeColor = [SKAction colorizeWithColor:[UIColor colorWithRed:23.0f/255.0f green:141.0f/255.0f blue:173.0f/255.0f alpha:1]
                             colorBlendFactor:1 duration:0.5];
    SKAction*changeColor2 = [SKAction colorizeWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1]
                                       colorBlendFactor:1 duration:0.25];
    changeColor = [SKAction sequence:@[changeColor,changeColor2,changeColor,changeColor2]];
    winnerBG=(SKSpriteNode*)[self childNodeWithName:@"winBg"];
    winnerHappy=(SKSpriteNode*)[self childNodeWithName:@"happy"];
    winnerSad=(SKSpriteNode*)[self childNodeWithName:@"sad"];
    winnerBBG=(SKSpriteNode*)[self childNodeWithName:@"winnerBBG"];
    winnerBBG.hidden=YES;
    winnerSad.hidden=YES;
    winnerBG.hidden=YES;
    winnerHappy.hidden=YES;
    resultBg = (SKSpriteNode*)[self childNodeWithName:@"resultBg"];
    result = (SKSpriteNode*)[self childNodeWithName:@"result"];
    wrong = (SKSpriteNode*)[self childNodeWithName:@"wrong"];
    resultBg.hidden = YES;
    result.hidden = YES;
    wrong.hidden = YES;
    question = (SKLabelNode *)[self childNodeWithName:@"question"];
    option1Label = (SKLabelNode *)[self childNodeWithName:@"option1Label"];
    option2Label = (SKLabelNode *)[self childNodeWithName:@"option2Label"];
    option3Label = (SKLabelNode *)[self childNodeWithName:@"option3Label"];
    option4Label = (SKLabelNode *)[self childNodeWithName:@"option4Label"];
    option1 = (SKSpriteNode *)[self childNodeWithName:@"option1"];
    option2 = (SKSpriteNode *)[self childNodeWithName:@"option2"];
    option3 = (SKSpriteNode *)[self childNodeWithName:@"option3"];
    option4 = (SKSpriteNode *)[self childNodeWithName:@"option4"];
    [self startTheGame];
    
}
-(void)nextTheGame{
    if (questionArray.count==1) {
        [self winner];
        return;
    }
    else{
        [questionArray removeObjectAtIndex:i];
        i=arc4random()%questionArray.count;
        question.text = [questionArray[i] objectForKey:@"question"];
        option1Label.text = [questionArray[i] objectForKey:@"option1"];
        option2Label.text = [questionArray[i] objectForKey:@"option2"];
        option3Label.text = [questionArray[i] objectForKey:@"option3"];
        option4Label.text = [questionArray[i] objectForKey:@"option4"];
        answer = [questionArray[i] objectForKey:@"answer"];
        canTouch = YES;
    }
}
-(void)startTheGame{
    i = arc4random()%10;
    question.text = [questionArray[i] objectForKey:@"question"];
    option1Label.text = [questionArray[i] objectForKey:@"option1"];
    option2Label.text = [questionArray[i] objectForKey:@"option2"];
    option3Label.text = [questionArray[i] objectForKey:@"option3"];
    option4Label.text = [questionArray[i] objectForKey:@"option4"];
    
    answer = [questionArray[i] objectForKey:@"answer"];
    [self timeOver];
    [backgroundSound runAction:[SKAction play]];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint touchLocation = [t locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        if (canTouch == YES) {
            if (node==option1||node==option1Label) {
                if (option1Label.text == answer) {
                    [self answerPerfect];
                    [option1 runAction:perfectImg];
                    sum++;
                    [sayYes runAction:[SKAction play]];
                }
                else if(option2Label.text == answer){
                    [option1 runAction:failImg];
                    [option2 runAction:failAns];
                    [option2Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                    
                }
                else if(option3Label.text == answer){
                    [option1 runAction:failImg];
                    [option3 runAction:failAns];
                    [option3Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option4Label.text == answer){
                    [option1 runAction:failImg];
                    [option4 runAction:failAns];
                    [option4Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
            }
            else if (node==option2||node==option2Label) {
                if (option2Label.text == answer) {
                    [self answerPerfect];
                    [option2 runAction:perfectImg];
                    sum++;
                    [sayYes runAction:[SKAction play]];
                }
                else if(option1Label.text == answer){
                    [option2 runAction:failImg];
                    [option1 runAction:failAns];
                    [option1Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option3Label.text == answer){
                    [option2 runAction:failImg];
                    [option3 runAction:failAns];
                    [option3Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option4Label.text == answer){
                    [option2 runAction:failImg];
                    [option4 runAction:failAns];
                    [option4Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                
            }
            else  if (node==option3||node==option3Label) {
                if (option3Label.text == answer) {
                    [self answerPerfect];
                    [option3 runAction:perfectImg];
                    sum++;
                    [sayYes runAction:[SKAction play]];
                }
                else if(option2Label.text == answer){
                    [option3 runAction:failImg];
                    [option2 runAction:failAns];
                    [option2Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option1Label.text == answer){
                    [option3 runAction:failImg];
                    [option1 runAction:failAns];
                    [option1Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option4Label.text == answer){
                    [option3 runAction:failImg];
                    [option4 runAction:failAns];
                    [option4Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
            }
            else if (node==option4||node==option4Label) {
                if (option4Label.text == answer) {
                    [self answerPerfect];
                    [option4 runAction:perfectImg];
                    sum++;
                    [sayYes runAction:[SKAction play]];
                }
                else if(option2Label.text == answer){
                    [option4 runAction:failImg];
                    [option2 runAction:failAns];
                    [option2Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option3Label.text == answer){
                    [option4 runAction:failImg];
                    [option3 runAction:failAns];
                    [option3Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                else if(option1Label.text == answer){
                    [option4 runAction:failImg];
                    [option1 runAction:failAns];
                    [option1Label runAction:changeColor];
                    [self answerFail];
                    [sayNo runAction:[SKAction play]];
                }
                
            }
            
        }

    }
}

-(void)answerPerfect{
    SKAction*fade = [SKAction fadeInWithDuration:1.5];
    SKAction * unhide = [SKAction unhide];
    SKAction * hide = [SKAction hide];
    fade = [SKAction group:@[unhide,fade]];
    fade = [SKAction sequence:@[fade,hide]];
    
    [result runAction:fade];
    [resultBg runAction:fade];
    canTouch = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextTheGame) userInfo:nil repeats:NO];
}
-(void)answerFail{
    SKAction*fade = [SKAction fadeInWithDuration:1.5];
    SKAction * unhide = [SKAction unhide];
    SKAction * hide = [SKAction hide];
    fade = [SKAction group:@[unhide,fade]];
    fade = [SKAction sequence:@[fade,hide]];
    [wrong runAction:fade];
    [resultBg runAction:fade];
    canTouch = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextTheGame) userInfo:nil repeats:NO];
    
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

-(void)timeOver{
    y=0;
    timeLabel=(SKLabelNode *)[self childNodeWithName:@"timeLabel"];
    
    timeLabel.text=[NSString stringWithFormat:@"%i",timeGG];
    timeLabel.fontSize = 80.0f;
    
    timeLabel.fontName = @"PingFangSC-Medium";
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeLoad:) userInfo:nil repeats:YES];
    
}
-(void)timeLoad:(NSTimer *)timer{
    
    timeGG--;
    y++;
    NSString * str =[NSString stringWithFormat:@"timeIMG%i",y];
    SKSpriteNode*timeLine = (SKSpriteNode*)[self childNodeWithName:str];
    timeLabel.text=[NSString stringWithFormat:@"%i",timeGG];
    timeLine.hidden =YES;
    if (timeGG == 0 ) {
        [timer invalidate];
        [self winner];
    }
    
}
-(void)winner{
    SKAction * big = [SKAction scaleTo:2.0 duration:1];
    winBackground =(SKSpriteNode*) [self childNodeWithName:@"winBackground"];
    winBackground.hidden = NO;
    if (sum==0) {
        [result1 runAction:[SKAction play]];
        winnerBBG.hidden=NO;
        winnerBG.hidden=NO;
        winnerSad.hidden=NO;
        SKAction * rotate = [SKAction rotateToAngle:20 duration:500];
        SKAction*rotateForever = [SKAction repeatActionForever:rotate];
        [winnerBG runAction:rotateForever];
        CGFloat fSize = 60*1;
        SKLabelNode *loserLabel = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
        loserLabel.text = [NSString stringWithFormat:@"你是廢物"];
        loserLabel.zPosition = 100;
        loserLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loserLabel.fontSize = fSize;
        loserLabel.fontColor = [SKColor colorWithRed:249.0/255 green:167.0/255 blue:25.0/255 alpha:1.0];
        loserLabel.position = CGPointMake(0,-70);
        [self addChild:loserLabel];
        // ourlines
        for (int h=1; h<=4; h++) {
            SKLabelNode *outline = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
            outline.text = [NSString stringWithFormat:@"你是廢物"];
            outline.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            outline.fontSize = fSize;
            outline.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            if (h==1)  outline.position = CGPointMake(0-3,-70+3);
            if (h==2)  outline.position = CGPointMake(0+3,-70+3);
            if (h==3)  outline.position = CGPointMake(0-3,-70-3);
            if (h==4)  outline.position = CGPointMake(0+3,-70-3);
            [self addChild:outline];
            
        }
        
        SKLabelNode *loserLabel2 = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
        loserLabel2.text = @"GG了";
        loserLabel2.zPosition = 100;
        loserLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loserLabel2.fontSize = 60.0f;
        loserLabel2.fontColor = [SKColor colorWithRed:249.0/255 green:167.0/255 blue:25.0/255 alpha:1.0];
        loserLabel2.position = CGPointMake(0,-150);
        [self addChild:loserLabel2];
        
        
        
        // ourlines
        for (int h=1; h<=4; h++) {
            SKLabelNode *outline = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
            outline.text = @"GG了";
            outline.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            outline.fontSize = 60.0f;
            outline.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            if (h==1)  outline.position = CGPointMake(0-3, -150+3);
            if (h==2)  outline.position = CGPointMake(0+3, -150+3);
            if (h==3)  outline.position = CGPointMake(0-3, -150-3);
            if (h==4)  outline.position = CGPointMake(0+3,-150-3);
            [self addChild:outline];
            
        }
    }
    else if (sum != 0){
        [resultUp runAction:[SKAction play]];
        winnerBBG.hidden=NO;
        winnerBG.hidden=NO;
        
        winnerHappy.hidden=NO;
        SKAction * rotate = [SKAction rotateToAngle:20 duration:500];
        SKAction*rotateForever = [SKAction repeatActionForever:rotate];
        [winnerBG runAction:rotateForever];
        CGFloat fSize = 50*1;
        SKLabelNode *loserLabel = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
        loserLabel.text = [NSString stringWithFormat:@"恭喜答對%i題",sum];
        loserLabel.zPosition = 100;
        loserLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loserLabel.fontSize = fSize;
        loserLabel.fontColor = [SKColor colorWithRed:154.0/255 green:154.0/255 blue:154.0/255 alpha:1.0];
        loserLabel.position = CGPointMake(0,-70);
        [self addChild:loserLabel];
        
        
        
        // ourlines
        for (int h=1; h<=4; h++) {
            SKLabelNode *outline = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
            outline.text = [NSString stringWithFormat:@"恭喜答對%i題",sum];
            outline.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            outline.fontSize = fSize;
            outline.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            if (h==1)  outline.position = CGPointMake(0-3,-70+3);
            if (h==2)  outline.position = CGPointMake(0+3,-70+3);
            if (h==3)  outline.position = CGPointMake(0-3,-70-3);
            if (h==4)  outline.position = CGPointMake(0+3,-70-3);
            [self addChild:outline];
            
        }
        
        SKLabelNode *loserLabel2 = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
        loserLabel2.text = @"太神拉";
        loserLabel2.zPosition = 100;
        loserLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loserLabel2.fontSize = 60.0f;
        loserLabel2.fontColor = [SKColor colorWithRed:249.0/255 green:167.0/255 blue:25.0/255 alpha:1.0];
        loserLabel2.position = CGPointMake(-50,-150);
        [self addChild:loserLabel2];
        
        
        
        // ourlines
        for (int h=1; h<=4; h++) {
            SKLabelNode *outline = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
            outline.text = @"太神拉";
            outline.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            outline.fontSize = 60.0f;
            outline.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            if (h==1)  outline.position = CGPointMake(-50-2, -150+2);
            if (h==2)  outline.position = CGPointMake(-50+2, -150+2);
            if (h==3)  outline.position = CGPointMake(-50-2, -150-2);
            if (h==4)  outline.position = CGPointMake(-50+2,-150-2);
            [self addChild:outline];
            
        }
        
        SKLabelNode *loserLabel3 = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
        loserLabel3.text = @"ininder";
        loserLabel3.zPosition = 100;
        loserLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        loserLabel3.fontSize = 50.0f;
        loserLabel3.fontColor = [SKColor colorWithRed:249.0/255 green:167.0/255 blue:25.0/255 alpha:1.0];
        loserLabel3.position = CGPointMake(170,-360);
        [self addChild:loserLabel3];
        
        
        
        // ourlines
        for (int h=1; h<=4; h++) {
            SKLabelNode *outline = [SKLabelNode labelNodeWithFontNamed:@"PingFangSC-Semibold"];
            outline.text = @"ininder";
            outline.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            outline.fontSize = 50.0f;
            outline.fontColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            if (h==1)  outline.position = CGPointMake(170-2, -360+2);
            if (h==2)  outline.position = CGPointMake(170+2, -360+2);
            if (h==3)  outline.position = CGPointMake(170-2, -360-2);
            if (h==4)  outline.position = CGPointMake(170+2,-360-2);
            [self addChild:outline];
            
            [outline runAction:big];
        }
        
        [loserLabel3 runAction:big];
        
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(replay:) userInfo:nil repeats:NO];
}
-(void)replay:(NSTimer*)timer{
    
    [timer invalidate];
    self.view.hidden=YES;
    
}

@end
