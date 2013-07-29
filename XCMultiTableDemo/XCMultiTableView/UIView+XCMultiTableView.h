//
//  UIView+XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-22.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XCMultiTableView)

- (void)addBottomLineWithWidth:(CGFloat)width bgColor:(UIColor *)color;

- (UIView *)addVerticalLineWithWidth:(CGFloat)width bgColor:(UIColor *)color atX:(CGFloat)x;

@end
