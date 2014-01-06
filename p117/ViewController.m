//
//  ViewController.m
//  p117
//
//  Created by SDT-1 on 2014. 1. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController{
    int dy;
}
-(UITextField *)firstResponderTextField{
    for(id child in self.view.subviews){
        if([child isKindOfClass:[UITextField class]]){
            UITextField *textField= (UITextField *)child;
            if(textField.isFirstResponder){
                return textField;
            }
            
        }
}
    return nil;
}

- (IBAction)dissmissKeyboard:(id)sender {
    [[self firstResponderTextField]resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification*)noti{
    NSLog(@"keyboardWillShow, noti: %@",noti);
    UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
    int y = firstResponder.frame.origin.y + firstResponder.frame.size.height+5;
    int viewheight = self.view.frame.size.height;
    
    NSDictionary *userinfo = [noti userInfo];
    CGRect rect= [[userinfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    int keyheight= (int)rect.size.height;
    
    float animationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    if(keyheight >(viewheight-y)){
        NSLog(@"키보드가 가림");
        [UIView animateWithDuration:animationDuration animations:^{dy=keyheight - (viewheight-y);
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y-dy);
        }];
    }
    else{
        NSLog(@"키보드가 가리지 않음");
        dy=0;
    }
}
-(void) keyHide:(NSNotification *)noti{
    NSLog(@"keyboardWillHide");
    
    if(dy>0){
        float animationDuration = [[[noti userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.center=CGPointMake(self.view.center.x, self.view.center.y+dy);
        }];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
