//
//  ViewController.m
//  ZXCircleProgressView
//
//  Created by 李兆祥 on 2019/1/23.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "ViewController.h"
#import "ZXCircleProgressView.h"
@interface ViewController ()

@property (weak, nonatomic) ZXCircleProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titlesArr = @[@"test1",@"test2",@"test3",@"test4",@"test5"];
    ZXCircleProgressView *V = [[ZXCircleProgressView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 60) titlesArr:titlesArr];
    V.backgroundColor = [UIColor yellowColor];
    self.progressView = V;
    [self.view addSubview:V];
}

- (IBAction)segIndexChangeAction:(id)sender {
    UISegmentedControl *segV = (UISegmentedControl *)sender;
    self.progressView.index = segV.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
