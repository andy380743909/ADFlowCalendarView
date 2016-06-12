//
//  UIView+Border.m
//  MMBangADDemoProject
//
//  Created by CuiPanJun on 15/7/16.
//  Copyright (c) 2015年 CuiPanJun. All rights reserved.
//

#import "UIView+Border.h"
#import <objc/runtime.h>

#define BorderStyleKey_Width @"width"
#define BorderStyleKey_Color @"color"
#define BorderStyleKey_Inset @"inset"


@interface UIView (BorderPrivate)

- (NSMutableDictionary *)borderStylesDict;

- (NSMutableDictionary *)borderViewsDict;

@end

@implementation UIView (Border)

- (NSDictionary *)borderWithStyleForEdge:(UIViewBorderEdge)edge{
    NSMutableDictionary *dicts = [self borderStylesDict];
    return [dicts objectForKey:[NSNumber numberWithInteger:edge]];
}

- (void)setBorderWithStyle:(NSDictionary *)style forEdge:(UIViewBorderEdge)edge{
    NSMutableDictionary *dicts = [self borderStylesDict];
    BOOL clean = [style count] == 0;
    
    if ((edge & UIViewBorderEdgeTop) == UIViewBorderEdgeTop) {
        if (clean) {
            [dicts removeObjectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeTop]];
        }else{
            [dicts setObject:style forKey:[NSNumber numberWithInteger:UIViewBorderEdgeTop]];
        }
        
    }
    
    if ((edge & UIViewBorderEdgeLeft) == UIViewBorderEdgeLeft) {
        if (clean) {
            [dicts removeObjectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeLeft]];
        }else{
            [dicts setObject:style forKey:[NSNumber numberWithInteger:UIViewBorderEdgeLeft]];
        }
        
    }
    
    if ((edge & UIViewBorderEdgeBottom) == UIViewBorderEdgeBottom) {
        if (clean) {
            [dicts removeObjectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeBottom]];
        }else{
            [dicts setObject:style forKey:[NSNumber numberWithInteger:UIViewBorderEdgeBottom]];
        }
        
    }
    
    if ((edge & UIViewBorderEdgeRight) == UIViewBorderEdgeRight) {
        if (clean) {
            [dicts removeObjectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeRight]];
        }else{
            [dicts setObject:style forKey:[NSNumber numberWithInteger:UIViewBorderEdgeRight]];
        }
        
    }
    
    [self updateBorderForEdge:edge];
}

- (void)updateBorders{
    [self updateBorderForEdge:UIViewBorderEdgeAll];
}

- (void)clearAllBorders{
    [self setBorderWithStyle:nil forEdge:UIViewBorderEdgeAll];
}

- (void)updateBorderForEdge:(UIViewBorderEdge)edge{
    NSMutableDictionary *styleDicts = [self borderStylesDict];
    NSMutableDictionary *viewDicts = [self borderViewsDict];
    if ((edge & UIViewBorderEdgeTop) == UIViewBorderEdgeTop) {
        NSDictionary *style = [styleDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeTop]];
        UIView *borderView = [viewDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeTop]];
        [self updateBorder:borderView style:style forEdge:UIViewBorderEdgeTop];
    }
    
    if ((edge & UIViewBorderEdgeLeft) == UIViewBorderEdgeLeft) {
        NSDictionary *style = [styleDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeLeft]];
        UIView *borderView = [viewDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeLeft]];
        [self updateBorder:borderView style:style forEdge:UIViewBorderEdgeLeft];
    }
    
    if ((edge & UIViewBorderEdgeBottom) == UIViewBorderEdgeBottom) {
        NSDictionary *style = [styleDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeBottom]];
        UIView *borderView = [viewDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeBottom]];
        [self updateBorder:borderView style:style forEdge:UIViewBorderEdgeBottom];
    }
    
    if ((edge & UIViewBorderEdgeRight) == UIViewBorderEdgeRight) {
        NSDictionary *style = [styleDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeRight]];
        UIView *borderView = [viewDicts objectForKey:[NSNumber numberWithInteger:UIViewBorderEdgeRight]];
        [self updateBorder:borderView style:style forEdge:UIViewBorderEdgeRight];
    }
    
}

- (void)updateBorder:(UIView *)borderV style:(NSDictionary *)style forEdge:(UIViewBorderEdge)edge{
    // clear style
    if (style == nil) {
        borderV.hidden = YES;
        return;
    }
    CGRect lineFrame = CGRectZero;
    UIViewAutoresizing autoResizing = UIViewAutoresizingNone;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIEdgeInsets insets = UIEdgeInsetsFromString([style objectForKey:BorderStyleKey_Inset]);
    insets = UIEdgeInsetsMake(insets.top/scale, insets.left/scale, insets.bottom/scale, insets.right/scale);
    id widthValue = [style objectForKey:BorderStyleKey_Width];
    if (widthValue == nil) {
        widthValue = [NSNumber numberWithFloat:1.0f];
    }
    CGFloat lineWidth = [widthValue doubleValue]/scale;
    CGFloat lineLength = (edge & (UIViewBorderEdgeLeft | UIViewBorderEdgeRight))?CGRectGetHeight(self.bounds):CGRectGetWidth(self.bounds);
    switch (edge) {
        case UIViewBorderEdgeTop:
        {
            lineFrame.origin.x = insets.left;
            lineFrame.origin.y = insets.top;
            lineFrame.size.width = lineLength - (insets.left + insets.right);
            lineFrame.size.height = lineWidth;
            autoResizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        }
            break;
        case UIViewBorderEdgeLeft:
        {
            lineFrame.origin.x = insets.left;
            lineFrame.origin.y = insets.top;
            lineFrame.size.width = lineWidth;
            lineFrame.size.height = lineLength - (insets.top + insets.bottom);
            autoResizing = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        }
            break;
        case UIViewBorderEdgeBottom:
        {
            lineFrame.origin.x = insets.left;
            lineFrame.origin.y = CGRectGetHeight(self.bounds) - lineWidth - insets.bottom;
            lineFrame.size.width = lineLength - (insets.left + insets.right);
            lineFrame.size.height = lineWidth;
            autoResizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }
            break;
        case UIViewBorderEdgeRight:
        {
            lineFrame.origin.x = CGRectGetWidth(self.bounds) - lineWidth - insets.right;
            lineFrame.origin.y = insets.top;
            lineFrame.size.width = lineWidth;
            lineFrame.size.height = lineLength - (insets.top + insets.bottom);
            autoResizing = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        }
            break;
        default:
            break;
    }
    
    if (borderV == nil) {
        NSMutableDictionary *viewDicts = [self borderViewsDict];
        borderV = [[UIView alloc] initWithFrame:lineFrame];
        [viewDicts setObject:borderV forKey:[NSNumber numberWithInteger:edge]];
    }
    borderV.hidden = NO;
    
    borderV.frame = lineFrame;
    borderV.autoresizingMask = autoResizing;
    
    UIColor *borderColor = [style objectForKey:BorderStyleKey_Color];
    borderV.backgroundColor = borderColor;
    
    [self addSubview:borderV];
    [self bringSubviewToFront:borderV];
    
}

#pragma mark - Property

- (NSMutableDictionary *)borderStylesDict{
    
    id mutDict = objc_getAssociatedObject(self, _cmd);
    if (!mutDict) {
        mutDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, mutDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mutDict;
}

- (NSMutableDictionary *)borderViewsDict{
    
    id mutDict = objc_getAssociatedObject(self, _cmd);
    if (!mutDict) {
        mutDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, mutDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mutDict;
}

@end
