//
//  AppDelegate.h
//  DataGo
//
//  Created by Rock on 12-8-7.
//  Copyright (c) 2012年 Verylife. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopSessionController.h"
#import "SplashViewController.h"
#import "EditViewController.h"

#import "TopData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,TaobaoDataDelegate>
{
    NSString * topSession;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SplashViewController * splashController;

@property(strong,nonatomic) TopSessionController * sessionController;

@property(strong,nonatomic) UITabBarController * mainController;

@property(strong,nonatomic) EditViewController * editController;

@property(strong,nonatomic) NSString * topSession;

-(void) showSessionCtrl;
-(void) hideSessionCtrl;
-(void) refreshSession;
@end
