
#import "CPTextStyle.h"
#import "CPTextStylePlatformSpecific.h"
#import "CPPlatformSpecificCategories.h"
#import "CPPlatformSpecificFunctions.h"
#import "CPColor.h"

@implementation NSString(CPTextStyleExtensions)

#pragma mark -
#pragma mark Layout

-(CGSize)sizeWithTextStyle:(CPTextStyle *)style
{	
	UIFont *theFont = [UIFont fontWithName:style.fontName size:style.fontSize];
	CGSize textSize = [self sizeWithFont:theFont];	
	return textSize;
}

#pragma mark -
#pragma mark Drawing of Text

-(void)drawAtPoint:(CGPoint)point withTextStyle:(CPTextStyle *)style inContext:(CGContextRef)context
{	
	if ( style.color == nil ) return;
    
    CGContextSaveGState(context);
	CGColorRef textColor = style.color.cgColor;
	
	CGContextSetStrokeColorWithColor(context, textColor);	
	CGContextSetFillColorWithColor(context, textColor);
	
	CPPushCGContext(context);	
	
	UIFont *theFont = [UIFont fontWithName:style.fontName size:style.fontSize];
	[self drawAtPoint:point withFont:theFont];
	
	CGContextRestoreGState(context);
	CPPopCGContext();
}

@end
