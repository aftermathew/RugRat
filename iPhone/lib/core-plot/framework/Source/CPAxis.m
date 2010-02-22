
#import "CPAxis.h"
#import "CPPlotSpace.h"
#import "CPUtilities.h"
#import "CPPlotRange.h"
#import "CPLineStyle.h"
#import "CPTextStyle.h"
#import "CPTextLayer.h"
#import "CPAxisLabel.h"
#import "CPAxisTitle.h"
#import "CPPlatformSpecificCategories.h"
#import "CPUtilities.h"
#import "NSDecimalNumberExtensions.h"

///	@cond
@interface CPAxis ()

@property (nonatomic, readwrite, assign) BOOL needsRelabel;
@property (nonatomic, readwrite, assign) BOOL labelFormatterChanged;

-(void)tickLocationsBeginningAt:(NSDecimal)beginNumber increasing:(BOOL)increasing majorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations;
-(NSDecimal)nextLocationFromCoordinateValue:(NSDecimal)coord increasing:(BOOL)increasing interval:(NSDecimal)interval;

-(NSSet *)filteredTickLocations:(NSSet *)allLocations;
-(void)updateAxisLabelsAtLocations:(NSSet *)locations;

@end
///	@endcond

#pragma mark -

/**	@brief An abstract axis class.
 **/
@implementation CPAxis

/// @defgroup CPAxis CPAxis
/// @{

// Axis

/**	@property axisLineStyle
 *  @brief The line style for the axis line.
 *	If nil, the line is not drawn.
 **/
@synthesize axisLineStyle;

/**	@property coordinate
 *	@brief The axis coordinate.
 **/
@synthesize coordinate;

/**	@property labelingOrigin
 *	@brief The origin used for axis labels.
 *  The default value is 0. It is only used when the axis labeling
 *  policy is CPAxisLabelingPolicyFixedInterval. The origin is
 *  a reference point used to being labeling. Labels are added
 *	at the origin, as well as at fixed intervals above and below
 *  the origin.
 **/
@synthesize labelingOrigin;

/**	@property tickDirection
 *	@brief The tick direction.
 *  The direction is given as the sign that ticks extend along
 *  the axis (eg positive, or negative).
 **/
@synthesize tickDirection;

// Title

/**	@property axisTitleTextStyle
 *  @brief  The text style used to draw the axis title text.
 **/

@synthesize titleTextStyle;

/**	@property axisTitle
 *  @brief The axis title.
 *	If nil, no title is drawn.
 **/

@synthesize axisTitle;

/**	@property axisTitleOffset
 *	@brief The offset distance between the axis title and the axis line.
 **/

@synthesize titleOffset;

/**	@property title
 *	@brief A convenience property for setting the text title of the axis.
 **/

@synthesize title;

/**	@property axisTitlePosition
 *	@brief The position along the axis where the axis title should be centered.
 *  If NaN, just place the axis title at the middle of the axis range
 **/

@synthesize titleLocation;

// Plot space

/**	@property plotSpace
 *	@brief The plot space for the axis.
 **/
@synthesize plotSpace;

// Labels

/**	@property axisLabelingPolicy
 *	@brief The axis labeling policy.
 **/
@synthesize labelingPolicy;

/**	@property axisLabelOffset
 *	@brief The offset distance between the tick marks and labels.
 **/
@synthesize labelOffset;

/**	@property axisLabelRotation
 *	@brief The rotation of the axis labels in radians.
 *  Set this property to M_PI/2.0 to have labels read up the screen, for example.
 **/
@synthesize labelRotation;

/**	@property axisLabelTextStyle
 *	@brief The text style used to draw the label text.
 **/
@synthesize labelTextStyle;

/**	@property axisLabelFormatter
 *	@brief The number formatter used to format the label text.
 *  If you need a non-numerical label, such as a date, you can use a formatter than turns
 *  the numerical plot coordinate into a string (eg 'Jan 10, 2010'). 
 *  The CPTimeFormatter is useful for this purpose.
 **/
@synthesize labelFormatter;

/**	@property axisLabels
 *	@brief The set of axis labels.
 **/
@synthesize axisLabels;

/**	@property needsRelabel
 *	@brief If YES, the axis needs to be relabeled before the layer content is drawn.
 **/
@synthesize needsRelabel;

