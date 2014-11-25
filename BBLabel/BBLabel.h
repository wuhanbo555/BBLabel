//
//  BBLabel.h
//  TBReader
//
//  Created by 吴瀚波 on 14/11/24.
//

#import <UIKit/UIKit.h>

@interface BBLabel : UILabel

//行间距，默认为4.0f
@property(nonatomic,assign)CGFloat linesSpace;


//绘制前先获取label高度，避免重复计算
- (float)wordsDrawInViewHeightWithWidth:(float)width;

@end
