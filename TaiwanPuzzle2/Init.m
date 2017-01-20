//
//  Init.m
//  TaiwanPuzzle2
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 LiChen. All rights reserved.
//

#import "Init.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMdrawerVisualState.h"
#import "CityModel.h"
#import "SVProgressHUD.h"
#import "JVFloatLabeledTextField.h"
@import Firebase;
@interface Init () <UITextFieldDelegate>
{
    NSUserDefaults * user;
}
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIButton *myButton;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *myTextField;
@property MMDrawerController *drawerController;
@end

@implementation Init
-(void)viewDidAppear:(BOOL)animated{
    user=[NSUserDefaults standardUserDefaults];
    if ([user boolForKey:@"first"]==false) {
         self.ref = [[FIRDatabase database] reference];
        _myTextField.delegate=self;
        _myTextField.floatingLabelTextColor = [UIColor blueColor];
        _myTextField.floatingLabelActiveTextColor = [UIColor redColor];
        _myTextField.floatingLabel.text =@"我的暱稱";
        _myTextField.keyboardType=UIKeyboardTypeDefault;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, _myTextField.frame.size.height-1, _myTextField.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
        [_myTextField.layer addSublayer:bottomBorder];
        [self setMyButton];
    }
    else if([user boolForKey:@"first"]==true){
        [self initMainView];
        [self presentViewController:_drawerController animated:NO completion:nil];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_myTextField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}
- (void)textFieldEditingMoveWithTextField:(UITextField *)textField Heigth:(CGFloat)height {
    [UIView animateWithDuration:0.5 animations:^{
        textField.superview.frame = CGRectMake(textField.superview.frame.origin.x,
                                               textField.superview.frame.origin.y + height,
                                               textField.superview.frame.size.width,
                                               textField.superview.frame.size.height);
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self textFieldEditingMoveWithTextField:textField Heigth:-CGRectGetHeight(self.view.frame) * 0.2];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textFieldEditingMoveWithTextField:textField Heigth:CGRectGetHeight(self.view.frame) * 0.2];
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)start:(id)sender {
    if (_myTextField.text.length==0) {
         [SVProgressHUD showInfoWithStatus:@"暱稱不可為空白"];
        return;
    }
    [SVProgressHUD show];
    [[_ref child:@"Rank"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary * dict = snapshot.value;
        NSArray * allKeys = [dict allKeys];
        for (int i=0; i<allKeys.count; i++) {
            if ([_myTextField.text isEqualToString:allKeys[i]]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showInfoWithStatus:@"此暱稱已有人取過了"];
                 return;
            }
            else if(i==allKeys.count-1) {
                    [user setBool:true forKey:@"first"];
                    [user setObject:_myTextField.text forKey:@"MyName"];
                    [user synchronize];
                 [SVProgressHUD dismiss];
                [self initMainView];
                [self presentViewController:_drawerController animated:NO completion:nil];
            }
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string
{
        if (textField == self.myTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 8) {
             [SVProgressHUD showInfoWithStatus:@"最多八個字"];
            return NO;
        }
    }
        if (range.length == 0 && range.location == 0 && [string isEqualToString:@" "])
        {
            [SVProgressHUD showInfoWithStatus:@"第一個字不能為空白"];
            return NO;
        }
    return YES;
}
-(void)initMainView{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIStoryboard* sideMenu = [UIStoryboard storyboardWithName:@"SideMenu" bundle: nil];
    _drawerController = [[MMDrawerController alloc] initWithCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarContoller"] leftDrawerViewController:[sideMenu instantiateViewControllerWithIdentifier:@"SideMenu"]];
    [_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    [_drawerController setMaximumLeftDrawerWidth:280.0];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    _drawerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _drawerController.modalPresentationStyle = UIModalPresentationFormSheet;
}
-(void)setMyButton{
    _myButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _myButton.layer.borderWidth = 2.0f;
    _myButton.layer.cornerRadius = 20.0f;
    [_myButton setTitle:@"確定" forState:UIControlStateNormal];
    _myButton.titleLabel.textColor=[UIColor whiteColor];

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"init_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}


@end