/**	@property labelExclusionRanges
 *	@brief An array of CPPlotRange objects. Any tick marks and labels falling inside any of the ranges in the array will not be drawn.
 **/
@synthesize labelExclusionRanges;

/**	@property delegate
 *	@brief The axis delegate.
 **/
@synthesize delegate;

// Major ticks

/**	@property majorIntervalLength
 *	@brief The distance between major tick marks expressed in data coordinates.
 **/
@synthesize majorIntervalLength;

/**	@property majorTickLineStyle
 *  @brief The line style for the major tick marks.
 *	If nil, the major ticks are not drawn.
 **/
@synthesize majorTickLineStyle;

/**	@property majorTickLength
 *	@brief The length of the major tick marks.
 **/
@synthesize majorTickLength;

/**	@property majorTickLocations
 *	@brief A set of axis coordinates for all major tick marks.
 **/
@synthesize majorTickLocations;

/**	@property preferredNumberOfMajorTicks
 *	@brief The number of ticks that should be targeted when autogenerating positions.
 *  This property only applies when the CPAxisLabelingPolicyAutomatic policy is in use.
 **/
@synthesize preferredNumberOfMajorTicks;

// Minor ticks

/**	@property minorTicksPerInterval
 *	@brief The number of minor tick marks drawn in each major tick interval.
 **/
@synthesize minorTicksPerInterval;

/**	@property minorTickLineStyle
 *  @brief The line style for the minor tick marks.
 *	If nil, the minor ticks are not drawn.
 **/
@synthesize minorTickLineStyle;

/**	@property minorTickLength
 *	@brief The length of the minor tick marks.
 **/
@synthesize minorTickLength;

/**	@property minorTickLocations
 *	@brief A set of axis coordinates for all minor tick marks.
 **/
@synthesize minorTickLocations;

// Grid Lines

/**	@property majorGridLineStyle
 *  @brief The line style for the major grid lines.
 *	If nil, the major grid lines are not drawn.
 **/
@synthesize majorGridLineStyle;

/**	@property minorGridLineStyle
 *  @brief The line style for the minor grid lines.
 *	If nil, the minor grid lines are not drawn.
 **/
@synthesize minorGridLineStyle;

@synthesize labelFormatterChanged;

#pragma mark -
#pragma mark Init/Dealloc

-(id)initWithFrame:(CGRect)newFrame
{
	if ( self = [super initWithFrame:newFrame] ) {
		plotSpace = nil;
		majorTickLocations = [[NSSet set] retain];
		minorTickLocations = [[NSSet set] retain];
        preferredNumberOfMajorTicks = 5;
		minorTickLength = 3.0;
		majorTickLength = 5.0;
		labelOffset = 2.0;
        labelRotation = 0.0;
		titleOffset = 30.0;
		axisLineStyle = [[CPLineStyle alloc] init];
		majorTickLineStyle = [[CPLineStyle alloc] init];
		minorTickLineStyle = [[CPLineStyle alloc] init];
		majorGridLineStyle = nil;
		minorGridLineStyle = nil;
		labelingOrigin = [[NSDecimalNumber zero] decimalValue];
		majorIntervalLength = [[NSDecimalNumber one] decimalValue];
		minorTicksPerInterval = 1;
		coordinate = CPCoordinateX;
		labelingPolicy = CPAxisLabelingPolicyFixedInterval;
		labelTextStyle = [[CPTextStyle alloc] init];
		NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
		newFormatter.minimumIntegerDigits = 1;
		newFormatter.maximumFractionDigits = 1; 
        newFormatter.minimumFractionDigits = 1;
        labelFormatter = newFormatter;
		labelFormatterChanged = YES;
		axisLabels = [[NSSet set] retain];
        tickDirection = CPSignNone;
		axisTitle = nil;
		titleTextStyle = [[CPTextStyle alloc] init];
		titleLocation = CPDecimalFromInteger(0);
        needsRelabel = YES;
		labelExclusionRanges = nil;
		delegate = nil;
		
		self.needsDisplayOnBoundsChange = YES;
	}
	return self;
}

