//
//  ZXCircleProgressView2.m
//  ZXCircleProgressView
//
//  Created by 李兆祥 on 2019/1/23.
//  Copyright © 2019 李兆祥. All rights reserved.
//
#define SubVerticalMargin 6.0 //CircleLabel和TitleLabel之间的垂直距离
#define CircleLabelSize 16.0 //CircleLabel的大小
#define TitleLabelMargin 30.0 //TitleLabel与边缘的间距，越大则间距越大
#define TagOffset 888 //ContentV中tag的偏移，避免冲突

#define DefaultGrayColor [UIColor lightGrayColor] //灰色颜色值
#define DefaultLightColor [UIColor redColor] //点亮颜色值

#define Setp 4 //进度条每次增加（或减少）像素 越高则变化越快
#import "ZXCircleProgressView.h"
#import "UILabel+ZXGetLabelSize.h"
#import "NSObject+ZXKVO.h"
@interface ZXCircleProgressView()
@property(nonatomic,strong)NSMutableArray *contentVArr;
@property(nonatomic,assign)NSUInteger lastIndex;
@property(nonatomic,weak)UIView *lightProgressView;
@property(nonatomic,assign)CGFloat perProgW;
@property(nonatomic,assign)BOOL back;
///灰色时颜色（选填）
@property(nonatomic,strong)UIColor *grayColor;
///点亮时颜色（选填）
@property(nonatomic,strong)UIColor *lightColor;

@end
@implementation ZXCircleProgressView
#pragma mark 初始化方法
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr{
    
    return [self initWithFrame:frame titlesArr:titlesArr grayColor:nil lightColor:nil];
}
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr grayColor:(UIColor *)grayColor lightColor:(UIColor *)lightColor{
    if(self = [super initWithFrame:frame]){
        self.grayColor = grayColor ? grayColor : DefaultGrayColor;
        self.lightColor = lightColor ? lightColor : DefaultLightColor;
        [self creatViewWithTitlesArr:titlesArr];
        self.index = 0;
    }
    return self;
}
#pragma mark 根据传进来的titles数组创建视图
-(void)creatViewWithTitlesArr:(NSArray *)titlesArr{
    NSArray *titleLabelsArr = [self getTitleLabelsWithCount:titlesArr.count];
    CGFloat maxTitleLabelW = [self getTextMaxWidthWithTitlesArr:titlesArr Labels:titleLabelsArr];
    CGFloat margin = 0;
    CGFloat containVW = maxTitleLabelW + TitleLabelMargin / 2;
    CGFloat containVX = (self.frame.size.width - containVW * titlesArr.count - margin * (titlesArr.count - 1)) / 2;
    CGFloat progressX = 0;
    CGFloat progressY = 0;
    CGFloat progressW = 0;
    for (NSUInteger i = 0; i < titlesArr.count; i++) {
        UIView *containV = [[UIView alloc]init];
        containV.frame = CGRectMake(containVX + (containVW + margin) * i, 0, containVW, self.frame.size.height);
        UILabel *circleLabel = [self getCircleLabelWithIndex:i supV:containV];
        containV.tag = TagOffset + i;
        [containV addSubview:circleLabel];
        
        UILabel *titleLabel = titleLabelsArr[i];
        titleLabel.frame = CGRectMake(0, CGRectGetMaxY(circleLabel.frame) + SubVerticalMargin / 2, containV.frame.size.width, titleLabel.frame.size.height);
        titleLabel.textColor = circleLabel.backgroundColor;
        [containV addSubview:titleLabel];
        
        
        [self.contentVArr addObject:containV];
        [self addSubview:containV];
        CGRect convertCircleFrame = [self convertRect:circleLabel.frame fromView:containV];
        if(i == 0){
            progressX = convertCircleFrame.origin.x + circleLabel.frame.size.height / 2;
            progressY = convertCircleFrame.origin.y + circleLabel.frame.size.height / 2;
        }
        if(i == 0 || i == titlesArr.count - 1){
            progressW += (containV.frame.size.width - circleLabel.frame.size.width) / 2 + circleLabel.frame.size.width / 2;
            self.perProgW = (containV.frame.size.width - circleLabel.frame.size.width) / 2 + circleLabel.frame.size.width / 2;
            
        }else{
            progressW += 2 * ((containV.frame.size.width - circleLabel.frame.size.width) / 2 + circleLabel.frame.size.width / 2);
        }
    }
    UIView *grayProgressV = [[UIView alloc]init];
    grayProgressV.frame = CGRectMake(progressX, progressY, progressW, 1);
    grayProgressV.backgroundColor = self.grayColor;
    
    UIView *lightProgressV = [[UIView alloc]init];
    lightProgressV.frame = CGRectMake(progressX, progressY, 0, 1);
    lightProgressV.backgroundColor = self.lightColor;
    /*
    [lightProgressV obsKey:@"frame" handler:^(id newData, id oldData, id owner) {
        CGRect rect = ((UIView *)owner).frame;
        int proW = roundf(rect.size.width * 100);
        int perW = roundf(self.perProgW * 2 * 100);
        if(ABS(proW % perW) < 100){
            NSUInteger currenIndex = proW / perW;
            NSLog(@"currenIndex--%d",currenIndex);
        }
        
    }];
     */
    
    [self addSubview:lightProgressV];
    [self insertSubview:lightProgressV belowSubview:self.subviews.firstObject];
    [self insertSubview:grayProgressV belowSubview:lightProgressV];
    self.lightProgressView =lightProgressV;
}

