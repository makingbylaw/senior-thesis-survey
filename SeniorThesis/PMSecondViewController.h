//
//  PMSecondViewController.h
//  SeniorThesis
//
//  Created by Paul Mason on 4/21/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMSecondViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) IBOutlet UICollectionView *collectionView;

@end
