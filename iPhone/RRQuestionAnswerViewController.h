//
//  RRQuestionAnswerViewController.h
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sqlite3.h>

@class Topic;

@interface RRQuestionAnswerViewController : UITableViewController <UITableViewDelegate> {
  sqlite3 * db;
  sqlite3_stmt * statement;
  int dbrc; //database return code
  NSMutableArray * topics;
}

@property (nonatomic, retain) NSMutableArray * topics;

@end
