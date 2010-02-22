
#import "CPGraph.h"
#import "CPExceptions.h"
#import "CPPlot.h"
#import "CPPlotArea.h"
#import "CPPlotSpace.h"
#import "CPFill.h"
#import "CPAxisSet.h"
#import "CPAxis.h"
#import "CPTheme.h"

///	@cond
@interface CPGraph()

@property (nonatomic, readwrite, retain) NSMutableArray *plots;
@property (nonatomic, readwrite, retain) NSMutableArray *plotSpaces;

-(void)plotSpaceMappingDidChange:(NSNotification *)notif;

@end
///	@endcond

/**	@brief An abstract graph class.
 *	@todo More documentation needed 
 **/
@implementation CPGraph

/// @defgroup CPGraph CPGraph
/// @{

/**	@property axisSet
 *	@brief The axis set.
 **/
@dynamic axisSet;

/**	@property plotArea
 *	@brief The plot area.
 **/
@synthesize plotArea;

/**	@property plots
 *	@brief An array of all plots associated with the graph.
 **/
@synthesize plots;

/**	@property plotSpaces
 *	@brief An array of all plot spaces associated with the graph.
 **/
@synthesize plotSpaces;

/**	@property defaultPlotSpace
 *	@brief The default plot space.
 **/
@dynamic defaultPlotSpace;

#pragma mark -
#pragma mark Init/Dealloc

-(id)initWithFrame:(CGRect)newFrame
{
	if ( self = [super initWithFrame:newFrame] ) {
		plots = [[NSMutableArray alloc] init];
        
        // Margins
        self.paddingLeft = 20.0;
        self.paddingTop = 20.0;
        self.paddingRight = 20.0;
        self.paddingBottom = 20.0;
        
        // Plot area
        CPPlotArea *newArea = [(CPPlotArea *)[CPPlotArea alloc] initWithFrame:self.bounds];
        self.plotArea = newArea;
        [newArea release];

        // Plot spaces
		plotSpaces = [[NSMutableArray alloc] init];
        CPPlotSpace *newPlotSpace = [self newPlotSpace];
        [self addPlotSpace:newPlotSpace];
        [newPlotSpace release];

        // Axis set
		CPAxisSet *newAxisSet = [self newAxisSet];
		self.axisSet = newAxisSet;
		[newAxisSet release];

		self.needsDisplayOnBoundsChange = YES;
	}
	return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[plotArea release];
	[plots release];
	[plotSpaces release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Retrieving Plots

/**	@brief Makes all plots reload their data.
 **/
-(void)reloadData
{
    [[self allPlots] makeObjectsPerformSelector:@selector(reloadData)];
}

/**	@brief All plots associated with the graph.
 *	@return An array of all plots associated with the graph. 
 **/
-(NSArray *)allPlots 
{    
	return [NSArray arrayWithArray:self.plots];
}

/**	@brief Gets the plot at the given index in the plot array.
 *	@param index An index within the bounds of the plot array.
 *	@return The plot at the given index.
 **/
-(CPPlot *)plotAtIndex:(NSUInteger)index
{
    return [self.plots objectAtIndex:index];
}

/**	@brief Gets the plot with the given identifier.
 *	@param identifier A plot identifier.
 *	@return The plot with the given identifier.
 **/
-(CPPlot *)plotWithIdentifier:(id <NSCopying>)identifier 
{
	for (CPPlot *plot in self.plots) {
        if ( [[plot identifier] isEqual:identifier] ) return plot;
	}
    return nil;
}

#pragma mark -
#pragma mark Organizing Plots

/**	@brief Add a plot to the default plot space.
 *	@param plot The plot.
 **/
-(void)addPlot:(CPPlot *)plot
{
	[self addPlot:plot toPlotSpace:self.defaultPlotSpace];
}

/**	@brief Add a plot to the given plot space.
 *	@param plot The plot.
 *	@param space The plot space.
 **/
-(void)addPlot:(CPPlot *)plot toPlotSpace:(CPPlotSpace *)space
{
	if ( plot ) {
		[self.plots addObject:plot];
		plot.plotSpace = space;
        plot.graph = self;
		[self.plotArea.plotGroup addPlot:plot];
	}
}

/**	@brief Remove a plot from the graph.
 *	@param plot The plot to remove.
 **/
-(void)removePlot:(CPPlot *)plot
{
    if ( [self.plots containsObject:plot] ) {
		[self.plots removeObject:plot];
        plot.plotSpace = nil;
        plot.graph = nil;
		[self.plotArea.plotGroup removePlot:plot];
    }
    else {
        [NSException raise:CPException format:@"Tried to remove CPPlot which did not exist."];
    }
}

/**	@brief Add a plot to the default plot space at the given index in the plot array.
 *	@param plot The plot.
 *	@param index An index within the bounds of the plot array.
 **/
-(void)insertPlot:(CPPlot* )plot atIndex:(NSUInteger)index 
{
	[self insertPlot:plot atIndex:index intoPlotSpace:self.defaultPlotSpace];
}

/**	@brief Add a plot to the given plot space at the given index in the plot array.
 *	@param plot The plot.
 *	@param index An index within the bounds of the plot array.
 *	@param space The plot space.
 **/
-(void)insertPlot:(CPPlot* )plot atIndex:(NSUInteger)index intoPlotSpace:(CPPlotSpace *)space
{
	if (plot) {
		[self.plots insertObject:plot atIndex:index];
		plot.plotSpace = space;
        plot.graph = self;
		[self.plotArea.plotGroup addPlot:plot];
	}
}

/**	@brief Remove a plot from the graph.
 *	@param identifier The identifier of the plot to remove.
 **/
-(void)removePlotWithIdentifier:(id <NSCopying>)identifier 
{
	CPPlot* plotToRemove = [self plotWithIdentifier:identifier];
	if (plotToRemove) {
		plotToRemove.plotSpace = nil;
        plotToRemove.graph = nil;
		[self.plotArea.plotGroup removePlot:plotToRemove];
		[self.plots removeObjectIdenticalTo:plotToRemove];
	}
}

#pragma mark -
#pragma mark Retrieving Plot Spaces

-(CPPlotSpace *)defaultPlotSpace {
    return ( self.plotSpaces.count > 0 ? [self.plotSpaces objectAtIndex:0] : nil );
}

/**	@brief All plot spaces associated with the graph.
 *	@return An array of all plot spaces associated with the graph. 
 **/
-(NSArray *)allPlotSpaces
{
	return [NSArray arrayWithArray:self.plotSpaces];
}

/**	@brief Gets the plot space at the given index in the plot space array.
 *	@param index An index within the bounds of the plot space array.
 *	@return The plot space at the given index.
 **/
-(CPPlotSpace *)plotSpaceAtIndex:(NSUInteger)index
{
	return ( self.plotSpaces.count > index ? [self.plotSpaces objectAtIndex:index] : nil );
}

/**	@brief Gets the plot space with the given identifier.
 *	@param identifier A plot space identifier.
 *	@return The plot space with the given identifier.
 **/
-(CPPlotSpace *)plotSpaceWithIdentifier:(id <NSCopying>)identifier
{
	for (CPPlotSpace *plotSpace in self.plotSpaces) {
        if ( [[plotSpace identifier] isEqual:identifier] ) return plotSpace;
	}
    return nil;	
}

#pragma mark -
#pragma mark Set Plot Area

-(void)setPlotArea:(CPPlotArea *)newArea 
{
    if ( plotArea != newArea ) {
    	plotArea.graph = nil;
    	[plotArea removeFromSuperlayer];
        [plotArea release];
        plotArea = [newArea retain];
        [self addSublayer:newArea];
        plotArea.graph = self;
		for ( CPPlotSpace *space in plotSpaces ) {
            space.graph = self;
        }
    }
}

#pragma mark -
#pragma mark Organizing Plot Spaces

/**	@brief Add a plot space to the graph.
 *	@param space The plot space.
 **/
-(void)addPlotSpace:(CPPlotSpace *)space
{
	[self.plotSpaces addObject:space];
    space.graph = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plotSpaceMappingDidChange:) name:CPPlotSpaceCoordinateMappingDidChangeNotification object:space];
}

