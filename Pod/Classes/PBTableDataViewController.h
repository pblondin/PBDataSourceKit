//
//  TableDataViewController.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDataReceiver.h"
#import "PBDataProvider.h"

#import <CoreData/CoreData.h>

@interface PBTableDataViewController
    : UIViewController <PBDataReceiver, DataProviderDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

#pragma mark - IBOutlets

@property(weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Configuration

// Assign to add a Pull to refresh control. Default: NO
@property(nonatomic, assign) BOOL addPullToRefreshControl;

// Assign to specify different height
@property(nonatomic) CGFloat rowHeight;
@property(nonatomic) CGFloat sectionHeaderHeight;
@property(nonatomic) CGFloat sectionFooterHeight;

// Row animation. Default: UITableViewRowAnimationFade
@property(nonatomic) UITableViewRowAnimation rowAnimation;

@end
