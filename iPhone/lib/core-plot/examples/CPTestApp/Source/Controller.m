#import "Controller.h"
#import <CorePlot/CorePlot.h>

static const CGFloat kZDistanceBetweenLayers = 20.0;

@implementation Controller

@synthesize xShift;
@synthesize yShift;
@synthesize labelRotation;

+(void)initialize
{
    [NSValueTransformer setValueTransformer:[[CPDecimalNumberValueTransformer new] autorelease] forName:@"CPDecimalNumberValueTransformer"];
}

-(void)dealloc 
{
    [graph release];
    [super dealloc];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.xShift = 0.0;
    self.yShift = 0.0;

    // Create graph and apply a dark theme
    graph = [(CPXYGraph *)[CPXYGraph alloc] initWithFrame:NSRectToCGRect(hostView.bounds)];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
    [graph applyTheme:theme];
	hostView.hostedLayer = graph;
	
    // Graph padding
    graph.paddingLeft = 60.0;
    graph.paddingTop = 60.0;
    graph.paddingRight = 60.0;
    graph.paddingBottom = 60.0;
    
    // Setup scatter plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    
    // Grid line styles
    CPLineStyle *majorGridLineStyle = [CPLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPLineStyle *minorGridLineStyle = [CPLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPColor whiteColor] colorWithAlphaComponent:0.1];    
    
    CPLineStyle *redLineStyle = [CPLineStyle lineStyle];
    redLineStyle.lineWidth = 10.0;
    redLineStyle.lineColor = [[CPColor redColor] colorWithAlphaComponent:0.5];

    // Axes
    // Label x axis with a fixed interval policy
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromString(@"0.5");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
    x.minorTicksPerInterval = 2;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
	NSArray *exclusionRanges = [NSArray arrayWithObjects:
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(2.99) length:CPDecimalFromFloat(0.02)],
		nil];
	x.labelExclusionRanges = exclusionRanges;

	x.title = @"X Axis";
	x.titleOffset = 30.0;
	x.titleLocation = CPDecimalFromString(@"3.0");

	// Label y with an automatic label policy. 
    CPXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPAxisLabelingPolicyAutomatic;
    y.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
    y.minorTicksPerInterval = 2;
    y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.labelOffset = 10.0;
	exclusionRanges = [NSArray arrayWithObjects:
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
		nil];
	y.labelExclusionRanges = exclusionRanges;
    
	y.title = @"Y Axis";
	y.titleOffset = 30.0;
	y.titleLocation = CPDecimalFromString(@"2.7");

    // Rotate the labels by 45 degrees, just to show it can be done.
	self.labelRotation = M_PI * 0.25;

    // Add an extra y axis (red)
    // We add constraints to this axis below
    CPXYAxis *y2 = [[(CPXYAxis *)[CPXYAxis alloc] initWithFrame:CGRectZero] autorelease];
    y2.labelingPolicy = CPAxisLabelingPolicyAutomatic;
    y2.orthogonalCoordinateDecimal = CPDecimalFromString(@"3");
    y2.minorTicksPerInterval = 0;
    y2.preferredNumberOfMajorTicks = 4;
    y2.majorGridLineStyle = majorGridLineStyle;
    y2.minorGridLineStyle = minorGridLineStyle;
    y2.labelOffset = 10.0;    
    y2.coordinate = CPCoordinateY;
    y2.plotSpace = graph.defaultPlotSpace;
    y2.axisLineStyle = redLineStyle;
    y2.majorTickLineStyle = redLineStyle;
    y2.minorTickLineStyle = nil;
    y2.labelTextStyle = nil;
    y2.visibleRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInteger(2) length:CPDecimalFromInteger(3)];
    
    // Set axes
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, y2, nil];
	
    // Create one plot that uses bindings
	CPScatterPlot *boundLinePlot = [[[CPScatterPlot alloc] init] autorelease];
    boundLinePlot.identifier = @"Bindings Plot";
	boundLinePlot.dataLineStyle.miterLimit = 1.0;
	boundLinePlot.dataLineStyle.lineWidth = 3.0;
	boundLinePlot.dataLineStyle.lineColor = [CPColor blueColor];
    [graph addPlot:boundLinePlot];
	[boundLinePlot bind:CPScatterPlotBindingXValues toObject:self withKeyPath:@"arrangedObjects.x" options:nil];
	[boundLinePlot bind:CPScatterPlotBindingYValues toObject:self withKeyPath:@"arrangedObjects.y" options:nil];
    
    // Put an area gradient under the plot above
    NSString *pathToFillImage = [[NSBundle mainBundle] pathForResource:@"BlueTexture" ofType:@"png"];
    CPImage *fillImage = [CPImage imageForPNGFile:pathToFillImage];
    fillImage.tiled = YES;
    CPFill *areaGradientFill = [CPFill fillWithImage:fillImage];
    boundLinePlot.areaFill = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber one] decimalValue];
    
	// Add plot symbols
	CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPColor blackColor];
	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
	plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
    // Create a second plot that uses the data source method
	CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Data Source Plot";
	dataSourceLinePlot.dataLineStyle.lineWidth = 3.0;
    dataSourceLinePlot.dataLineStyle.lineColor = [CPColor greenColor];
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Put an area gradient under the plot above
    CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
    areaGradient.angle = -90.0;
    areaGradientFill = [CPFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"1.75");
	
    // Add some initial data
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	for ( NSUInteger i = 0; i < 60; i++ ) {
		id x = [NSDecimalNumber numberWithDouble:1.0 + i * 0.05];
		id y = [NSDecimalNumber numberWithDouble:1.2 * rand()/(double)RAND_MAX + 1.2];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.content = contentArray;
    
    // Auto scale the plot space to fit the plot data
    // Extend the y range by 10% for neatness
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:boundLinePlot, dataSourceLinePlot, nil]];
    CPPlotRange *xRange = plotSpace.xRange;
    CPPlotRange *yRange = plotSpace.yRange;
    [yRange expandRangeByFactor:CPDecimalFromDouble(1.1)];
    plotSpace.yRange = yRange;
    
    // Restrict y range to a global range
    CPPlotRange *globalYRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0f) length:CPDecimalFromFloat(6.0f)];
    plotSpace.globalYRange = globalYRange;
    
    // set the x and y shift to match the new ranges
	CGFloat length = CPDecimalDoubleValue(xRange.length);
	self.xShift = length - 3.0;
	length = CPDecimalDoubleValue(yRange.length);
	self.yShift = length - 2.0;
    
    // Position y2 axis relative to the plot area, ie, not moving when dragging
	CPConstraints y2Constraints = {CPConstraintNone, CPConstraintFixed};
	y2.isFloatingAxis = YES;
	y2.constraints = y2Constraints;
	
    // Add plot space for horizontal bar charts
    CPXYPlotSpace *barPlotSpace = [[CPXYPlotSpace alloc] init];
    barPlotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-20.0f) length:CPDecimalFromFloat(200.0f)];
    barPlotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-7.0f) length:CPDecimalFromFloat(15.0f)];
	[graph addPlotSpace:barPlotSpace];
    [barPlotSpace release];
    
    // First bar plot
    CPBarPlot *barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor darkGrayColor] horizontalBars:YES];
    barPlot.baseValue = CPDecimalFromString(@"20");
    barPlot.dataSource = self;
    barPlot.barOffset = -0.25f;
    barPlot.identifier = @"Bar Plot 1";
	barPlot.plotRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0.0) length:CPDecimalFromDouble(7.0)];
    CPTextStyle *whiteTextStyle = [CPTextStyle textStyle];
    whiteTextStyle.color = [CPColor whiteColor];
    barPlot.barLabelTextStyle = whiteTextStyle;
    [graph addPlot:barPlot toPlotSpace:barPlotSpace];
    
    // Second bar plot
    barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor blueColor] horizontalBars:YES];
    barPlot.dataSource = self;
    barPlot.baseValue = CPDecimalFromString(@"20");
    barPlot.barOffset = 0.25f;
    barPlot.cornerRadius = 2.0;
    barPlot.identifier = @"Bar Plot 2";
	barPlot.plotRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(0.0) length:CPDecimalFromDouble(7.0)];
    [graph addPlot:barPlot toPlotSpace:barPlotSpace];
}

