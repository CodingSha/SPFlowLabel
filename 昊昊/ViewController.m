//
//  ViewController.m
//  昊昊
//
//  Created by 沙少盼 on 2017/4/26.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import "ViewController.h"
#import "LayoutLabel.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSMutableArray * heights;
@property (nonatomic,copy)NSMutableArray * carType_heights;
@property (nonatomic,copy)NSMutableArray * reson_heights;
@property (nonatomic,copy)NSArray *dataArray;
@end

@implementation ViewController

#pragma mark - lazingLoding
- (NSMutableArray *)heights{
    if (!_heights) {
        _heights = @[].mutableCopy;
    }
    return _heights;
}
- (NSMutableArray *)carType_heights{
    if (!_carType_heights) {
        _carType_heights = @[].mutableCopy;
    }
    return _carType_heights;
}
- (NSMutableArray *)reson_heights{
    if (!_reson_heights) {
        _reson_heights = @[].mutableCopy;
    }
    return _reson_heights;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@{@"bottomStr" : @"打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"已购买新车",@"品牌啊啊啊啊啊",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"品牌",@"已购买新车",@"购车意向不明确",@"购车意向不明确"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接@打电话没人接",@"dataArr" :@[@"购车意向不明确",@"品牌",@"购车意向不明确",@"已购买新车",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"品牌",@"已购买新车",@"购车意向不明确",@"已购买新车",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"已购买新车",@"品牌",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"品牌",@"已购买新车",@"购车意向不明确",@"购车意向不明确"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接@打电话没人接",@"dataArr" :@[@"购车意向不明确",@"品牌",@"购车意向不明确",@"已购买新车",@"购车意向不明确",@"已购买新车"]},
                     @{@"bottomStr" : @"打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接@打电话没人接",@"dataArr" : @[@"购车意向不明确",@"购车意向不明确",@"品牌",@"已购买新车",@"购车意向不明确",@"已购买新车",@"购车意向不明确",@"已购买新车"]}];
    
    //cell以及相关控件的高度计算
    
    for (NSDictionary *dict in self.dataArray) {
        //计算出车型的自适应高度
        NSString *carType = dict[@"bottomStr"];
        CGRect carRect = [carType boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100 - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        [self.carType_heights addObject:@(carRect.size.height)];
        //计算出战败原因的高度
        NSArray *resons = dict[@"dataArr"];
        LayoutLabel *layout = [[LayoutLabel alloc]initWithLabels:resons width:[UIScreen mainScreen].bounds.size.width - 100 - 20 labelFontSize:14 labelHeight:21 labelBackColor:[UIColor orangeColor] labelTextColor:[UIColor blackColor]];
        [self.reson_heights addObject:@(layout.height)];
        //顾问高度
        CGFloat guwen_height = 20;
        //客户高度
        CGFloat kehu_height  = 20;
        //将所有控件的高度加载一起
        NSLog(@"height : %.2f",layout.height);
        [self.heights addObject:@(carRect.size.height * 2 + layout.height + guwen_height + kehu_height + 6 * 10)];
    }
    
    //初始化tableview
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20) style:0];
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - table Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:iden];
    }else{
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    //添加控件
    //顾问
    UILabel *guwen = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 20)];
    guwen.font = [UIFont systemFontOfSize:14];
    guwen.text = @"顾问";
    [cell.contentView addSubview:guwen];
    
    UILabel *guwen_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, [UIScreen mainScreen].bounds.size.width - 100 - 20, 20)];
    guwen_detail.font = [UIFont systemFontOfSize:14];
    guwen_detail.text = @"六号";
    [cell.contentView addSubview:guwen_detail];
    //客户
    UILabel *kehu = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 90, 20)];
    kehu.font = [UIFont systemFontOfSize:14];
    kehu.text = @"客户";
    [cell.contentView addSubview:kehu];
    
    UILabel *kehu_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, 40, [UIScreen mainScreen].bounds.size.width - 100 - 20, 20)];
    kehu_detail.font = [UIFont systemFontOfSize:14];
    kehu_detail.text = @"六号的客户";
    [cell.contentView addSubview:kehu_detail];
    
    //车型
    UILabel *carType = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 90, 20)];
    carType.font = [UIFont systemFontOfSize:14];
    carType.text = @"车型";
    [cell.contentView addSubview:carType];
    
    UILabel *carType_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, 70, [UIScreen mainScreen].bounds.size.width - 100 - 20, [self.carType_heights[indexPath.row] floatValue])];
    carType_detail.numberOfLines = 0;
    carType_detail.font = [UIFont systemFontOfSize:14];
    carType_detail.text = self.dataArray[indexPath.row][@"bottomStr"];
    [cell.contentView addSubview:carType_detail];
    
    //战败原因
    UILabel *reson = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 + [self.carType_heights[indexPath.row] floatValue] + 10, 90, 20)];
    reson.font = [UIFont systemFontOfSize:14];
    reson.text = @"战败原因";
    [cell.contentView addSubview:reson];
    
    LayoutLabel *layout = [[LayoutLabel alloc]initWithLabels:self.dataArray[indexPath.row][@"dataArr"] width:[UIScreen mainScreen].bounds.size.width - 100 - 20 labelFontSize:14 labelHeight:21 labelBackColor:[UIColor orangeColor] labelTextColor:[UIColor blackColor]];
    CGRect layFrame = layout.frame;
    layFrame.origin.x = 110;
    layFrame.origin.y = [self.carType_heights[indexPath.row] floatValue] + 10 + 70;
    layFrame.size.width = [UIScreen mainScreen].bounds.size.width - 100 - 20;
    layFrame.size.height = [self.reson_heights[indexPath.row] floatValue];
    layout.frame = layFrame;
    [cell.contentView addSubview:layout];
    
    //详细原因
    UILabel *de_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, layFrame.origin.y + layFrame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 100 - 20, [self.carType_heights[indexPath.row] floatValue])];
    de_detail.numberOfLines = 0;
    de_detail.font = [UIFont systemFontOfSize:14];
    de_detail.text = self.dataArray[indexPath.row][@"bottomStr"];
    [cell.contentView addSubview:de_detail];
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heights[indexPath.row] floatValue];
}

@end
