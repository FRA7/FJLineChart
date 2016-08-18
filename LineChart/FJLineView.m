//
//  FJLineView.m
//  AntRice
//
//  Created by JYH on 16/7/14.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

#import "FJLineView.h"
#import "UIView+LineView.h"

#define kStartX  00.0
#define kBottomHeight  30.0  // x 轴距离底部高度
#define kTopMargin    00.0   // y 轴距离顶部的高度



#define ARColor(r, g, b) \
[UIColor colorWithRed:(r) / 255.0f \
green:(g) / 255.0f \
blue:(b) / 255.0f \
alpha:1]


@interface FJLineView()

@property(nonatomic,assign)CGPoint perviousPoint;

@end

@implementation FJLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];

    }
    return self;
}

-(void)setXValues:(NSArray *)xValues
{
    _xValues=xValues;
    [self setNeedsDisplay];
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues=yValues;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    // 间距
    CGFloat x_space=(rect.size.width -20) / (self.xKeDuValus.count-1);
    CGFloat y_space=(rect.size.height - kBottomHeight -  kTopMargin - 20) / self.yKeDuValus.count;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    
    // 绘制背景间隔颜色
    for (int i = 0; i < self.xKeDuValus.count; i++) {
        [ARColor(255, 253, 251) setStroke];//设置背景颜色
        
        if (i%2 != 0) {//交叉背景
            
            UIBezierPath* bgPathH = [UIBezierPath bezierPath];
            CGContextSetLineWidth(ctx, x_space);//设置宽度
            CGPoint startA=CGPointMake(kStartX + x_space * i +0.5 * x_space, rect.size.height - kBottomHeight);
            CGPoint endA=CGPointMake(kStartX + x_space * i+0.5 * x_space ,kTopMargin);
            [bgPathH moveToPoint:startA];
            [bgPathH addLineToPoint:endA];
            CGContextAddPath(ctx, bgPathH.CGPath);
            CGContextStrokePath(ctx);
            
        }
    }
    
    // 画 x 轴
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint startA=CGPointMake(kStartX, rect.size.height - kBottomHeight);
    CGPoint endA=CGPointMake(rect.size.width - 5, rect.size.height - kBottomHeight);
    [path moveToPoint:startA];
    [path addLineToPoint:endA];
    CGContextAddPath(ctx, path.CGPath);
    [ARColor(245, 245, 245) set];
    CGContextSetLineWidth(ctx, 1);
    // 渲染
    CGContextStrokePath(ctx);
    

    /** 画 y 轴 */
    UIBezierPath* yPath=[UIBezierPath bezierPath];
    CGPoint yStart=CGPointMake(kStartX, rect.size.height - kBottomHeight);
    CGPoint yEnd=CGPointMake(kStartX,  kTopMargin);
    [yPath moveToPoint:yStart];
    [yPath addLineToPoint:yEnd];
    CGContextAddPath(ctx, yPath.CGPath);
    CGContextStrokePath(ctx);
    UIImage *yImg=[UIImage imageNamed:@"up"];
    [yImg drawInRect:CGRectMake(kStartX - 4, kTopMargin, 8, 10)];
    
    
    
    /** 画 y 轴坐标横线*/
    for (int i = 0; i < self.yKeDuValus.count; i++) {
        [ARColor(245, 245, 245) setStroke];

        UIBezierPath* yPathH = [UIBezierPath bezierPath];
        CGContextSetLineWidth(ctx, 1);

        CGPoint startA=CGPointMake(kStartX +40, rect.size.height - kBottomHeight - y_space * (i+1));
        CGPoint endA=CGPointMake(rect.size.width - 5 , rect.size.height - kBottomHeight - y_space * (i+1));
        [yPathH moveToPoint:startA];
        [yPathH addLineToPoint:endA];
        CGContextAddPath(ctx, yPathH.CGPath);
        CGContextStrokePath(ctx);

        
        // 画数字
        NSString* yStr=[NSString stringWithFormat:@"%@",self.yKeDuValus[i]];
        CGSize size=[yStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9]}];
            [yStr drawInRect:CGRectMake(kStartX + 4, rect.size.height - 40 - y_space * (i + 1) , kBottomHeight, size.height+1) withAttributes:@{NSForegroundColorAttributeName : self.yValueColor}];
        
    }
    UIBezierPath* path1=[UIBezierPath bezierPath];
    endA=CGPointMake([self.xValues[0] intValue], [self.yValues[0] floatValue]);
    startA=CGPointMake(kStartX, rect.size.height - kBottomHeight -  y_space * ([self.yValues[0] floatValue] -([self.yKeDuValus[0] floatValue]-0.01))*100);
    [path1 moveToPoint:startA];
    
    
    // 绘制底部的分割度线
    for (int i = 0; i < self.xKeDuValus.count; i++) {
        [ARColor(245, 245, 245) setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx,kStartX + x_space * i , rect.size.height - kBottomHeight);
        CGContextAddLineToPoint(ctx,kStartX + x_space * i,kTopMargin);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        NSString *x_titleStr= [NSString stringWithFormat:@"%@",self.xKeDuValus[i] ];
        CGSize titleSize=[x_titleStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        if (i == 0) {
            [x_titleStr drawInRect:CGRectMake(17+kStartX + x_space * i - titleSize.width*0.5, rect.size.height - 25, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0],NSForegroundColorAttributeName:self.xValueColor}];
        }else{
            [x_titleStr drawInRect:CGRectMake(2+kStartX + x_space * i - titleSize.width*0.5, rect.size.height - 25, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0],NSForegroundColorAttributeName:self.xValueColor}];
        }
        
        
    }

    
    
    /** 计算移到 y 轴的位置*/
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i) ;//[xValue[i] intValue]; //, [yValue[1] intValue])
        CGFloat Y =rect.size.height - kBottomHeight -  y_space * ([self.yValues[i] floatValue] -([self.yKeDuValus[0] floatValue]-0.01))*100;//设置value值的位置
        [path1 addLineToPoint:CGPointMake(X, Y)];
        
        if (i == self.xValues.count-1) {
            
            //收益率标签背景
            UIImage *labelImg=[UIImage imageNamed:@"七日收益率背景图"];
            [labelImg drawInRect:CGRectMake(X-41, Y-23-6, 41, 23)];
            
            NSString* lastLabelStr=[NSString stringWithFormat:@"%.3f",[self.yValues[i] floatValue]];
            [lastLabelStr drawInRect:CGRectMake(X-41 + 4, Y-23-6 + 2, 41, 23) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : ARColor(255, 255, 255)}];
        }
    }
    
    
    
    CGContextAddPath(ctx, path1.CGPath);
    CGContextSetLineWidth(ctx, 2);//设置折线线宽
    CGContextSetRGBStrokeColor(ctx, 255.0/255.0, 88.0/255.0, 1.0/255.0, 1.0);
    CGContextStrokePath(ctx);

    
    
    //收益率圈圈
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i) ;//[xValue[i] intValue]; //, [yValue[1] intValue])
        CGFloat Y =rect.size.height - kBottomHeight -  y_space * ([self.yValues[i] floatValue] -([self.yKeDuValus[0] floatValue]-0.01))*100;//设置value值的位置
    
        if (i == self.xValues.count-1) {

            UIImage *circleImg=[UIImage imageNamed:@"七日收益率小圆点"];
            [circleImg drawInRect:CGRectMake(X-4, Y-4, 8, 8)];
        
        }
    }
    
    
    
    // 填充色
    UIBezierPath* path2=[UIBezierPath bezierPath];
    endA=CGPointMake(x_space * 0, [self.yValues[0] intValue]);
