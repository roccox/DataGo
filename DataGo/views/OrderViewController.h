//
//  DetailViewController.h
//  VeryData
//
//  Created by Rock on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController.h"
#import "TopData.h"
#import "DateHelper.h"

#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"
#import "UIImageView+WebCache.h"

#import "Kal.h"
#import "KalDate.h"
#import "AppDelegate.h"

@interface OrderViewController : DetailViewController <UITableViewDelegate,UITableViewDataSource,TaobaoDataDelegate>{

    NSString * _tag;
    BOOL    isFirstLoad;
    NSString * report;
    BOOL    isDayView;
}

@property (nonatomic,strong) IBOutlet UITableView * tableView;
@property (nonatomic,strong) IBOutlet UIWebView * infoView;

@property (nonatomic,strong) NSDate * startTime;
@property (nonatomic,strong) NSDate * endTime;

@property (nonatomic,strong) NSMutableArray * dataList;
@property (nonatomic,strong) NSMutableArray * tradeList;

@property (nonatomic,strong) IBOutlet UIView * toolView;
@property (nonatomic,strong) IBOutlet UIView * rootView;


@property (nonatomic,strong) id obj;

-(IBAction)showHideTools:(id)sender;
-(IBAction)switchPeriod:(id)sender;

-(IBAction)updateData:(id)sender;

-(IBAction)allTrades:(id)sender;
-(IBAction)notPayTrades:(id)sender;
-(IBAction)payTrades:(id)sender;
-(IBAction)sentTrades:(id)sender;
-(IBAction)closedTrades:(id)sender;


-(void)getData;
-(void)calculate;
-(void)finishedCal;

@end
