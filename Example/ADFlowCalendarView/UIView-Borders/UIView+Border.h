//
//  UIView+Border.h
//  MMBangADDemoProject
//
//  Created by CuiPanJun on 15/7/16.
//  Copyright (c) 2015年 CuiPanJun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, UIViewBorderEdge) {
    UIViewBorderEdgeNone    = 0,
    UIViewBorderEdgeTop     = 1 << 0,
    UIViewBorderEdgeLeft    = 1 << 1,
    UIViewBorderEdgeBottom  = 1 << 2,
    UIViewBorderEdgeRight   = 1 << 3,
    UIViewBorderEdgeAll     = UIViewBorderEdgeTop | UIViewBorderEdgeLeft | UIViewBorderEdgeBottom | UIViewBorderEdgeRight
};

@interface UIView (Border)


/*
 
 width: NSNumber (px)
 color: UIColor
 insets: NSStringFromUIEdgeInsets()
 
 */

- (NSDictionary *)borderWithStyleForEdge:(UIViewBorderEdge)edge;
- (void)setBorderWithStyle:(NSDictionary *)style forEdge:(UIViewBorderEdge)edge;

- (void)updateBorders;
- (void)clearAllBorders;

@end