-(id)newObject 
{
	NSNumber *x1 = [NSDecimalNumber numberWithDouble:1.0 + ((NSMutableArray *)self.content).count * 0.05];
	NSNumber *y1 = [NSDecimalNumber numberWithDouble:1.2 * rand()/(double)RAND_MAX + 1.2];
    return [[NSMutableDictionary dictionaryWithObjectsAndKeys:x1, @"x", y1, @"y", nil] retain];
}

#pragma mark -
#pragma mark Actions

-(IBAction)reloadDataSourcePlot:(id)sender
{
    CPPlot *plot = [graph plotWithIdentifier:@"Data Source Plot"];
    [plot reloadData];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{
    if ( [plot isKindOfClass:[CPBarPlot class]] ) 
        return 8;
    else
        return [self.arrangedObjects count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num;
    if ( [plot isKindOfClass:[CPBarPlot class]] ) {
        num = [NSDecimalNumber numberWithInt:(index+1)*(index+1)];
        if ( [plot.identifier isEqual:@"Bar Plot 2"] ) 
            num = [(NSDecimalNumber *)num decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"10"]];
    }
    else {
        num = [[self.arrangedObjects objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
        if ( fieldEnum == CPScatterPlotFieldY ) {
			num = [NSNumber numberWithDouble:([num doubleValue] + 1.0)];	
		}
    }
    return num;
}

-(CPFill *)barFillForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSUInteger)index
{
	return nil;
}

-(CPTextLayer *)barLabelForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSUInteger)index 
{
	if ( [(NSString *)barPlot.identifier isEqualToString:@"Bar Plot 2"] )
		return (id)[NSNull null]; // Don't show any label
	else if ( [(NSString *)barPlot.identifier isEqualToString:@"Bar Plot 1"] && index < 4 ) 
        return (id)[NSNull null];
    else
		return nil; // Use default label style
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

-(CPPlotRange *)plotSpace:(CPPlotSpace *)space willChangePlotRangeTo:(CPPlotRange *)newRange forCoordinate:(CPCoordinate)coordinate {
    // Impose a limit on how far user can scroll in x
    if ( coordinate == CPCoordinateX ) {
        CPPlotRange *maxRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1.0f) length:CPDecimalFromFloat(6.0f)];
        CPPlotRange *changedRange = [[newRange copy] autorelease];
        [changedRange shiftEndToFitInRange:maxRange];
        [changedRange shiftLocationToFitInRange:maxRange];
        newRange = changedRange;
    }
    return newRange;
}


