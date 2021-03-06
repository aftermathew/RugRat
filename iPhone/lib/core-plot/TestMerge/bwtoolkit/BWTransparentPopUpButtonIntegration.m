//
//  BWTransparentPopUpIntegration.m
//  BWToolkit
//
//  Created by Brandon Walkin (www.brandonwalkin.com)
//  All code is provided under the New BSD license.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import "BWTransparentPopUpButton.h"

@implementation BWTransparentPopUpButton ( BWTransparentPopUpButtonIntegration )

- (IBInset)ibLayoutInset
{
	IBInset inset;
	inset.top = 4;
	inset.bottom = 0;
	inset.left = 1;
	inset.right = 1;
	
	return inset;
}

- (int)ibBaselineCount
{
	return 1;
}

- (float)ibBaselineAtIndex:(int)index
{
	return 13;
}

@end
