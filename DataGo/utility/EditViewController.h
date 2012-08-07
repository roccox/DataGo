//
//  EditViewController.h
//  DataGo
//
//  Created by Rock on 12-8-7.
//  Copyright (c) 2012年 Verylife. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController


@property(nonatomic) int val;
@property(nonatomic) BOOL valid;
@property(nonatomic,strong)IBOutlet UIPickerView * picker;
@property(nonatomic,strong)IBOutlet UIButton * button;
@property(nonatomic,strong)IBOutlet UITextField * textView;

@property(nonatomic,strong) NSString * note;

@property(nonatomic,strong)UIViewController * superController;

-(IBAction)buttonOK:(id)sender;

@end
