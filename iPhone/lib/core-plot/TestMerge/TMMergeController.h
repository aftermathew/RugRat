//
//  TMMergeController.h
//  TestMerge
//
//  Created by Barry Wark on 5/18/09.
//  Copyright 2009 Physion Consulting LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TMOutputGroup.h"

@class TMCompareController;

extern NSString * const TMMergeControllerDidCommitMerge;

@interface TMMergeController : NSWindowController {
    NSString *referencePath;
    NSString *outputPath;
    
    NSSet *outputGroups;
    
    NSManagedObjectContext *managedObjectContext;
    
    IBOutlet NSArrayController *groupsController;
    
    IBOutlet NSBox *mergeViewContainer;
    
    NSDictionary *compareControllersByExtension;
    
    TMCompareController *currentCompareController;
    
    NSIndexSet *groupSelectionIndexes;

}

@property (copy,readwrite) NSString * referencePath;
@property (copy,readwrite) NSString * outputPath;
@property (copy,readonly) NSSet *outputGroups;
@property (retain,readwrite) NSManagedObjectContext *managedObjectContext;
@property (retain,readonly) NSPredicate *groupFilterPredicate;
@property (retain,readwrite) IBOutlet NSBox *mergeViewContainer;
@property (readonly) NSArray *groupSortDescriptors;
@property (retain,readwrite) NSDictionary *compareControllersByExtension;
@property (retain,readwrite,nonatomic) NSIndexSet *groupSelectionIndexes;

@property (retain,readwrite) IBOutlet NSArrayController *groupsController;

- (NSArray*)gtmUnitTestOutputPathsFromPath:(NSString*)path;

- (IBAction)commitMerge:(id)sender;

- (IBAction)selectReference:(id)sender;
- (IBAction)selectOutput:(id)sender;
- (IBAction)selectMergeNone:(id)sender;

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem;
@end