//    [path2 moveToPoint:startA];//填充色  ---注释此行会去除填充色
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i+1) ;
        CGFloat Y = rect.size.height - kBottomHeight -  y_space * [self.yValues[i] intValue] * 0.1;
        [path2 addLineToPoint:CGPointMake(X, Y)];
        if (i == self.xValues.count - 1) {
            [path2 addLineToPoint:CGPointMake(kStartX + x_space *  (i + 1), rect.size.height  -  kBottomHeight)];
        }
    }

    CGContextAddPath(ctx, path2.CGPath);
    CGContextSetRGBFillColor(ctx,215.0/255.0, 236.0/255.0, 177.0/255.0, 1.0);
    CGContextFillPath(ctx);
    
    // 绘制矩形框
    NSString* text=[NSString stringWithFormat:@"%.1f",[self.yValues.lastObject floatValue]];    CGSize textSize=[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];

    CGRect texRrect=CGRectMake(kStartX + x_space * self.xValues.count, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width, textSize.height);
    CGRect juRect=CGRectMake(kStartX + x_space * self.xValues.count- 5, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width+10, textSize.height);
    UIBezierPath* path3=[UIBezierPath bezierPathWithRoundedRect:juRect cornerRadius:5];

    CGContextAddPath(ctx, path3.CGPath);
    CGContextSetRGBFillColor(ctx, 131.0/255.0, 190.0/255.0, 34.0/255.0, 1.0);
    CGContextFillPath(ctx);
    
    
    [text drawInRect:texRrect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    

}


@end
