//
//  ClothViewController.h
//  VeryData
//
//  Created by Rock on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopData.h"
#import "DetailViewController.h"

#import "SDWebImageManagerDelegate.h"
#import "SDWebImageDownloaderDelegate.h"
#import "UIImageView+WebCache.h"

@interface ClothViewController : DetailViewController <UITableViewDelegate,UITableViewDataSource,TaobaoDataDelegate>{
    
    NSString * _tag;

}

@property (nonatomic,strong) IBOutlet UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataList;
@property (nonatomic,strong) NSMutableArray * itemList;

@property (nonatomic,strong) TopItemModel * item;

@end
