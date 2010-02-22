//
//  GraphViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 2/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GraphViewController : UIViewController <CPPlotDataSource>
{
  CPXYGraph *graph;
}

@end
