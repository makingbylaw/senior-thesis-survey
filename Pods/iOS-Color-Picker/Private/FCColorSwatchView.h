//
//  ColorSwatchView.h
//  ColorPicker
//
//  Created by Fabián Cañas on 9/9/10.
//  Copyright 2010-2014 Fabián Cañas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSelectColor.h"

@interface FCColorSwatchView : UIView

@property (readwrite, copy, nonatomic) UIColor *color;
@property (nonatomic, assign) id<FCSelectColor> colorSelector;

@end
