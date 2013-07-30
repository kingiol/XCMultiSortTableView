//
//  UIView+XCMultiTableView.m
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-22.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "UIView+XCMultiSortTableView.h"

@implementation UIView (XCMultiTableView)

- (void)addBottomLineWithWidth:(CGFloat)width bgColor:(UIColor *)color {
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - width, self.frame.size.width, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomLine];
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width bgColor:(UIColor *)color atX:(CGFloat)x {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.bounds.size.height)];
    line.backgroundColor = color;
    line.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:line];
    return line;
}

@end
