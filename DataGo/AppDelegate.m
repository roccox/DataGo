//
//  AppDelegate.m
//  DataGo
//
//  Created by Rock on 12-8-7.
//  Copyright (c) 2012年 Verylife. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize sessionController,topSession,mainController,editController;


#pragma test delegate for taobao
-(void) notifyItemRefresh:(BOOL)isFinished withTag:(NSString*) tag
{
    NSLog(@"%@",tag);
}
-(void) notifyTradeRefresh:(BOOL)isFinished withTag:(NSString*) tag
{
    NSLog(@"%@",tag);
    
}

-(void)setTopSession:(NSString *)session
{
    topSession = session;
    [[TopData getTopData] putSession:topSession];
}

-(void)refreshSession
{
    [self showSessionCtrl];
}

-(void)showSessionCtrl
{
    self.sessionController.modalPresentationStyle = UIModalPresentationFormSheet;
    self.sessionController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UISplitViewController * splitCtrl = (UISplitViewController *)self.window.rootViewController;
    
    [splitCtrl presentModalViewController:self.sessionController animated:YES];
}

-(void)hideSessionCtrl
{
    UISplitViewController * splitCtrl = (UISplitViewController *)self.window.rootViewController;
    
    [splitCtrl dismissModalViewControllerAnimated:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    SplashViewController * rootController = (SplashViewController *) self.window.rootViewController;
    
    mainController = [rootController.storyboard instantiateViewControllerWithIdentifier:@"mainCtrl"];
    sessionController = [mainController.storyboard instantiateViewControllerWithIdentifier:@"sessionCtrl"];
    
    editController = [rootController.storyboard instantiateViewControllerWithIdentifier:@"editCtrl"];

    return YES;}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.window.rootViewController = self.splashController;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