#pragma mark 获取titles数组中长度最长的字符串长度，并以此作为contentV的宽
-(CGFloat)getTextMaxWidthWithTitlesArr:(NSArray *)titlesArr Labels:(NSArray *)labels{
    if(titlesArr.count != labels.count)return 0;
    CGFloat conLabelMaxW = 0;
    for (NSUInteger i = 0; i < titlesArr.count; i++) {
        UILabel *conLabel = labels[i];
        conLabel.text = titlesArr[i];
        CGFloat conLabelW = [conLabel getRectWidth];
        conLabelMaxW = conLabelMaxW < conLabelW ? conLabelW : conLabelMaxW;
    }
    return conLabelMaxW;
}

#pragma mark 获取TitleLabel
-(NSArray *)getTitleLabelsWithCount:(NSUInteger)count{
    NSMutableArray *labelsArr = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake(0, 0, 0, 15);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [labelsArr addObject:label];
    }
    return labelsArr;
}

#pragma mark 获取CircleLabel
-(UILabel *)getCircleLabelWithIndex:(NSUInteger )index supV:(UIView *)supV{
    UILabel *circleLabel = [[UILabel alloc]init];
    circleLabel.frame = CGRectMake((supV.frame.size.width - CircleLabelSize) / 2, (supV.frame.size.height - CircleLabelSize) / 2 - SubVerticalMargin / 2 - 2, CircleLabelSize, CircleLabelSize);
    circleLabel.backgroundColor = self.grayColor;
    circleLabel.font = [UIFont systemFontOfSize:10];
    circleLabel.textAlignment = NSTextAlignmentCenter;
    circleLabel.clipsToBounds = YES;
    circleLabel.layer.cornerRadius = circleLabel.frame.size.width / 2.0;
    circleLabel.textColor = [UIColor whiteColor];
    circleLabel.text = [NSString stringWithFormat:@"%lu",index + 1];
    circleLabel.adjustsFontSizeToFitWidth = YES;
    return circleLabel;
}


#pragma mark 重写index的set方法
-(void)setIndex:(NSUInteger)index{
    _index = index;
    self.back = self.lastIndex > self.index;
    self.lastIndex = self.index;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(indexAnimate:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark 动画效果函数
-(void)indexAnimate:(CADisplayLink *)cl{
    CGFloat progressW = self.index * self.perProgW * 2;
    int step = self.back ? -Setp : Setp;
    CGFloat newProW = self.lightProgressView.frame.size.width + step;
    if(newProW > 0 && newProW < (self.contentVArr.count) * self.perProgW * 2){
        self.lightProgressView.frame = CGRectMake(self.lightProgressView.frame.origin.x, self.lightProgressView.frame.origin.y,self.lightProgressView.frame.size.width + step, 1);
    }
    int currenIndex = [self getCurrenIndexWithFrame:self.lightProgressView.frame];
    if(currenIndex >= 0){
        
        if(step >= 0){
            UIView *currenContentV = self.contentVArr[currenIndex];
            [self lightContentView:currenContentV];
        }else{
            if(currenIndex + 1 < self.contentVArr.count){
                UIView *currenContentV = self.contentVArr[currenIndex + 1];
                [self grayContentView:currenContentV];
            }
        }
    }
    
    if(step >= 0 && self.lightProgressView.frame.size.width >= progressW){
        [cl invalidate];
        cl = nil;
    }
    if(step < 0 && (self.lightProgressView.frame.size.width <= progressW || (self.index == 0 && self.lightProgressView.frame.size.width <= CircleLabelSize / 2.0))){
        [cl invalidate];
        cl = nil;
    }
    
}
#pragma mark 根据frame获取当前动画进行到的index
-(int)getCurrenIndexWithFrame:(CGRect)frame{
    CGRect rect = frame;
    int proW = roundf(rect.size.width * 100);
    int perW = roundf(self.perProgW * 2 * 100);
    if(ABS(proW % perW) < 1000){
        NSUInteger currenIndex = proW / perW;
        return (int)currenIndex;
    }
    return -1;
}
#pragma mark 将contentV点亮
-(void)lightContentView:(UIView * )contentV{
    UILabel *circleLabel = contentV.subviews[0];
    UILabel *titleLabel = contentV.subviews[1];
    circleLabel.backgroundColor = self.lightColor;
    titleLabel.textColor = self.lightColor;
}
#pragma mark 将contentV变灰
-(void)grayContentView:(UIView * )contentV{
    UILabel *circleLabel = contentV.subviews[0];
    UILabel *titleLabel = contentV.subviews[1];
    circleLabel.backgroundColor = self.grayColor;
    titleLabel.textColor = self.grayColor;
}

#pragma mark 懒加载
-(NSMutableArray *)contentVArr{
    if(!_contentVArr){
        _contentVArr = [NSMutableArray array];
    }
    return _contentVArr;
}
@end
