###### 虽然最新版的支付宝中余额宝模块不再显示收益率图表，但是还是仿写了一个，供学习交流。


![](http://upload-images.jianshu.io/upload_images/1265385-894ddada933217ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
---
#####现在有好多第三方绘图的插件，诸如[PNChart](https://github.com/kevinzhow/PNChart)，有的稍微调试一下就可以用了。这里我想讲一下绘制使用UIBezierPath绘制的思路。
---
- 使用方法
```objc
    FJLineView* LineView=[[FJLineView alloc] initWithFrame:CGRectMake(0, 0,ARScreenW - 40, self.chartView.frame.size.height)];
    LineView.xValues=@[@20,@50,@80,@110,@210,@250,@270];                               //设置X值
    LineView.yValues=@[@2.445,@2.444,@2.440,@2.441,@2.439,@2.437,@2.437];              //设置Y值
    LineView.xKeDuValus=@[@"6-22",@"6-23",@"6-24",@"6-25",@"6-26",@"6-27",@"6-28"];    //设置X坐标轴
    LineView.yKeDuValus=@[@2.42,@2.43,@2.44,@2.45,@2.46,@2.47];                        //设置Y坐标轴
    LineView.yValueColor=ARColor(221, 221, 221);
    LineView.xValueColor=ARColor(221, 221, 221);
    [self.chartView addSubview:LineView];
    self.lineView = LineView;
```
- 绘制思路

1 绘制间距
```objc
    CGFloat x_space=(rect.size.width -20) / (self.xKeDuValus.count-1);
    CGFloat y_space=(rect.size.height - kBottomHeight -  kTopMargin - 20) / self.yKeDuValus.count;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
```
2 绘制背景间隔颜色
```objc
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
```
3 画 x 轴
```objc
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
```
4 画 y 轴 
```objc
    UIBezierPath* yPath=[UIBezierPath bezierPath];
    CGPoint yStart=CGPointMake(kStartX, rect.size.height - kBottomHeight);
    CGPoint yEnd=CGPointMake(kStartX,  kTopMargin);
    [yPath moveToPoint:yStart];
    [yPath addLineToPoint:yEnd];
    CGContextAddPath(ctx, yPath.CGPath);
    CGContextStrokePath(ctx);
    UIImage *yImg=[UIImage imageNamed:@"up"];
    [yImg drawInRect:CGRectMake(kStartX - 4, kTopMargin, 8, 10)];
```
5 画 y 轴坐标横线
```objc
    for (int i = 0; i < self.yKeDuValus.count; i++) {
        [ARColor(245, 245, 245) setStroke];
        UIBezierPath* yPathH = [UIBezierPath bezierPath];
        CGContextSetLineWidth(ctx, 1);

        CGPoint startA=CGPointMake(kStartX +40, rect.size.height - kBottomHeight - y_space * (i+1));
        CGPoint endA=CGPointMake(rect.size.width - 5 , rect.size.height - kBottomHeight - y_space * (i+1));
        [yPathH moveToPoint:startA];
        [yPathH addLineToPoint:endA];
        CGContextAddPath(ctx, yPathH.CGPath);
        CGContextStrokePath(cox);
 
        // 画数字
        NSString* yStr=[NSString stringWithFormat:@"%@",self.yKeDuValus[i]];
        CGSize size=[yStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9]}];
            [yStr drawInRect:CGRectMake(kStartX + 4, rect.size.height - 40 - y_space * (i + 1) , kBottomHeight, size.height+1) withAttributes:@{NSForegroundColorAttributeName : self.yValueColor}];
     
    }
    UIBezierPath* path1=[UIBezierPath bezierPath];
    endA=CGPointMake([self.xValues[0] intValue], [self.yValues[0] floatValue]);
    startA=CGPointMake(kStartX, rect.size.height - kBottomHeight -  y_space * ([self.yValues[0] floatValue] -([self.yKeDuValus[0] floatValue]-0.01))*100);
    [path1 moveToPoint:startA];
```
6 绘制底部的分割度线
```objc
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
```
7 计算移到 y 轴的位置
```objc
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
    CGContextStrokePath(ctx);```
8 收益率圈圈
```objc
    for (int i = 0; i < self.xValues.count; i++) {
        CGFloat X =kStartX + x_space * (i) ;//[xValue[i] intValue]; //, [yValue[1] intValue])
        CGFloat Y =rect.size.height - kBottomHeight -  y_space * ([self.yValues[i] floatValue] -([self.yKeDuValus[0] floatValue]-0.01))*100;//设置value值的位置
    
        if (i == self.xValues.count-1) {

            UIImage *circleImg=[UIImage imageNamed:@"七日收益率小圆点"];
            [circleImg drawInRect:CGRectMake(X-4, Y-4, 8, 8)];
        
        }
    }
```
9 填充色
```objc
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
    CGContextFillPath(cox);
```
10 绘制矩形框
```objc
    NSString* text=[NSString stringWithFormat:@"%.1f",[self.yValues.lastObject floatValue]];    CGSize textSize=[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];

    CGRect texRrect=CGRectMake(kStartX + x_space * self.xValues.count, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width, textSize.height);
    CGRect juRect=CGRectMake(kStartX + x_space * self.xValues.count- 5, rect.size.height - kBottomHeight -  y_space * [self.yValues.lastObject intValue] * 0.1 - 20, textSize.width+10, textSize.height);
    UIBezierPath* path3=[UIBezierPath bezierPathWithRoundedRect:juRect cornerRadius:5];

    CGContextAddPath(ctx, path3.CGPath);
    CGContextSetRGBFillColor(ctx, 131.0/255.0, 190.0/255.0, 34.0/255.0, 1.0);
    CGContextFillPath(ctx);
  
    [text drawInRect:texRrect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
```

