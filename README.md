# ZXCircleProgressView

![Image text](http://www.zxlee.cn/ZXCircleProgressView.gif)

# Demo

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
