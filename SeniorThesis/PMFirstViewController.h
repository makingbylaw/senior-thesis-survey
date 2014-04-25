//
//  PMFirstViewController.h
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FCColorPickerViewController.h>

@interface PMFirstViewController : UIViewController<FCColorPickerViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *colorScaleTerrorism;
@property (nonatomic,strong) IBOutlet UITableView *colorScaleTrading;
@property (nonatomic,strong) IBOutlet UITableView *colorScaleBacteria;

@property (nonatomic,strong) IBOutlet UITextField *textName;

- (IBAction) startOver:(id)sender;

@end