/**	@brief Remove a plot space from the graph.
 *	@param plotSpace The plot space.
 **/
-(void)removePlotSpace:(CPPlotSpace *)plotSpace
{
	if ( [self.plotSpaces containsObject:plotSpace] ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CPPlotSpaceCoordinateMappingDidChangeNotification object:plotSpace];

        // Remove space
		[self.plotSpaces removeObject:plotSpace];
        plotSpace.graph = nil;
        
        // Update axes that referenced space
        for ( CPAxis *axis in self.axisSet.axes ) {
            if ( axis.plotSpace == plotSpace ) axis.plotSpace = nil;
        }
    }
    else {
        [NSException raise:CPException format:@"Tried to remove CPPlotSpace which did not exist."];
    }
}

#pragma mark -
#pragma mark Coordinate Changes in Plot Spaces

-(void)plotSpaceMappingDidChange:(NSNotification *)notif 
{
    [self setNeedsLayout];
    [self.axisSet relabelAxes];
    [[self allPlots] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

#pragma mark -
#pragma mark Axis Set

-(CPAxisSet *)axisSet
{
	return self.plotArea.axisSet;
}

-(void)setAxisSet:(CPAxisSet *)newSet
{
	self.plotArea.axisSet = newSet;
}

#pragma mark -
#pragma mark Themes

/**	@brief Apply a theme to style the graph.
 *	@param theme The theme object used to style the graph.
 **/
-(void)applyTheme:(CPTheme *)theme 
{
    [theme applyThemeToGraph:self];
}

#pragma mark -
#pragma mark Layout

+(CGFloat)defaultZPosition 
{
	return CPDefaultZPositionGraph;
}

#pragma mark -
#pragma mark Accessors

-(void)setPaddingLeft:(CGFloat)newPadding 
{
    if ( newPadding != self.paddingLeft ) {
        [super setPaddingLeft:newPadding];
		[self.axisSet.axes makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    }
}

-(void)setPaddingRight:(CGFloat)newPadding 
{
    if ( newPadding != self.paddingRight ) {
        [super setPaddingRight:newPadding];
		[self.axisSet.axes makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    }
}

-(void)setPaddingTop:(CGFloat)newPadding 
{
    if ( newPadding != self.paddingTop ) {
        [super setPaddingTop:newPadding];
		[self.axisSet.axes makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    }
}

-(void)setPaddingBottom:(CGFloat)newPadding 
{
    if ( newPadding != self.paddingBottom ) {
        [super setPaddingBottom:newPadding];
		[self.axisSet.axes makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    }
}

#pragma mark -
#pragma mark Event Handling

-(BOOL)pointingDeviceDownAtPoint:(CGPoint)interactionPoint
{
    // Plots
    for ( CPPlot *plot in self.plots ) {
        if ( [plot pointingDeviceDownAtPoint:interactionPoint] ) return YES;
    } 
    
    // Axes Set
    if ( [self.axisSet pointingDeviceDownAtPoint:interactionPoint] ) return YES;
    
    // Plot area
    if ( [self.plotArea pointingDeviceDownAtPoint:interactionPoint] ) return YES;
    
    // Plot spaces
    // Plot spaces do not block events, because several spaces may need to receive
    // the same event sequence (eg dragging coordinate translation)
    BOOL handledEvent = NO;
    for ( CPPlotSpace *space in self.plotSpaces ) {
        BOOL handled = [space pointingDeviceDownAtPoint:interactionPoint];
        handledEvent |= handled;
    } 
    
    return handledEvent;
}

-(BOOL)pointingDeviceUpAtPoint:(CGPoint)interactionPoint
{
    // Plots
    for ( CPPlot *plot in self.plots ) {
        if ( [plot pointingDeviceUpAtPoint:interactionPoint] ) return YES;
    } 
    
    // Axes Set
    if ( [self.axisSet pointingDeviceUpAtPoint:interactionPoint] ) return YES;
    
    // Plot area
    if ( [self.plotArea pointingDeviceUpAtPoint:interactionPoint] ) return YES;
    
    // Plot spaces
    // Plot spaces do not block events, because several spaces may need to receive
    // the same event sequence (eg dragging coordinate translation)
    BOOL handledEvent = NO;
    for ( CPPlotSpace *space in self.plotSpaces ) {
        BOOL handled = [space pointingDeviceUpAtPoint:interactionPoint];
        handledEvent |= handled;
    } 
    
    return handledEvent;
}

-(BOOL)pointingDeviceDraggedAtPoint:(CGPoint)interactionPoint
{
    // Plots
    for ( CPPlot *plot in self.plots ) {
        if ( [plot pointingDeviceDraggedAtPoint:interactionPoint] ) return YES;
    } 
    
    // Axes Set
    if ( [self.axisSet pointingDeviceDraggedAtPoint:interactionPoint] ) return YES;
    
    // Plot area
    if ( [self.plotArea pointingDeviceDraggedAtPoint:interactionPoint] ) return YES;
    
    // Plot spaces
    // Plot spaces do not block events, because several spaces may need to receive
    // the same event sequence (eg dragging coordinate translation)
    BOOL handledEvent = NO;
    for ( CPPlotSpace *space in self.plotSpaces ) {
        BOOL handled = [space pointingDeviceDraggedAtPoint:interactionPoint];
        handledEvent |= handled;
    } 
    
    return handledEvent;
}

-(BOOL)pointingDeviceCancelled
{
    // Plots
    for ( CPPlot *plot in self.plots ) {
        if ( [plot pointingDeviceCancelled] ) return YES;
    } 
    
    // Axes Set
    if ( [self.axisSet pointingDeviceCancelled] ) return YES;
    
    // Plot area
    if ( [self.plotArea pointingDeviceCancelled] ) return YES;
    
    // Plot spaces
    BOOL handledEvent = NO;
    for ( CPPlotSpace *space in self.plotSpaces ) {
        BOOL handled = [space pointingDeviceCancelled];
        handledEvent |= handled;
    } 
    
    return handledEvent;
}
///	@}

@end

#pragma mark -

///	@brief CPGraph abstract methods—must be overridden by subclasses
@implementation CPGraph(AbstractFactoryMethods)

/// @addtogroup CPGraph
/// @{

/**	@brief Creates a new plot space for the graph.
 *	@return A new plot space.
 **/
-(CPPlotSpace *)newPlotSpace
{
	return nil;
}

/**	@brief Creates a new axis set for the graph.
 *	@return A new axis set.
 **/
-(CPAxisSet *)newAxisSet
{
	return nil;
}
///	@}

@end
