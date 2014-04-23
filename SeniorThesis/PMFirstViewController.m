//
//  PMFirstViewController.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMFirstViewController.h"

@interface PMFirstViewController ()
@end

@implementation PMFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.cellColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)chooseColor:(id)sender
{
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = self.cellColor;
    colorPicker.delegate = self;
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

-(void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    self.cellColor = color;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.colorScale1 reloadData];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Color"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Color"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( 13.0f, 13.0f, 90.0f, 90.0f)];
        [button addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    cell.backgroundColor = self.cellColor;
    cell.textLabel.text = @"10";
    return cell;
}

@end
