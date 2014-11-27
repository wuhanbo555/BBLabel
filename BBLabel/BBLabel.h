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
    bTextAlignmentLeft = 0,
    bTextAlignmentRight = 1,
    bTextAlignmentCenter = 2,
    bTextAlignmentJustified = 3,
    bTextAlignmentNatural = 4,
};


//行间距，默认为4.0f
@property(nonatomic,assign)CGFloat linesSpace;
@property(nonatomic,assign)BBTextAlignment bbtextAlignment;

//绘制前先获取label高度，避免重复计算
- (float)wordsDrawInViewHeightWithWidth:(float)width;

@end
