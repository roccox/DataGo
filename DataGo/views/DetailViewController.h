//
//  DetailViewController.h
//  VeryData
//
//  Created by Rock on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) UIView * waitingView;
@property (nonatomic) BOOL isBusy;

-(void)settingPeriodFrom: (NSDate *)start to:(NSDate *) end withTag:(NSString *)tag;

-(NSString *) formatDouble:(double) val;

-(UIViewController *) getEditController;


-(void) showWaiting;
-(void) hideWaiting;
-(void) finishedEdit:(UIViewController *) editCtrl;
@end
