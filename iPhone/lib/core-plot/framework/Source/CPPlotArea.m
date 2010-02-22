#import "CPPlotArea.h"
#import "CPAxisSet.h"
#import "CPPlotGroup.h"
#import "CPDefinitions.h"
#import "CPLineStyle.h"

/** @brief A layer drawn on top of the graph layer and behind all plot elements.
 **/
@implementation CPPlotArea

/** @property axisSet
 *	@brief The axis set.
 **/
@synthesize axisSet;

/** @property plotGroup
 *	@brief The plot group.
 **/
@synthesize plotGroup;

#pragma mark -
#pragma mark Init/Dealloc

-(id)initWithFrame:(CGRect)newFrame
{
	if ( self = [super initWithFrame:newFrame] ) {
		axisSet = nil;
		plotGroup = nil;
		
		CPPlotGroup *newPlotGroup = [[CPPlotGroup alloc] init];
		self.plotGroup = newPlotGroup;
		[newPlotGroup release];

		self.needsDisplayOnBoundsChange = YES;
        self.masksToBorder = NO;
}
	return self;
}

-(void)dealloc
{
	[axisSet release];
	[plotGroup release];
	[super dealloc];
}

#pragma mark -
#pragma mark Layout

+(CGFloat)defaultZPosition 
{
	return CPDefaultZPositionPlotArea;
}

-(void)layoutSublayers 
{
	[super layoutSublayers];
	
	CPAxisSet *theAxisSet = self.axisSet;
	if ( theAxisSet ) {
    	// Axis set often draws outside the plot area, so make it as big
        // as the super layer. 
        // Adjust bounds so that the origin of the plot area coincides with the zero point of the axis set
        CGPoint sublayerOrigin = [self.superlayer convertPoint:self.bounds.origin fromLayer:self];
		CGRect newBounds = self.superlayer.bounds;
		newBounds.origin = CGPointMake(-1*sublayerOrigin.x, -1*sublayerOrigin.y);
        theAxisSet.bounds = newBounds;
        theAxisSet.anchorPoint = CGPointZero; 
		theAxisSet.position = [self convertPoint:self.superlayer.bounds.origin fromLayer:self.superlayer];
	}
	
	CPPlotGroup *thePlotGroup = self.plotGroup;
	if ( thePlotGroup ) {
		// Set the bounds so that the plot group coordinates coincide with the 
		// plot area drawing coordinates.
		thePlotGroup.bounds = self.bounds;
		thePlotGroup.anchorPoint = CGPointZero;
		thePlotGroup.position = self.bounds.origin;
	}
}

#pragma mark -
#pragma mark Accessors

-(void)setAxisSet:(CPAxisSet *)newAxisSet
{
	if ( newAxisSet != axisSet ) {
    	axisSet.graph = nil;
		[axisSet removeFromSuperlayer];
		[axisSet release];
		axisSet = [newAxisSet retain];
		if ( axisSet ) {
			[self insertSublayer:axisSet atIndex:0];
            axisSet.graph = self.graph;
		}
        [self setNeedsLayout];
	}	
}

-(void)setPlotGroup:(CPPlotGroup *)newPlotGroup
{
	if ( newPlotGroup != plotGroup ) {
		[plotGroup removeFromSuperlayer];
		[plotGroup release];
		plotGroup = [newPlotGroup retain];
		if ( plotGroup ) {
			[self insertSublayer:plotGroup below:self.axisSet];
		}
        [self setNeedsLayout];
	}	
}

@end