#pragma mark -
#pragma mark PDF / image export

-(IBAction)exportToPDF:(id)sender
{
	NSSavePanel *pdfSavingDialog = [NSSavePanel savePanel];
	[pdfSavingDialog setRequiredFileType:@"pdf"];
	
	if ( [pdfSavingDialog runModalForDirectory:nil file:nil] == NSOKButton )
	{
		NSData *dataForPDF = [graph dataForPDFRepresentationOfLayer];
		[dataForPDF writeToFile:[pdfSavingDialog filename] atomically:NO];
	}		
}

-(IBAction)exportToPNG:(id)sender
{
	NSSavePanel *pngSavingDialog = [NSSavePanel savePanel];
	[pngSavingDialog setRequiredFileType:@"png"];
	
	if ( [pngSavingDialog runModalForDirectory:nil file:nil] == NSOKButton ) {
		NSImage *image = [graph imageOfLayer];
        NSData *tiffData = [image TIFFRepresentation];
        NSBitmapImageRep *tiffRep = [NSBitmapImageRep imageRepWithData:tiffData];
        NSData *pngData = [tiffRep representationUsingType:NSPNGFileType properties:nil];
		[pngData writeToFile:[pngSavingDialog filename] atomically:NO];
	}		
}

#pragma mark -
#pragma mark Layer exploding for illustration

