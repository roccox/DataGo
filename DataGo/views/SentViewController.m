//
//  SentViewController.m
//  VeryData
//
//  Created by peng Jin on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SentViewController.h"
#import "ItemCell.h"

@interface SentViewController ()
- (void)configureView;
- (void)calculate;
-(void)calFinished;
@end

@implementation SentViewController

@synthesize tableView,dataList,itemList,startTime,endTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)settingPeriodFrom: (NSDate *)start to:(NSDate *) end withTag:(NSString *)tag
{
    if (1) {
//        _tag = tag;
        

        self.startTime = start;
        self.endTime = end;
        [self showWaiting];
        
        self.navigationItem.title = @"正在计算数据,请不要动......";
        NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(calculate) object:nil];
        [thread start];
        // Update the view.
        [self configureView];
    }
}

-(void)calFinished
{
    [self hideWaiting];    
    self.navigationItem.title = @"计算结束......";
    [self configureView];
}

-(void)calculate
{
    //get data
    TopData * topData = [TopData getTopData];
    if(self.dataList == nil)
        self.dataList = [[NSMutableArray alloc]init];
    else {
        [self.dataList removeAllObjects];
    }
    if(self.itemList == nil)
        self.itemList = [[NSMutableArray alloc]init];
    else {
        [self.itemList removeAllObjects];
    }

    //get trade and orders
//    NSMutableArray * tradeList = [topData getTradesFrom:self.startTime to:self.endTime];
    NSMutableArray * tradeList = [topData getUnSentTrades];
    
    for (TopTradeModel * _trade in tradeList) {
        if([_trade.status isEqualToString:@"WAIT_SELLER_SEND_GOODS"])
            for(TopOrderModel * order in _trade.orders){
                [self.dataList addObject:order];
            }
    }
    //convert to items
    TopOrderModel * order;
    TopItemModel * item;
    BOOL found = NO;
    for(int i=0;i<[dataList count];i++)
    {
        found = NO;
        order = (TopOrderModel *) [dataList objectAtIndex:i];
        for (TopItemModel * _item in itemList) {
            if(order.num_iid == _item.num_iid && [order.sku_name isEqualToString:_item.note])
            {
                _item.volume += order.num;
                [dataList removeObjectAtIndex:i];
                i--;
                found = YES;
            }
        }
        
        //not found
        if(!found)
        {
            item = [[TopItemModel alloc]init];
            item.num_iid = order.num_iid;
            item.title = order.title;
            item.volume = order.num;
            item.price = order.price;
            item.import_price = order.import_price;
            item.pic_url = order.pic_url;
            item.note = order.sku_name;
            [itemList addObject:item];
        }
    }
    
    //re-order items
    TopItemModel * item2;
    for(int i=0;i<[itemList count];i++)
    {
        item = (TopItemModel *) [itemList objectAtIndex:i];
        for (int j=i+2;j<[itemList count];j++){
            item2 = (TopItemModel *) [itemList objectAtIndex:j];
            if(item.num_iid == item2.num_iid)
            {
                [itemList exchangeObjectAtIndex:i+1 withObjectAtIndex:j];
                break;  //break 
            }
        }
    }

    [self performSelectorOnMainThread:@selector(calFinished) withObject:nil waitUntilDone:NO];
}
- (void)configureView
{
    // Update the user interface for the detail item.
    
    //cal item count;
    int itemCount = 0;
    for (TopItemModel * _item in itemList) {
        itemCount += _item.volume;
    }
    self.navigationItem.title = [[NSString alloc]initWithFormat:@"%d",itemCount];  
    [self.tableView reloadData];
}


#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * itemID = @"itemCellID";
    TopItemModel *  _item = [self.itemList objectAtIndex:indexPath.row];
    
    {
        ItemCell * cell = (ItemCell *)[self.tableView dequeueReusableCellWithIdentifier:itemID];
        
        if(!cell)
        {
            NSArray *objs=[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
            for(id obj in objs)
            {
                if([obj isKindOfClass:[ItemCell class]])
                {
                    cell=(ItemCell *)obj;
                }
            }
        }
        
        //start to 
        [cell.image setImageWithURL:[NSURL URLWithString:_item.pic_url] placeholderImage:[UIImage imageNamed:@"hold.png"]];
        cell.title.text = [[NSString alloc]initWithFormat:@"%@",_item.title];
        cell.sku.text = _item.note;
        cell.price.text = [[NSString alloc]initWithFormat:@"价格:%@",[NSNumber numberWithDouble: _item.price]];
        cell.import_price.text = [[NSString alloc]initWithFormat:@"进价:%@",[NSNumber numberWithDouble: _item.import_price]];
        cell.volume.text = [[NSString alloc]initWithFormat:@"数量:%@",[NSNumber numberWithInt: _item.volume]];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.startTime = [[NSDate alloc]initWithTimeIntervalSinceNow:8*60*60];
    self.endTime = [[NSDate alloc]initWithTimeInterval:(-7*24*60*60) sinceDate:self.startTime];
    [self settingPeriodFrom:self.startTime to:self.endTime withTag:@"ORDER_DAY"];

//    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
