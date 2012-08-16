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
@synthesize dataList,tableView,item,searchField;
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
        
        self.searchField.text = @"";
        [self hideWaiting];
        //relaod
        [self configureView];
    }
    else
        self.searchField.text = tag;
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
        cell.volume.text = [[NSString alloc]initWithFormat:@"卖:%@",[NSNumber numberWithInt: _item.volume]];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.item = [dataList objectAtIndex:indexPath.row];

    EditViewController * edit = (EditViewController * )[self getEditController];
    edit.superController = self;

    edit.val = self.item.import_price;
    edit.note = @"PRICE";
        
    [self.navigationController pushViewController:edit animated:YES];

}


-(void)finishedEdit:(UIViewController *)editCtrl
{
    EditViewController * edit = (EditViewController *)editCtrl;
    
    self.item.import_price = edit.val;
    self.item.note = edit.textView.text;
    [self.item saveImportPrice];
    [self.tableView reloadData];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isAllItemView = true;
    NSDate * startTime = [[NSDate alloc]initWithTimeIntervalSinceNow:8*60*60];
    NSDate * endTime = [[NSDate alloc]initWithTimeInterval:(-7*24*60*60) sinceDate:startTime];
    [self settingPeriodFrom:startTime to:endTime withTag:@"CLOTH"];
}

-(IBAction)showItems:(id)sender
{
    [self.dataList removeAllObjects];

    if(isAllItemView)
    {
        isAllItemView = false;
        self.navigationItem.leftBarButtonItem.title = @"全部商品";
        for (TopItemModel * _item in self.itemList) {
            if(_item.import_price < 0.01 && _item.import_price > -0.01)
                [self.dataList addObject: _item];
        }
    }
    else
    {
        isAllItemView = true;
        self.navigationItem.leftBarButtonItem.title = @"无进价商品";
        for (TopItemModel * _item in self.itemList) {
            [self.dataList addObject: _item];
        }
    }

    [self configureView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)showSearchedItems:(id)sender
{
    [self.dataList removeAllObjects];
    for (TopItemModel * _item in self.itemList) {
        NSRange range = [_item.title rangeOfString:self.searchField.text];
        if(range.length > 0)
            [self.dataList addObject: _item];
    }
    [self configureView];
}

-(IBAction)refreshData:(id)sender
{
    TopData * topData = [TopData getTopData];
    topData.delegate = self;
    self.searchField.text = @"更新中...";
    [self showWaiting];
    [topData refreshItems];
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
