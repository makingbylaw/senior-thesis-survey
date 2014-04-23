//
//  FCColorPickerViewController+FCColorPickerViewController_State.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/22/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "FCColorPickerViewController+FCColorPickerViewController_State.h"
#import <objc/runtime.h>

@implementation FCColorPickerViewController (FCColorPickerViewController_State)

- (UIButton*)button {
    return objc_getAssociatedObject(self, @selector(button));
}

- (void)setButton:(UIButton*)value {
    objc_setAssociatedObject(self, @selector(button), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
