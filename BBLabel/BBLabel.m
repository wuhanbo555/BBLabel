//
//  BBLabel.m
//  TBReader
//
//  Created by 吴瀚波 on 14/11/24.
//

#import "BBLabel.h"
#import <CoreText/CoreText.h>
@interface BBLabel()

@property(nonatomic,strong)NSMutableAttributedString *attributedString;
@property(nonatomic,strong)NSMutableAttributedString *replaceString;
@property(nonatomic,strong)NSString *oldStr;
@property(nonatomic,assign)CGFloat oldLinesSpace;
@property(nonatomic,assign)long allLinesNum;
@property(nonatomic,assign)long currLinesNum;
@end

@implementation BBLabel

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.linesSpace = 4.0f;
    }
    return self;
}
//外部调用设置行间距
-(void)setLinesSpace:(CGFloat)linesSpace
{
    _linesSpace = linesSpace;
    [self setNeedsDisplay];
}


/*
 *初始化AttributedString并进行相应设置
 */
- (NSMutableAttributedString *) attributedStringAddStyle:(NSString *)attStr
{
    if (!attStr)
    {
        return nil;
    }
    NSMutableAttributedString *attString =[[NSMutableAttributedString alloc]initWithString:attStr];
    
    //设置字体及大小
    CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
    [attString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0,[attString length])];
    CFRelease(font);
    
    //设置字体颜色
    [attString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[attString length])];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;
    if(self.textAlignment == NSTextAlignmentCenter)
    {
        alignment = kCTCenterTextAlignment;
    }
    if(self.textAlignment == NSTextAlignmentRight)
    {
        alignment = kCTRightTextAlignment;
    }
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(CTTextAlignment);
    alignmentStyle.value = &alignment;
    
    //设置行间距
    CGFloat lineSpace = self.linesSpace;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value =&lineSpace;
    
    //给文本添加设置
    CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,2);
    [attString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attString length])];
    CFRelease(style);
    
    return attString;
}


// 开始绘制
-(void) drawTextInRect:(CGRect)requestedRect
{
    if (![self.oldStr isEqualToString:self.text] || self.linesSpace != self.oldLinesSpace)
    {
        self.oldStr = self.text;
        self.oldLinesSpace = self.linesSpace;
        self.attributedString = [self attributedStringAddStyle:self.text];
    }
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    
    CGMutablePathRef columnPath = CGPathCreateMutable();
    
    CGPathAddRect(columnPath, NULL ,self.bounds);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), columnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    

    CFArrayRef lines = CTFrameGetLines(frame);
    long lineNumber = self.currLinesNum;
    CGPoint lineOrigins[lineNumber];
    CTFrameGetLineOrigins(frame,CFRangeMake(0,lineNumber), lineOrigins);
    
    for(int lineIndex = 0;lineIndex < lineNumber;lineIndex++)
    {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines,lineIndex);
        CTLineRef lastLine = NULL;
        if (lineNumber != self.allLinesNum)
        {
            if (lineIndex == lineNumber - 1)
            {
                CTLineTruncationType ltt = kCTLineTruncationEnd;
                CGSize size = CGSizeMake(100,100);
                CGSize lablesize;
                if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
                {
                    NSDictionary *attributes = @{NSFontAttributeName:self.font};
                    lablesize = [@"\u2026" boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                    attributes:attributes
                                                        context:nil].size;
                }
                else
                {
                    lablesize = [@"\u2026" sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
                }
                line = CTLineCreateTruncatedLine(line, self.bounds.size.width - lablesize.width, ltt, NULL);
                CFRange range  = CTLineGetStringRange(line);
                CFRelease(line);
                NSRange ocrange = NSMakeRange(range.location, range.length);
                NSString *substr = [self.text substringWithRange:ocrange];
                substr = [substr stringByAppendingString:@"\u2026"];
                if (!self.replaceString)
                {
                    self.replaceString = [self attributedStringAddStyle:substr];
                }
                lastLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.replaceString);
            }
        }
        
        if (lastLine)
        {
            CGContextSetTextPosition(context,lineOrigin.x,lineOrigin.y);
            CTLineDraw(lastLine,context);
            CFRelease(lastLine);
        }
        else
        {
            CGContextSetTextPosition(context,lineOrigin.x,lineOrigin.y);
            CTLineDraw(line,context);
        }
    }
    
    //释放
    
    CGPathRelease(columnPath);
    
    CFRelease(framesetter);
    
    UIGraphicsPushContext(context);
    
    CFRelease(frame);
}

//计算高度
- (float)wordsDrawInViewHeightWithWidth:(float)width
{
    if (![self.oldStr isEqualToString:self.text] || self.linesSpace != self.oldLinesSpace)
    {
        self.oldStr = self.text;
        self.oldLinesSpace = self.linesSpace;
        self.attributedString = [self attributedStringAddStyle:self.text];
    }
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    
    
    
    CFArrayRef lines = CTFrameGetLines(textFrame);
    self.allLinesNum = (long)CFArrayGetCount(lines);
    self.currLinesNum= self.numberOfLines == 0 ? self.allLinesNum : MIN(self.allLinesNum, self.numberOfLines);
    CGPoint origins[self.currLinesNum];
    CTFrameGetLineOrigins(textFrame,CFRangeMake(0,self.currLinesNum), origins);

    int line_y = (float) origins[self.currLinesNum -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = CFArrayGetValueAtIndex(lines,self.currLinesNum - 1);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    CFRelease(framesetter);
    CGPathRelease(path);
    return total_height;
}

@end
