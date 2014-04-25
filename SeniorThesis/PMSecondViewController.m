//
//  PMSecondViewController.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMSecondViewController.h"
#import "PMCollectionViewCell.h"

@interface PMSecondViewController ()
{
    NSString *docsDir;
    NSArray *directoryContent;
}
@end

@implementation PMSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.collectionView registerClass:[PMCollectionViewCell class] forCellWithReuseIdentifier:@"ImageColors"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDir error:NULL];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [directoryContent count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionViewCell *cell = (PMCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageColors" forIndexPath:indexPath];

    // Set the image
    NSString *path = [docsDir stringByAppendingPathComponent:[directoryContent objectAtIndex:indexPath.row]];
    NSLog(@"Path: %@", path);
    [cell setImage:[UIImage imageWithContentsOfFile:path]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(250, 250);
}

@end
