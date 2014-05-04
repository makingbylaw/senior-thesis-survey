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
#define ARROW_TAG 874

@interface PMFirstViewController ()

@property (nonatomic, strong) NSArray *metaData;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *overlay;

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
    self.overlay = [[UIView alloc] initWithFrame:self.view.frame];
    self.overlay.backgroundColor = [UIColor blackColor];
    self.overlay.alpha = 0;
    self.overlay.tag = 9999;
    [self.view addSubview:self.overlay];
    [super viewDidLoad];
    
    // Add an animation onto the image view
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 5;
    animationGroup.repeatCount = INFINITY;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5f;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.8f];
    [animation setRemovedOnCompletion:NO];
    [animation setRepeatCount:2];
    [animation setFillMode:kCAFillModeForwards];
    animationGroup.animations = @[animation];
    
    UIView *arrow = [self.view viewWithTag:ARROW_TAG];
    [arrow.layer addAnimation:animationGroup forKey:@"scale"];
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
    [self.textName setText:@""];
    UIView *arrow = [self.view viewWithTag:ARROW_TAG];
    [arrow setAlpha:1.0f];
}

-(NSString *)hexValuesFromUIColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}

- (IBAction) saveRecord:(id)sender
{
    NSString *name = [self.textName text];
    
    // Take a screen shot first
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // TODO Generate a name..
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *path = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [formatter stringFromDate:date]]];
    [UIImagePNGRepresentation(img) writeToFile:path atomically:NO];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
    // Post it to Google Apps
    NSMutableString *post = [NSMutableString stringWithFormat:@"PersonName=%@", name];
    for (int i = 0; i < self.data.count; i++) {
        NSMutableArray *array = self.data[i];
        NSInteger count = [array count];
        for (int j = 0; j < count; j++) {
            UIColor *c = (UIColor*)[array objectAtIndex:j];
            [post appendFormat:@"&T%d%d=#%@", i, j, [self hexValuesFromUIColor:c]];
        }
    }
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://script.google.com/a/macros/form1.co.nz/s/AKfycbzzpVL4j_rpnk7zqV6qKSwdcJstF9lJ_oUunElRYQaTgWckIG0/exec"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Create a queue and send
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSString *result = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        NSLog(@"Data response: %@", result);
    }];
    //NSData *requestData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    //NSString *result = [[NSString alloc] initWithData: requestData encoding: NSUTF8StringEncoding];
    //NSLog(@"Data response: %@", result);
    
    // If it is OK then clear the page
    //if ([result isEqualToString:@"OK"]) {
    [self startOver:sender];
    
    // Say thanks
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We got it!"
                                                    message:[NSString stringWithFormat:@"Great, thanks for that %@.", name]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    //}
}

- (NSArray*) loadMetaData:(UITableView*)tableView
{
    return self.metaData[tableView.tag - TABLE_TAG];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self saveRecord:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    [self animateTextView:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextView:textField up:NO];
}

- (void) animateTextView:(UITextField*)textField up:(BOOL) up
{
    // Also overlay a UIView on up, and remove on down
    if (up) {
        self.overlay.frame = self.view.frame;
        self.overlay.alpha = 0.6;
        textField.layer.zPosition = 5;
    } else {
        self.overlay.alpha = 0;
    }
    const int movementDistance = 270; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    textField.frame = CGRectOffset(textField.frame, 0, movement);
    [UIView commitAnimations];
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
    
    // Hide the arrow
    UIView *arrow = [self.view viewWithTag:ARROW_TAG];
    [arrow setAlpha:0.0f];
}

-(void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger length = [[self loadMetaData:tableView] count];
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
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 42)];
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
    cellButton.row = [NSNumber numberWithInteger:row];
    cellButton.table = [NSNumber numberWithInteger:table];

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
