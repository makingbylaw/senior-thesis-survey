//
//  PMFirstViewController.h
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

/*
 Static colors
 Submit when ready - enter name
 Show results - start again
 
 - Get rid of tabs
 
 */

#import <UIKit/UIKit.h>
#import <FCColorPickerViewController.h>

@interface PMFirstViewController : UIViewController<FCColorPickerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UIColor *cellColor;
@property (nonatomic,strong) IBOutlet UITableView *colorScale1;

-(IBAction)chooseColor:(id)sender;

@end
