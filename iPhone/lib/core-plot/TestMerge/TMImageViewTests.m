//
//  TMImageViewTests.m
//  TestMerge
//
//  Created by Barry Wark on 5/28/09.
//  Copyright 2009 Physion Consulting LLC. All rights reserved.
//

#import "TMImageViewTests.h"

#import "GTMNSObject+UnitTesting.h"
#import "GTMNSObject+BindingUnitTesting.h"



@implementation TMImageViewTests
@synthesize imageView;
@synthesize flag;

- (void)setUp {
    self.imageView = [[[TMImageView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)] autorelease];
    
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"TMMergeControllerTests-testWindowUIRendering.tiff"];
    
    STAssertNotNil(imagePath, @"unable to find image");
    
    self.imageView.autoresizes = YES;
    self.imageView.autohidesScrollers = YES;
    
    [self.imageView setImageWithURL:[NSURL fileURLWithPath:imagePath]];
}

- (void)tearDown {
    self.imageView = nil;
}

- (void)testRenderNilURLImage {
    [[self imageView] setImageWithURL:nil];
    
    GTMAssertObjectImageEqualToImageNamed(self.imageView.layer, @"TMImageViewTests-testRenderNilURLImage", @"");
}

- (void)testDelegateCalledForMouseDown {
    self.imageView.delegate = self;
    self.flag = NO;
    
    [[self imageView] mouseDown:[NSEvent mouseEventWithType:NSLeftMouseUp
                                                   location:[[self imageView] convertPoint:NSMakePoint(1,1) toView:nil]
                                              modifierFlags:0
                                                  timestamp:[NSDate timeIntervalSinceReferenceDate]
                                               windowNumber:0
                                                    context:nil
                                                eventNumber:1
                                                 clickCount:1
                                                   pressure:1.0]];
    
    STAssertTrue(self.flag, @"delegate method not recieved");
}

- (void)mouseDownInImageView:(TMImageView*)view {
    STAssertEquals(view, self.imageView, @"");
    self.flag = YES;
}

- (void)testBindings {
    GTMDoExposedBindingsFunctionCorrectly(self.imageView.layer, NULL);
}

- (void)testOverlayRendering {
    CALayer *diffLayer = [CALayer layer];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"TMMergeControllerTests-testWindowUIRendering.tiff"]; //TMMergeControllerTests-testWindowUIRendering_Failed_Diff.i386.10.5.7.tiff
    
    CIImage *diffImage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
    
    NSBitmapImageRep *diffRep = [[NSBitmapImageRep alloc] initWithCIImage:diffImage];
    
    diffLayer.contents = (id)[diffRep CGImage];
    
    self.imageView.overlay = diffLayer;
    
    
    GTMAssertObjectEqualToStateAndImageNamed(self.imageView.layer, @"TMImageViewTests-testOverlayRendering", @"");
}
    
@end
