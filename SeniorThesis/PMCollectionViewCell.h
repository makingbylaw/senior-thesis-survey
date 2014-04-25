//
//  PMCollectionViewCell.h
//  SeniorThesis
//
//  Created by Paul Mason on 4/24/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMCollectionViewCell : UICollectionViewCell
{
    IBOutlet UIImageView *imageView;
}

-(void)setImage:(UIImage *)image;

@end
