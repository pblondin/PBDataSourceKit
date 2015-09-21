//
//  DataProvider.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBDataLoadingOperation.h"

#import <MagicalRecord/MagicalRecord.h>
#import <CoreData/CoreData.h>

@class PBDataProvider;
@class PBDataLoadingOperation;

@protocol DataProviderDelegate <NSObject>

@optional

- (BOOL)dataProviderShouldStartLoading:(PBDataProvider *)provider;
- (void)dataProviderWillStartLoading:(PBDataProvider *)provider;
- (void)dataProviderWillFinishedLoading:(PBDataProvider *)provider;

- (void)dataProvider:(PBDataProvider *)provider didFinishedLoadingObjects:(NSArray *)dataObjects;
- (void)dataProvider:(PBDataProvider *)provider didFinishedLoadingWithError:(NSError *)error;

//- (void)dataProvider:(DataProvider *)provider willLoadDataAtIndexes:(NSIndexSet *)indexes;
//- (void)dataProvider:(DataProvider *)provider didLoadDataAtIndexes:(NSIndexSet *)indexes;

@end

@interface PBDataProvider : NSObject

#pragma mark - Configuration

// Delegate
@property(nonatomic, weak) id<DataProviderDelegate, NSFetchedResultsControllerDelegate> delegate;

// Assign YES to start using CoreData
@property(nonatomic, assign) BOOL useCoreData;

// Assign YES when result are paginated
@property(nonatomic, assign) BOOL usePagination;

// Assign YES to automatically load the dataObjects array returns an NSNull reference.
// @see dataObjects
//@property(nonatomic, assign) BOOL shouldLoadAutomatically;
//@property(nonatomic) NSUInteger automaticPreloadMargin;

#pragma mark - Data source

/**
 * The array returned will be a proxy object containing
 * NSNull values for data objects not yet loaded. As data
 * loads, the proxy updates automatically to include
 * the newly loaded objects.
 *
 * @see shouldLoadAutomatically
 */
@property(strong, nonatomic, readonly) NSArray *dataObjects;

// Block to load data from API
@property(nonatomic, copy) void (^loadDataHandler)(void);

#pragma mark Pagination

//@property(nonatomic, readonly) NSUInteger pageSize;
//@property(nonatomic, readonly) NSUInteger loadedCount;

// To use with paginated result;
//@property(nonatomic, strong) RKPaginator *paginator;

#pragma mark Core Data
// Class of objects that are shown in table
@property(nonatomic, assign) Class objectClass;

// How to sort objects
@property(nonatomic, strong) NSString *sortBy;

// Assign YES to sort ascending
@property(nonatomic, assign) BOOL ascending;

// Grouping
@property(nonatomic, strong) NSString *groupBy;

// Predicate for fetch (filtering)
@property(nonatomic, strong) NSPredicate *fetchPredicate;

// Fetched results controller to interact with data
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

#pragma mark - Public methods

// Methods to re-use / override
- (void)refresh;
- (BOOL)shouldStartLoading;
- (void)willStartLoading;
- (void)willFinishedLoading;
- (void)finishedLoadingWithItems:(NSArray *)newItems;
- (void)finishedLoadingWithItems:(NSArray *)newItems inSection:(NSUInteger)section;
- (void)finishedLoadingWithError:(NSError *)error;

- (id)dataAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForData:(id)dataObject;
- (void)constructFetchedResultsController;

@end
