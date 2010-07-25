//
//  RRVideoListViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 7/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "RRSubTopicViewController.h"


@interface RRVideoListViewController : RRSubTopicViewController {
  MPMoviePlayerViewController* moviePlayerView;
}

@property(nonatomic,retain)MPMoviePlayerViewController* moviePlayerView;
@end