-(void)dealloc
{
	[plotSpace release];	
	[majorTickLocations release];
	[minorTickLocations release];
	[axisLineStyle release];
	[majorTickLineStyle release];
	[minorTickLineStyle release];
    [majorGridLineStyle release];
    [minorGridLineStyle release];
	[labelFormatter release];
	[axisLabels release];
	[labelTextStyle release];
	[titleTextStyle release];
	[labelExclusionRanges release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Ticks

-(NSDecimal)nextLocationFromCoordinateValue:(NSDecimal)coord increasing:(BOOL)increasing interval:(NSDecimal)interval
{
	if ( increasing ) {
		return CPDecimalAdd(coord, interval);
	} else {
		return CPDecimalSubtract(coord, interval);
	}
}

-(void)tickLocationsBeginningAt:(NSDecimal)beginNumber increasing:(BOOL)increasing majorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations
{
	NSMutableSet *majorLocations = [NSMutableSet set];
	NSMutableSet *minorLocations = [NSMutableSet set];
	NSDecimal majorInterval = self.majorIntervalLength;
	NSDecimal coord = beginNumber;
	CPPlotRange *range = [self.plotSpace plotRangeForCoordinate:self.coordinate];
	
	while ( range &&
    		(increasing && CPDecimalLessThanOrEqualTo(coord, range.end)) || 
    		(!increasing && CPDecimalGreaterThanOrEqualTo(coord, range.location)) ) {
		
		// Major tick
		if ( CPDecimalLessThanOrEqualTo(coord, range.end) && CPDecimalGreaterThanOrEqualTo(coord, range.location) ) {
			[majorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:coord]];
		}
		
		// Minor ticks
		if ( self.minorTicksPerInterval > 0 ) {
			NSDecimal minorInterval = CPDecimalDivide(majorInterval, CPDecimalFromUnsignedInteger(self.minorTicksPerInterval+1));
			NSDecimal minorCoord = [self nextLocationFromCoordinateValue:coord increasing:increasing interval:minorInterval];
			
			for ( NSUInteger minorTickIndex = 0; minorTickIndex < self.minorTicksPerInterval; minorTickIndex++) {
				if ( CPDecimalLessThanOrEqualTo(minorCoord, range.end) && CPDecimalGreaterThanOrEqualTo(minorCoord, range.location)) {
					[minorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:minorCoord]];
				}
				minorCoord = [self nextLocationFromCoordinateValue:minorCoord increasing:increasing interval:minorInterval];
			}
		}
		
		coord = [self nextLocationFromCoordinateValue:coord increasing:increasing interval:majorInterval];
	}
	*newMajorLocations = majorLocations;
	*newMinorLocations = minorLocations;
}

-(void)autoGenerateMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations 
{
    NSMutableSet *majorLocations = [NSMutableSet setWithCapacity:self.preferredNumberOfMajorTicks];
    NSMutableSet *minorLocations = [NSMutableSet setWithCapacity:(self.preferredNumberOfMajorTicks + 1) * self.minorTicksPerInterval];
    
    if ( self.preferredNumberOfMajorTicks == 0 ) {
    	*newMajorLocations = majorLocations;
        *newMinorLocations = minorLocations;
        return;
    }
    
    // Determine starting interval
    NSUInteger numTicks = self.preferredNumberOfMajorTicks;
    CPPlotRange *range = [self.plotSpace plotRangeForCoordinate:self.coordinate];
    NSUInteger numIntervals = MAX( 1, (NSInteger)numTicks - 1 );
    NSDecimalNumber *rangeLength = [NSDecimalNumber decimalNumberWithDecimal:range.length];
    NSDecimalNumber *interval = [rangeLength decimalNumberByDividingBy:
    	(NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:numIntervals]];
    
    // Determine round number using the NSString with scientific format of numbers
    NSString *intervalString = [NSString stringWithFormat:@"%e", [interval doubleValue]];
    NSScanner *numberScanner = [NSScanner scannerWithString:intervalString];
	NSInteger firstDigit;
    [numberScanner scanInteger:&firstDigit];
    
    // Ignore decimal part of scientific number
    [numberScanner scanUpToString:@"e" intoString:nil];
    [numberScanner scanString:@"e" intoString:nil];
    
    // Scan the exponent
    NSInteger exponent;
    [numberScanner scanInteger:&exponent];
    
    // Set interval which has been rounded. Make sure it is not zero.
    interval = [NSDecimalNumber decimalNumberWithMantissa:MAX(1,firstDigit) exponent:exponent isNegative:NO];
    
    // Determine how many points there should be now
    NSDecimalNumber *numPointsDecimal = [rangeLength decimalNumberByDividingBy:interval];
    NSInteger numPoints = [numPointsDecimal integerValue];
    
    // Find first location
    NSDecimalNumber *rangeLocation = [NSDecimalNumber decimalNumberWithDecimal:range.location];
    NSInteger firstPointMultiple = [[rangeLocation decimalNumberByDividingBy:interval] integerValue];
    NSDecimalNumber *pointLocation = [interval decimalNumberByMultiplyingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithInteger:firstPointMultiple]];
    if ( firstPointMultiple >= 0 && ![rangeLocation isEqualToNumber:pointLocation] ) {
        firstPointMultiple++;
        pointLocation = [interval decimalNumberByMultiplyingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithInteger:firstPointMultiple]];
    }    
    
    // Determine all locations
    NSInteger majorIndex;
    NSDecimalNumber *minorInterval = nil;
    if ( self.minorTicksPerInterval > 0 ) {
		minorInterval = [interval decimalNumberByDividingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithInteger:self.minorTicksPerInterval+1]];
	}
    for ( majorIndex = 0; majorIndex < numPoints; majorIndex++ ) {
    	// Major ticks
        [majorLocations addObject:pointLocation];
        pointLocation = [pointLocation decimalNumberByAdding:interval];
        
        // Minor ticks
        if ( !minorInterval ) continue;
        NSDecimalNumber *minorLocation = [pointLocation decimalNumberByAdding:minorInterval];
        for ( NSUInteger minorIndex = 0; minorIndex < self.minorTicksPerInterval; minorIndex++ ) {
            [minorLocations addObject:minorLocation];
            minorLocation = [minorLocation decimalNumberByAdding:minorInterval];
        }
    }
    
    *newMajorLocations = majorLocations;
    *newMinorLocations = minorLocations;
}

