//
//  UIButton+UIButton_State.m
//  SeniorThesis
//
//  Created by Paul Mason on 4/22/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "UIButton+UIButton_State.h"
#import <objc/runtime.h>

@implementation UIButton (UIButton_State)

- (NSNumber*)table {
    return objc_getAssociatedObject(self, @selector(table));
}

- (void)setTable:(NSNumber*)value {
    objc_setAssociatedObject(self, @selector(table), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber*)row {
    return objc_getAssociatedObject(self, @selector(row));
}

- (void)setRow:(NSNumber*)value {
    objc_setAssociatedObject(self, @selector(row), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
