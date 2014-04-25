//
//  PMCollectionViewCell.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/24/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMCollectionViewCell.h"

@implementation PMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [imageView drawRect:rect];
}


-(void)setImage:(UIImage *)image
{
    [imageView setImage:image];
}

@end
