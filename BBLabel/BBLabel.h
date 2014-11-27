//
//  BBLabel.h
//
//  Created by Boby on 14/11/24.
//
//  Version 1.0

#import <UIKit/UIKit.h>

@interface BBLabel : UILabel


typedef NS_ENUM(NSInteger, BBTextAlignment)
{
    kBBTextAlignmentLeft = 0,
    kBBTextAlignmentRight = 1,
    kBBTextAlignmentCenter = 2,
    kBBTextAlignmentJustified = 3,
    kBBTextAlignmentNatural = 4,
};

typedef NS_ENUM(NSInteger, BBTextVerticalAlignment)
{
    kBBTextVerticalAlignmentTop = 0, // default
    kBBTextVerticalAlignmentMiddle,
    kBBTextVerticalAlignmentBottom,
};



//行间距，默认为4.0f
@property(nonatomic,assign)CGFloat linesSpace;
@property(nonatomic,assign)BBTextAlignment bbtextAlignment;
@property(nonatomic,assign)BBTextVerticalAlignment bbtextVerticalAlignment;
//绘制前先获取label高度，避免重复计算
- (float)wordsDrawInViewHeightWithWidth:(float)width;

@end
