//
//  ZXCircleProgressView2.h
//  ZXCircleProgressView
//
//  Created by 李兆祥 on 2019/1/23.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCircleProgressView : UIView
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr;
-(instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr grayColor:(UIColor *)grayColor lightColor:(UIColor *)lightColor;

///当前选中的index
@property(nonatomic,assign)NSUInteger index;
@end

NS_ASSUME_NONNULL_END