#pragma mark -
#pragma mark Labels

/**	@brief Updates the set of axis labels using the given locations.
 *	Existing axis label objects and content layers are reused where possible.
 *	@param locations A set of NSDecimalNumber label locations.
 **/
-(void)updateAxisLabelsAtLocations:(NSSet *)locations
{
	CGFloat offset = self.labelOffset;
	switch ( self.tickDirection ) {
		case CPSignNone:
			offset += self.majorTickLength / 2.0;
			break;
		case CPSignPositive:
		case CPSignNegative:
			offset += self.majorTickLength;
			break;
	}
	
    NSMutableSet *newAxisLabels = [[NSMutableSet alloc] initWithCapacity:locations.count];
	CPAxisLabel *blankLabel = [[CPAxisLabel alloc] initWithText:nil textStyle:nil];
	
	for ( NSDecimalNumber *tickLocation in locations ) {
		CPAxisLabel *newAxisLabel;
		BOOL needsNewContentLayer = NO;
		
		// reuse axis labels where possible--will prevent flicker when updating layers
		blankLabel.tickLocation = [tickLocation decimalValue];
		CPAxisLabel *oldAxisLabel = [self.axisLabels member:blankLabel];
		
		if ( oldAxisLabel ) {
			newAxisLabel = [oldAxisLabel retain];
		}
		else {
			newAxisLabel = [[CPAxisLabel alloc] initWithText:nil textStyle:nil];
			newAxisLabel.tickLocation = [tickLocation decimalValue];
			needsNewContentLayer = YES;
		}
		
		newAxisLabel.rotation = self.labelRotation;
		newAxisLabel.offset = offset;
		
		if ( needsNewContentLayer || self.labelFormatterChanged ) {
			NSString *labelString = [self.labelFormatter stringForObjectValue:tickLocation];
			CPTextLayer *newLabelLayer = [[CPTextLayer alloc] initWithText:labelString style:self.labelTextStyle];
			[oldAxisLabel.contentLayer removeFromSuperlayer];
			newAxisLabel.contentLayer = newLabelLayer;
			[self addSublayer:newLabelLayer];
			[newLabelLayer release];
		}

		[newAxisLabels addObject:newAxisLabel];
		[newAxisLabel release];
	}
	[blankLabel release];
	
	// remove old labels that are not needed any more from the layer hierarchy
	NSMutableSet *oldAxisLabels = [self.axisLabels mutableCopy];
	[oldAxisLabels minusSet:newAxisLabels];
	for ( CPAxisLabel *label in oldAxisLabels ) {
		[label.contentLayer removeFromSuperlayer];
	}
	[oldAxisLabels release];
	
	// do not use accessor because we've already updated the layer hierarchy
	[axisLabels release];
	axisLabels = newAxisLabels;
	self.labelFormatterChanged = NO;
}

