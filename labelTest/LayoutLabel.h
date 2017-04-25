//
//  LayoutLabel.h
//  labelTest
//
//  Created by 沙少盼 on 2017/4/24.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayoutLabel : UIView

/**
 init

 @param labels 需要被绘制的字符串集合
 @param width 空间的总宽度
 @param fontSize 字体大小
 @param Height 每个标签的标准高度，如果超出了给定宽度，会重新计算出高度
 @param labelBackColor 标签的背景颜色
 @param textColor 标签字体颜色
 @return 返回控件实例
 */
- (instancetype)initWithLabels:(NSArray *)labels
                         width:(CGFloat)width
                 labelFontSize:(CGFloat)fontSize
                   labelHeight:(CGFloat)Height
                labelBackColor:(UIColor *)labelBackColor
                labelTextColor:(UIColor *)textColor;

/**
 用于计算控件的最终高度

 @param labels 需要计算的标签内容集合
 @return instance
 */
- (CGFloat)getLayoutViewHeightWithLabels:(NSArray *)labels;
@end
