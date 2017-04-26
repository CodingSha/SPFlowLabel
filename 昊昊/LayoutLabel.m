//
//  LayoutLabel.m
//  labelTest
//
//  Created by 沙少盼 on 2017/4/24.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import "LayoutLabel.h"

//标签间隔
#define PADDING 5

@interface LayoutLabel ()
/**
 数据内容数组
 */
@property (nonatomic,copy)NSMutableArray *labels;
/**
 整个空间的宽度
 */
@property (nonatomic,assign)CGFloat Width;
/**
 一个标签的标准高度
 */
@property (nonatomic,assign)CGFloat labelHeight;
/**
 内容字体大小
 */
@property (nonatomic,assign)CGFloat fontSize;
/**
 包含所有标签的大小数组
 */
@property (nonatomic,copy)NSMutableArray *sizes;
/**
 经过算法处理之后，用于绘制的标签内容
 */
@property (nonatomic,copy)NSMutableArray *dataSource;
/**
 经过算法处理之后，用于绘制的标签空间的大小
 */
@property (nonatomic,copy)NSMutableArray *dataSize;
/**
 标签背景颜色
 */
@property (nonatomic,strong)UIColor *labelColor;
/**
 标签字体颜色
 */
@property (nonatomic,strong)UIColor *labelTextColor;
/**
 用于标记超过空间宽度的字符串的位置
 */
@property (nonatomic,copy)NSMutableArray *allLineIndexs;
@end

@implementation LayoutLabel
//init
- (instancetype)initWithLabels:(NSArray *)labels width:(CGFloat)width labelFontSize:(CGFloat)size labelHeight:(CGFloat)Height labelBackColor:(UIColor *)color labelTextColor:(UIColor *)textColor{
    if (self = [super init]) {
        _Width               = width;
        _fontSize            = size;
        _labelHeight         = Height;
        _labelColor          = color;
        _labelTextColor      = textColor;
        [self.labels addObjectsFromArray:labels];
        [self resolvMetaData:self.labels];
        [self creatUI];
    }
    return self;
}
#pragma mark - lazingLoading
- (NSMutableArray *)labels{
    if (!_labels) {
        _labels = @[].mutableCopy;
    }
    return _labels;
}
- (NSMutableArray *)sizes{
    if (!_sizes) {
        _sizes = @[].mutableCopy;
    }
    return _sizes;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (NSMutableArray *)dataSize{
    if (!_dataSize) {
        _dataSize = @[].mutableCopy;
    }
    return _dataSize;
}
- (NSMutableArray *)allLineIndexs{
    if (!_allLineIndexs) {
        _allLineIndexs = @[].mutableCopy;
    }
    return _allLineIndexs;
}

#pragma mark - Core algorithm
/**
 核心算法
 -- 先对数据源进行宽高计算
 -- 拿到宽高之后，然后按顺序去判断
 -- 1.先判断拿到的数据是否超过给定的宽度，如果超过，直接占满一行，并自适应高度
      并将此条信息加入到数据源中
 -- 2.如果未超过给定宽度，则继续判断加上间隔（10px）以及累计宽度是否超出给定宽度
      如果超出，则直接结束本次轮询。将累计信息加入数据源。
 -- 3.如果累计未超出，则继续下次轮询。
 -- 顺带会计算出self的height。
 */
- (void)resolvMetaData:(NSArray *)labels{
    NSInteger i = 0;
    for (NSString *label in labels) {
        CGRect size = [label boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, _labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize]} context:nil];
        if (size.size.width > _Width) {
            [self.allLineIndexs addObject:@(i)];
            size = [label boundingRectWithSize:CGSizeMake(_Width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize]} context:nil];
        }
        [self.sizes addObject:[NSValue valueWithCGSize:size.size]];
        i ++;
    }
    CGFloat sum = 0.f;//用于记录当前行累计宽度
    NSMutableArray *tmpArr = @[].mutableCopy;//记录每行的label内容
    NSMutableArray *tmpSizeArr = @[].mutableCopy;//记录每行的label的size信息
    CGFloat self_height = 0.f;
    for (NSInteger i = 0; i < self.sizes.count; i ++) {
        CGFloat width  = [self.sizes[i] CGSizeValue].width;
        if ([self.allLineIndexs containsObject:@(i)]) {
            if (sum > 0) {
                [self.dataSource addObject:tmpArr.copy];
                [self.dataSize addObject:tmpSizeArr.copy];
                self_height += [self.sizes[i - 1] CGSizeValue].height + PADDING;
            }
            [self.dataSource addObject:@[labels[i]]];
            [self.dataSize addObject:@[self.sizes[i]]];
            sum = 0.f;
            [tmpArr removeAllObjects];
            [tmpSizeArr removeAllObjects];
            self_height += [self.sizes[i] CGSizeValue].height + PADDING;
        }else{
            if (sum + PADDING + width > _Width) {
                [self.dataSource addObject:tmpArr.copy];
                [self.dataSize addObject:tmpSizeArr.copy];
                sum = 0.f;
                [tmpArr removeAllObjects];
                [tmpSizeArr removeAllObjects];
                self_height += [self.sizes[i - 1] CGSizeValue].height + PADDING;
                if (i == self.sizes.count - 1) {
                    self_height += [self.sizes[i] CGSizeValue].height;
                    [self.dataSource addObject:@[labels[i]]];
                    [self.dataSize addObject:@[self.sizes[i]]];
                    break;
                }else{
                    sum += width + PADDING;
                    [tmpArr addObject:labels[i]];
                    [tmpSizeArr addObject:self.sizes[i]];
                }
            }else{
                sum += width + PADDING;
                [tmpArr addObject:labels[i]];
                [tmpSizeArr addObject:self.sizes[i]];
                if (i == self.sizes.count - 1) {
                    self_height += [self.sizes[i] CGSizeValue].height;
                    [self.dataSource addObject:tmpArr.copy];
                    [self.dataSize addObject:tmpSizeArr.copy];
                }
            }
        }
    }
    self.height = self_height;
}

#pragma mark - Draw UI
/**
 UI绘制
 -- i代表行数
 -- j代表行中的第几个
 */
- (void)creatUI{
    CGFloat y_offset = 0.f;
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        NSArray *rows_data = self.dataSource[i];
        NSArray *rows_size = self.dataSize[i];
        CGFloat x_offset = 0.f;
        for (NSInteger j = 0; j < rows_data.count; j ++) {
            NSLog(@"width: %.2f",[rows_size[j] CGSizeValue].width);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x_offset, y_offset, [rows_size[j] CGSizeValue].width, [rows_size[j] CGSizeValue].height)];
            label.numberOfLines = 0;
            label.text = rows_data[j];
            label.textAlignment = 0;
            label.font = [UIFont systemFontOfSize:_fontSize];
            label.textColor = _labelTextColor ? _labelTextColor:[UIColor blackColor];
            label.backgroundColor = _labelColor ? _labelColor:[UIColor whiteColor];
            [self addSubview:label];
            x_offset += [rows_size[j] CGSizeValue].width + PADDING;
        }
        if (rows_size.count) {
            y_offset += [rows_size[0] CGSizeValue].height+ PADDING;
        }
    }
}


@end