/**	@brief Marks the receiver as needing to update the labels before the content is next drawn.
 **/
-(void)setNeedsRelabel
{
    self.needsRelabel = YES;
}

/**	@brief Updates the axis labels.
 **/
-(void)relabel
{
    if ( !self.needsRelabel ) return;
	if ( !self.plotSpace ) return;
	if ( self.delegate && ![self.delegate axisShouldRelabel:self] ) {
        self.needsRelabel = NO;
        return;
    }

	NSMutableSet *allNewMajorLocations = [NSMutableSet set];
	NSMutableSet *allNewMinorLocations = [NSMutableSet set];
	NSSet *newMajorLocations, *newMinorLocations;
	
	switch ( self.labelingPolicy ) {
		case CPAxisLabelingPolicyNone:
        case CPAxisLabelingPolicyLocationsProvided:
            // Locations are set by user
			break;
		case CPAxisLabelingPolicyFixedInterval:
			// Add ticks in negative direction
			[self tickLocationsBeginningAt:self.labelingOrigin increasing:NO majorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
			[allNewMajorLocations unionSet:newMajorLocations];  
			[allNewMinorLocations unionSet:newMinorLocations];  
			
			// Add ticks in positive direction
			[self tickLocationsBeginningAt:self.labelingOrigin increasing:YES majorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
			[allNewMajorLocations unionSet:newMajorLocations];
			[allNewMinorLocations unionSet:newMinorLocations];
			
			break;
        case CPAxisLabelingPolicyAutomatic:
			[self autoGenerateMajorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
            allNewMajorLocations = (NSMutableSet *)newMajorLocations;
			allNewMinorLocations = (NSMutableSet *)newMinorLocations;
			break;
		case CPAxisLabelingPolicyLogarithmic:
			// TODO: logarithmic labeling policy
			break;
	}
	
	switch ( self.labelingPolicy ) {
		case CPAxisLabelingPolicyNone:
        case CPAxisLabelingPolicyLocationsProvided:
            // Locations are set by user--no filtering required
			break;
		default:
			// Filter and set tick locations	
			self.majorTickLocations = [self filteredMajorTickLocations:allNewMajorLocations];
			self.minorTickLocations = [self filteredMinorTickLocations:allNewMinorLocations];
	}
	
    if ( self.labelingPolicy != CPAxisLabelingPolicyNone ) {
        // Label ticks
		[self updateAxisLabelsAtLocations:self.majorTickLocations];
    }

    self.needsRelabel = NO;
	
	[self.delegate axisDidRelabel:self];
}

-(NSSet *)filteredTickLocations:(NSSet *)allLocations 
{
	NSMutableSet *filteredLocations = [allLocations mutableCopy];
	for ( CPPlotRange *range in self.labelExclusionRanges ) {
		for ( NSDecimalNumber *location in allLocations ) {
			if ( [range contains:[location decimalValue]] ) {
				[filteredLocations removeObject:location];	
			}
		}
	}
	return [filteredLocations autorelease];
}

/**	@brief Removes any major ticks falling inside the label exclusion ranges from the set of tick locations.
 *	@param allLocations A set of major tick locations.
 *	@return The filtered set.
 **/
-(NSSet *)filteredMajorTickLocations:(NSSet *)allLocations
{
	return [self filteredTickLocations:allLocations];
}

/**	@brief Removes any minor ticks falling inside the label exclusion ranges from the set of tick locations.
 *	@param allLocations A set of minor tick locations.
 *	@return The filtered set.
 **/
-(NSSet *)filteredMinorTickLocations:(NSSet *)allLocations
{
	return [self filteredTickLocations:allLocations];
}

#pragma mark -
#pragma mark Sublayer Layout

+(CGFloat)defaultZPosition 
{
	return CPDefaultZPositionAxis;
}

-(void)layoutSublayers 
{
	if ( self.needsRelabel ) [self relabel];
	
    for ( CPAxisLabel *label in self.axisLabels ) {
        CGPoint tickBasePoint = [self viewPointForCoordinateDecimalNumber:label.tickLocation];
        [label positionRelativeToViewPoint:tickBasePoint forCoordinate:CPOrthogonalCoordinate(self.coordinate) inDirection:self.tickDirection];
    }
	
	[self.axisTitle positionRelativeToViewPoint:[self viewPointForCoordinateDecimalNumber:self.titleLocation] forCoordinate:CPOrthogonalCoordinate(self.coordinate) inDirection:self.tickDirection];
}

#pragma mark -
#pragma mark Accessors

-(void)setAxisLabels:(NSSet *)newLabels 
{
    if ( newLabels != axisLabels ) {
        for ( CPAxisLabel *label in axisLabels ) {
            [label.contentLayer removeFromSuperlayer];
        }
		
		[newLabels retain];
        [axisLabels release];
        axisLabels = newLabels;

        for ( CPAxisLabel *label in axisLabels ) {
			CPLayer *contentLayer = label.contentLayer;
			if ( contentLayer ) {
				[self addSublayer:contentLayer];
			}
        }
	}
}

-(void)setLabelTextStyle:(CPTextStyle *)newStyle 
{
	if ( newStyle != labelTextStyle ) {
		[labelTextStyle release];
		labelTextStyle = [newStyle copy];
		
		for ( CPAxisLabel *axisLabel in self.axisLabels ) {
			CPLayer *contentLayer = axisLabel.contentLayer;
			if ( [contentLayer isKindOfClass:[CPTextLayer class]] ) {
				[(CPTextLayer *)contentLayer setTextStyle:labelTextStyle];
			}
		}
		
		[self setNeedsLayout];
	}
}

-(void)setAxisTitle:(CPAxisTitle *)newTitle
{
	if ( newTitle != axisTitle ) {
		[axisTitle.contentLayer removeFromSuperlayer];
		[axisTitle release];
		axisTitle = [newTitle retain];
		axisTitle.offset = self.titleOffset;
		[self addSublayer:axisTitle.contentLayer];
	}
}

-(void)setTitleTextStyle:(CPTextStyle *)newStyle 
{
	if ( newStyle != titleTextStyle ) {
		[titleTextStyle release];
		titleTextStyle = [newStyle copy];

		CPLayer *contentLayer = self.axisTitle.contentLayer;
		if ( [contentLayer isKindOfClass:[CPTextLayer class]] ) {
			[(CPTextLayer *)contentLayer setTextStyle:titleTextStyle];
		}
		
		[self setNeedsLayout];
	}
}

-(void)setTitleOffset:(CGFloat)newOffset 
{
    if ( newOffset != titleOffset ) {
        titleOffset = newOffset;
		self.axisTitle.offset = titleOffset;
		[self setNeedsLayout];
    }
}

- (void)setTitle:(NSString *)newTitle
{
	if ( newTitle != title ) {
		[title release];
		title = [newTitle retain];
		if (axisTitle == nil) {
			CPAxisTitle *newAxisTitle = [[CPAxisTitle alloc] initWithText:title textStyle:self.titleTextStyle];
			self.axisTitle = newAxisTitle;
			[newAxisTitle release];
		}
		else {
			CPLayer *contentLayer = self.axisTitle.contentLayer;
			if ( [contentLayer isKindOfClass:[CPTextLayer class]] ) {
				[(CPTextLayer *)contentLayer setText:title];
			}
		}
		[self setNeedsLayout];
	}
}

-(void)setLabelExclusionRanges:(NSArray *)ranges 
{
	if ( ranges != labelExclusionRanges ) {
		[labelExclusionRanges release];
		labelExclusionRanges = [ranges retain];
        self.needsRelabel = YES;
	}
}

-(void)setNeedsRelabel:(BOOL)newNeedsRelabel 
{
    if (newNeedsRelabel != needsRelabel) {
        needsRelabel = newNeedsRelabel;
        if ( needsRelabel ) {
            [self setNeedsLayout];
            [self setNeedsDisplay];
        }
    }
}

-(void)setMajorTickLocations:(NSSet *)newLocations 
{
    if ( newLocations != majorTickLocations ) {
        [majorTickLocations release];
        majorTickLocations = [newLocations retain];
		[self setNeedsDisplay];		
        self.needsRelabel = YES;
    }
}

-(void)setMinorTickLocations:(NSSet *)newLocations 
{
    if ( newLocations != majorTickLocations ) {
        [minorTickLocations release];
        minorTickLocations = [newLocations retain];
		[self setNeedsDisplay];		
    }
}

-(void)setMajorTickLength:(CGFloat)newLength 
{
    if ( newLength != majorTickLength ) {
        majorTickLength = newLength;
        [self setNeedsDisplay];
        self.needsRelabel = YES;
    }
}

-(void)setMinorTickLength:(CGFloat)newLength 
{
    if ( newLength != minorTickLength ) {
        minorTickLength = newLength;
        [self setNeedsDisplay];
    }
}

-(void)setLabelOffset:(CGFloat)newOffset 
{
    if ( newOffset != labelOffset ) {
        labelOffset = newOffset;
		[self setNeedsLayout];
        self.needsRelabel = YES;
    }
}

-(void)setLabelRotation:(CGFloat)newRotation 
{
    if ( newRotation != labelRotation ) {
        labelRotation = newRotation;
		[self setNeedsLayout];
        self.needsRelabel = YES;
    }
}

-(void)setPlotSpace:(CPPlotSpace *)newSpace 
{
    if ( newSpace != plotSpace ) {
        [plotSpace release];
        plotSpace = [newSpace retain];
        self.needsRelabel = YES;
    }
}

-(void)setCoordinate:(CPCoordinate)newCoordinate 
{
    if ( newCoordinate != coordinate ) {
        coordinate = newCoordinate;
        self.needsRelabel = YES;
    }
}

-(void)setAxisLineStyle:(CPLineStyle *)newLineStyle 
{
    if ( newLineStyle != axisLineStyle ) {
        [axisLineStyle release];
        axisLineStyle = [newLineStyle copy];
		[self setNeedsDisplay];			
    }
}

-(void)setMajorTickLineStyle:(CPLineStyle *)newLineStyle 
{
    if ( newLineStyle != majorTickLineStyle ) {
        [majorTickLineStyle release];
        majorTickLineStyle = [newLineStyle copy];
        [self setNeedsDisplay];
    }
}

-(void)setMinorTickLineStyle:(CPLineStyle *)newLineStyle 
{
    if ( newLineStyle != minorTickLineStyle ) {
        [minorTickLineStyle release];
        minorTickLineStyle = [newLineStyle copy];
        [self setNeedsDisplay];
    }
}

-(void)setLabelingOrigin:(NSDecimal)newLabelingOrigin
{
	if ( CPDecimalEquals(labelingOrigin, newLabelingOrigin) ) {
		return;
	}
	labelingOrigin = newLabelingOrigin;
	self.needsRelabel = YES;
}

-(void)setMajorIntervalLength:(NSDecimal)newIntervalLength 
{
	if ( CPDecimalEquals(majorIntervalLength, newIntervalLength) ) {
		return;
	}
	majorIntervalLength = newIntervalLength;
	self.needsRelabel = YES;
}

-(void)setMinorTicksPerInterval:(NSUInteger)newMinorTicksPerInterval 
{
    if ( newMinorTicksPerInterval != minorTicksPerInterval ) {
        minorTicksPerInterval = newMinorTicksPerInterval;
        self.needsRelabel = YES;
    }
}

-(void)setLabelingPolicy:(CPAxisLabelingPolicy)newPolicy 
{
    if ( newPolicy != labelingPolicy ) {
        labelingPolicy = newPolicy;
        self.needsRelabel = YES;
    }
}

-(void)setLabelFormatter:(NSNumberFormatter *)newTickLabelFormatter 
{
    if ( newTickLabelFormatter != labelFormatter ) {
        [labelFormatter release];
        labelFormatter = [newTickLabelFormatter retain];
		self.labelFormatterChanged = YES;
        self.needsRelabel = YES;
    }
}

-(void)setTickDirection:(CPSign)newDirection 
{
    if ( newDirection != tickDirection ) {
        tickDirection = newDirection;
		[self setNeedsLayout];
        self.needsRelabel = YES;
    }
}

///	@}

@end

#pragma mark -

///	@brief CPAxis abstract methods—must be overridden by subclasses
@implementation CPAxis(AbstractMethods)

/// @addtogroup CPAxis
/// @{

/**	@brief Converts a position on the axis to drawing coordinates.
 *	@param coordinateDecimalNumber The axis value in data coordinate space.
 *	@return The drawing coordinates of the point.
 **/
-(CGPoint)viewPointForCoordinateDecimalNumber:(NSDecimal)coordinateDecimalNumber
{
	return CGPointZero;
}

///	@}

@end
