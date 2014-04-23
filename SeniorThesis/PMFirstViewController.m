//
//  PMFirstViewController.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMFirstViewController.h"
#import "UIButton+UIButton_State.h"
#import "FCColorPickerViewController+FCColorPickerViewController_State.h"

#define TABLE_TAG 1000

@interface PMFirstViewController ()

@property (nonatomic, strong) NSArray *metaData;
@property (nonatomic, strong) NSArray *data;

@end

@implementation PMFirstViewController

- (void)viewDidLoad
{
    self.metaData = @[
                      @[ @"10", @"8", @"6", @"4", @"2", @"0" ],
                      @[ @"80", @"60", @"40", @"20", @"0", @"-20", @"-40", @"-60", @"-80" ],
                      @[ @"54.6", @"20.9", @"5.8", @"2.2", @"0.9", @"0.0" ]
                     ];
    UIColor *w = [UIColor whiteColor];
    self.data =  @[
                   [NSMutableArray arrayWithArray:@[ w, w, w, w, w, w ]],
                   [NSMutableArray arrayWithArray:@[ w, w, w, w, w, w, w, w, w ]],
                   [NSMutableArray arrayWithArray:@[ w, w, w, w, w, w ]]
                 ];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) startOver:(id)sender
{
    for (int i = 0; i < self.data.count; i++) {
        NSMutableArray *array = self.data[i];
        NSInteger count = [array count];
        [array removeAllObjects];
        for (int j = 0; j < count; j++) {
            [array addObject:[UIColor whiteColor]];
        }
    }
    [self.colorScaleTerrorism reloadData];
    [self.colorScaleBacteria reloadData];
    [self.colorScaleTrading reloadData];
}

- (NSArray*) loadMetaData:(UITableView*)tableView
{
    return self.metaData[tableView.tag - TABLE_TAG];
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color
{
    // Get the numbers
    NSInteger table = colorPicker.button.table.intValue;
    NSInteger row = colorPicker.button.row.intValue;
    
    // Set the data parameter
    NSMutableArray *array = self.data[table];
    [array replaceObjectAtIndex:row withObject:color];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Reload the table
    UITableView *tableView = (UITableView*)[self.view viewWithTag:table + TABLE_TAG];
    [tableView reloadData];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger length = [[self loadMetaData:tableView] count];
    NSLog(@"Table %d = %d", tableView.tag, length);
    return length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Color"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Color"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        // Create a button to the left
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        [button addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 85;
        [cell.contentView addSubview:button];
        // Create a label to the right
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.tag = 80;
        [cell.contentView addSubview:label];
    }
    
    // Set the label text
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:80];
    cellLabel.text = [[self loadMetaData:tableView] objectAtIndex:indexPath.row];
    
    // Set the button color
    UIButton *cellButton = (UIButton*)[cell viewWithTag:85];
    NSInteger table = tableView.tag - TABLE_TAG;
    NSInteger row = indexPath.row;
    cellButton.row = [NSNumber numberWithInt:row];
    cellButton.table = [NSNumber numberWithInt:table];

    // Set the color
    cellButton.backgroundColor = self.data[table][row];
    return cell;
}

-(void)chooseColor:(id)sender
{
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = [sender backgroundColor];
    colorPicker.button = (UIButton*)sender;
    colorPicker.delegate = self;
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
}

@end