-(IBAction)explodeLayers:(id)sender
{
	CATransform3D perspectiveRotation = CATransform3DMakeRotation(-40.0 * M_PI / 180.0, 0.0, 1.0, 0.0);
	
	perspectiveRotation = CATransform3DRotate(perspectiveRotation, -55.0 * M_PI / 180.0, perspectiveRotation.m11, perspectiveRotation.m21, perspectiveRotation.m31);
	
	perspectiveRotation = CATransform3DScale(perspectiveRotation, 0.7, 0.7, 0.7);
	
	graph.masksToBounds = NO;
	graph.superlayer.masksToBounds = NO;
	
	overlayRotationView = [(RotationView *)[RotationView alloc] initWithFrame:hostView.frame];
	overlayRotationView.rotationDelegate = self;
	overlayRotationView.rotationTransform = perspectiveRotation;
	[overlayRotationView setAutoresizingMask:[hostView autoresizingMask]];
	[[hostView superview] addSubview:overlayRotationView positioned:NSWindowAbove relativeTo:hostView];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:1.0f] forKey:kCATransactionAnimationDuration];		

	[Controller recursivelySplitSublayersInZForLayer:graph depthLevel:0];
	graph.superlayer.sublayerTransform = perspectiveRotation;

	[CATransaction commit];
}

+(void)recursivelySplitSublayersInZForLayer:(CALayer *)layer depthLevel:(NSUInteger)depthLevel
{
	layer.zPosition = kZDistanceBetweenLayers * (CGFloat)depthLevel;
	layer.borderColor = [CPColor blueColor].cgColor;
	layer.borderWidth = 2.0;
	
	depthLevel++;
	for (CALayer *currentLayer in layer.sublayers) {
		[Controller recursivelySplitSublayersInZForLayer:currentLayer depthLevel:depthLevel];
	}
}

-(IBAction)reassembleLayers:(id)sender
{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:1.0f] forKey:kCATransactionAnimationDuration];		
	
	[Controller recursivelyAssembleSublayersInZForLayer:graph];
	graph.superlayer.sublayerTransform = CATransform3DIdentity;

	[CATransaction commit];
	
	[overlayRotationView removeFromSuperview];
	[overlayRotationView release];
	overlayRotationView = nil;
}

+(void)recursivelyAssembleSublayersInZForLayer:(CALayer *)layer
{
	layer.zPosition = 0.0;
	layer.borderColor = [CPColor clearColor].cgColor;
	layer.borderWidth = 0.0;
	for (CALayer *currentLayer in layer.sublayers) {
		[Controller recursivelyAssembleSublayersInZForLayer:currentLayer];
	}
}

#pragma mark -
#pragma mark Demo windows

-(IBAction)plotSymbolDemo:(id)sender
{
	if ( !plotSymbolWindow ) {
		[NSBundle loadNibNamed:@"PlotSymbolDemo" owner:self];
	}
	
	[plotSymbolWindow makeKeyAndOrderFront:sender];
}

-(IBAction)axisDemo:(id)sender
{
	if ( !axisDemoWindow ) {
		[NSBundle loadNibNamed:@"AxisDemo" owner:self];
	}
	
	[axisDemoWindow makeKeyAndOrderFront:sender];
}

#pragma mark -
#pragma mark CPRotationDelegate delegate method

-(void)rotateObjectUsingTransform:(CATransform3D)rotationTransform
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];	

	graph.superlayer.sublayerTransform = rotationTransform;
	
	[CATransaction commit];
}

#pragma mark -
#pragma mark Accessors

-(void)setXShift:(CGFloat)newShift 
{
    xShift = newShift;
    CPXYPlotSpace *space = (CPXYPlotSpace *)graph.defaultPlotSpace;
    CPPlotRange *newRange = [[space.xRange copy] autorelease];
    newRange.length = CPDecimalFromDouble(3.0 + newShift);  
	space.xRange = newRange;
}

-(void)setYShift:(CGFloat)newShift 
{
 	yShift = newShift;
    CPXYPlotSpace *space = (CPXYPlotSpace *)graph.defaultPlotSpace;
    CPPlotRange *newRange = [[space.yRange copy] autorelease];
    newRange.length = CPDecimalFromDouble(2.0 + newShift);  
    space.yRange = newRange;
}

-(void)setLabelRotation:(CGFloat)newRotation 
{
 	labelRotation = newRotation;
	
	((CPXYAxisSet *)graph.axisSet).yAxis.labelRotation = newRotation;
}

@end
