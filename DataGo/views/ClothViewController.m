//
//  DetailViewController.m
//  VeryData
//
//  Created by Rock on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClothViewController.h"
#import "ItemCell.h"

@interface ClothViewController ()
- (void)configureView;
@end

@implementation ClothViewController
@synthesize dataList,tableView,item;
@synthesize itemList;

#pragma mark - Managing the detail item

-(void)settingPeriodFrom: (NSDate *)start to:(NSDate *) end withTag:(NSString *)tag
{
    if (_tag != tag) {
        _tag = tag;

        //get data
        TopData * topData = [TopData getTopData];
        if(self.itemList == nil)
            self.itemList = [[NSMutableArray alloc]init];
        else {
            [self.itemList removeAllObjects];
        }

        self.itemList = [topData getItems];
        
        if(self.dataList == nil)
            self.dataList = [[NSMutableArray alloc]init];
        else {
            [self.dataList removeAllObjects];
        }
        
        for (TopItemModel * _item in self.itemList) {
            [self.dataList addObject:_item];
            }

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma - taobao
-(void) notifyItemRefresh:(BOOL)isFinished withTag:(NSString*) tag
{
    if(isFinished)
    {
        //get data again
        //get data
        TopData * topData = [TopData getTopData];
        if(self.itemList == nil)
            self.itemList = [[NSMutableArray alloc]init];
        else {
            [self.itemList removeAllObjects];
        }
        
        self.itemList = [topData getItems];
        
        if(self.dataList == nil)
            self.dataList = [[NSMutableArray alloc]init];
        else {
            [self.dataList removeAllObjects];
        }
        
        for (TopItemModel * _item in self.itemList) {
            [self.dataList addObject:_item];
        }
        
        self.navigationItem.title = @"";
        [self hideWaiting];
        //relaod
        [self configureView];
    }
    else
        self.navigationItem.title = tag;
}

-(void) notifyTradeRefresh:(BOOL)isFinished withTag:(NSString*) tag
{
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * itemID = @"itemCellID";
    TopItemModel *  _item = [self.dataList objectAtIndex:indexPath.row];
    
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
        cell.price.text = [[NSString alloc]initWithFormat:@"价格:%@",[NSNumber numberWithDouble: _item.price]];
        cell.import_price.text = [[NSString alloc]initWithFormat:@"进价:%@",[NSNumber numberWithDouble: _item.import_price]];
        cell.volume.text = [[NSString alloc]initWithFormat:@"最近卖出:%@",[NSNumber numberWithInt: _item.volume]];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.item = [dataList objectAtIndex:indexPath.row];

}

-(void)finishedEditPopover:(int)val withNote: (NSString *) note
{
    self.item.import_price = val;
    self.item.note = note;
    [self.item saveImportPrice];
    [self.tableView reloadData];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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
    return YES;
}
@end
