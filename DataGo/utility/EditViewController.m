//
//  EditViewController.m
//  DataGo
//
//  Created by Rock on 12-8-7.
//  Copyright (c) 2012年 Verylife. All rights reserved.
//

#import "EditViewController.h"

#import "DetailViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize picker,val,valid,button,superController;
@synthesize textView,note;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [picker selectRow:(val/100) inComponent:0 animated:YES];
    [picker selectRow:(val/10%10) inComponent:1 animated:YES];
    [picker selectRow:(val%10) inComponent:2 animated:YES];
    self.valid = NO;
    
    self.textView.text = self.note;
    if([self.note hasPrefix:@"REFUND"])
        self.textView.text = @"请输入退货数量";
    else
        self.textView.text = @"请输入瑕疵费";
}

#pragma - picker
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[NSString alloc]initWithFormat:@"%d",row];
}

-(IBAction)buttonOK:(id)sender
{
    self.val = [picker selectedRowInComponent:0]*100 +
    [picker selectedRowInComponent:1]*10 + [picker selectedRowInComponent:2];
    
    self.valid = YES;
    
    //close
    [self.superController performSelector:@selector(finishedEdit
                                                    :) withObject:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
