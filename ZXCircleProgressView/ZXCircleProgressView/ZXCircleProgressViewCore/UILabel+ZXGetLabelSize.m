//
//  UILabel+ZXGetLabelSize.m
//  ZXCircleProgressView
//
//  Created by 李兆祥 on 2019/1/23.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "UILabel+ZXGetLabelSize.h"

@implementation UILabel (ZXGetLabelSize)
- (CGFloat)getRectWidth{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:self.font}
                                     context:nil];
    return rect.size.width;
}
- (CGFloat)getRectHeight{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width,MAXFLOAT )
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:self.font}
                                          context:nil];
    return rect.size.height;
}
@end
