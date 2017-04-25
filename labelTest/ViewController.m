//
//  ViewController.m
//  labelTest
//
//  Created by 沙少盼 on 2017/4/24.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import "ViewController.h"
#import "LayoutLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@"a",@"我的实打实大师打款哈萨克电话卡十多块撒谎按实际会打瞌睡的卡号地块哈萨克的哈萨克",@"爱上大环境的撒",@"大手大脚",@"啊",@"我的天",@"涉及到哈索多三涉及到",@"oh",@"shit",@"haha",@"wowowo"];
    LayoutLabel *label = [[LayoutLabel alloc]initWithLabels:arr width:self.view.bounds.size.width labelFontSize:14 labelHeight:21 labelBackColor:[UIColor blueColor]labelTextColor:[UIColor whiteColor]];
    CGFloat height = [label getLayoutViewHeightWithLabels:arr];
    label.frame = CGRectMake(0, 50,self.view.bounds.size.width , height);
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
