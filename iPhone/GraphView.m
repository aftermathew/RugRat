//
//  GraphView.m
//  RugRat
//
//  Created by Mathew Chasan on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView


- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Initialization code
  }
  return self;
}


//START:code.drawing.bar.graph.path
-(CGPathRef) pathInRect:(CGRect)rect {
  CGMutablePathRef path = CGPathCreateMutable();
  CGFloat radius = CGRectGetHeight(rect) / 2.0f;
  CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect) - radius, 
                       CGRectGetMinY(rect));
  CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - radius, 
               CGRectGetMinY(rect) + radius, 
               radius, -M_PI / 2.0f, M_PI / 2.0f, NO);
  CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
  CGPathCloseSubpath(path);
  CGPathRef imutablePath = CGPathCreateCopy(path);
  CGPathRelease(path);
  return imutablePath;
}
//END:code.drawing.bar.graph.path

//START:code.drawing.bar.graph.drawRect:
- (void)drawRect:(CGRect)rect {
  CGSize size = self.bounds.size;
  CGFloat width1 = size.width * 0.75f; //<label id="code.drawing.bar.graph.bars.width"/>
  CGFloat width2 = size.width * 0.35f;
  CGFloat width3 = size.width * 0.55f;
  
  CGFloat height = size.height * 0.2f; //<label id="code.drawing.bar.graph.height"/>
  
  CGRect one = CGRectMake(0.0f, height + 5.0f, //<label id="code.drawing.bar.graph.bars.rect"/>
                          width1, height - 10.0f);
  CGRect oneText = CGRectMake(10.0f, height + 25.0f,
                              width1, height - 30.0f);
  CGRect two = CGRectMake(0.0f, 2.0 * (height + 5.0f), 
                          width2, height - 10.0f);
  CGRect twoText = CGRectMake(10.0f, 2.0 * height + 30.0f, 
                              width2, height - 30.0f);
  CGRect three = CGRectMake(0.0f, 3.0 * (height + 5.0f),
                            width3, height - 10.0f);
  CGRect threeText = CGRectMake(10.0f, 3.0 * height + 35.0f, 
                                width3, height - 30.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  [[UIColor blueColor] setFill];
  CGPathRef pathOne = [self pathInRect:one]; //<label id="code.drawing.bar.graph.one"/>
  CGContextAddPath(ctx, pathOne);
  CGPathRelease(pathOne);
  CGContextFillPath(ctx); 
  [[UIColor blackColor] setFill];
  [@"One" drawInRect:oneText withFont:[UIFont systemFontOfSize:34]];//<label id="code.drawing.bar.graph.one.label"/>
  [[UIColor redColor] setFill];
  CGPathRef pathTwo = [self pathInRect:two];
  CGContextAddPath(ctx, pathTwo);
  CGPathRelease(pathTwo);
  CGContextFillPath(ctx);
  [[UIColor blackColor] setFill];
  [@"Two" drawInRect:twoText withFont:[UIFont systemFontOfSize:34]];
  [[UIColor yellowColor] setFill];
  CGPathRef pathThree = [self pathInRect:three];
  CGContextAddPath(ctx, pathThree);
  CGPathRelease(pathThree);
  CGContextFillPath(ctx);
  [[UIColor blackColor] setFill];
  [@"Three" drawInRect:threeText withFont:[UIFont systemFontOfSize:34]];
}
//END:code.drawing.bar.graph.drawRect:



- (void)dealloc {
  [super dealloc];
}


@end
