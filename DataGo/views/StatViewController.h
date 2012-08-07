//
//  StatViewController.h
//  VeryData
//
//  Created by Rock on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

#import "TopData.h"
#import "DateHelper.h"


@interface StatViewController : DetailViewController {
    
    NSString * _tag;
    BOOL    isFirstLoad;
    NSString * report;
}

@property (nonatomic,strong) IBOutlet UIWebView * infoView;
@property (nonatomic,strong) NSDate * startTime;
@property (nonatomic,strong) NSDate * endTime;

@property (nonatomic,strong) NSMutableArray * tradeList;

@property (nonatomic,strong) TopTradeModel * trade;


@end
