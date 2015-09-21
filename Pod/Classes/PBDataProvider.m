//
//  DataProvider.m
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import "PBDataProvider.h"
#import "PBDataLoadingOperation.h"

@interface PBDataProvider ()

@property(strong, nonatomic, readwrite) NSMutableArray *dataArray;

@end

@implementation PBDataProvider

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.useCoreData = NO;
        self.groupBy = nil;
        self.objectClass = nil;
        self.sortBy = nil;
        self.ascending = YES;
        self.fetchPredicate = nil;
        self.fetchedResultsController = nil;
    }
    return self;
}

#pragma mark - Accessors

- (void (^)(void))loadDataHandler {
    NSAssert(_loadDataHandler, @"Trying to call network handler without initialization", nil);
    return _loadDataHandler;
}

- (NSArray *)dataObjects {
    return self.dataArray;
}

#pragma mark - Public methods

- (void)refresh {
    if (![self shouldStartLoading]) {
        return;
    }

    // cleanup
    if (!self.useCoreData) {
        [self.dataArray removeAllObjects];
    }

    [self willStartLoading];

    // network handler
    self.loadDataHandler();
}

- (BOOL)shouldStartLoading {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataProviderShouldStartLoading:)]) {
        return [self.delegate dataProviderShouldStartLoading:self];
    } else {
        return YES;
    }
}

- (void)willStartLoading {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataProviderWillStartLoading:)]) {
        [self.delegate dataProviderWillStartLoading:self];
    }
}

- (void)willFinishedLoading {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dataProviderWillFinishedLoading:)]) {
        [self.delegate dataProviderWillFinishedLoading:self];
    }
}

- (void)finishedLoadingWithItems:(NSArray *)newItems {
    [self willFinishedLoading];
}

- (void)finishedLoadingWithItems:(NSArray *)newItems inSection:(NSUInteger)section {
    [self willFinishedLoading];
}

- (void)finishedLoadingWithError:(NSError *)error {
    [self willFinishedLoading];
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    if (self.useCoreData) {
        return [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    return self.dataObjects[indexPath.row];
}

- (NSIndexPath *)indexPathForData:(id)dataObject {
    if (self.useCoreData) {
        return [self.fetchedResultsController indexPathForObject:dataObject];
    }

    for (id item in self.dataObjects) {
        if ([item isEqual:dataObject]) {
            return [NSIndexPath indexPathForRow:[self.dataObjects indexOfObject:dataObject] inSection:1];
        }
    }

    return nil;
}

- (void)constructFetchedResultsController {
    self.fetchedResultsController =
        [self.objectClass MR_fetchAllSortedBy:self.sortBy ascending:YES withPredicate:self.fetchPredicate groupBy:self.groupBy delegate:self.delegate];
}

@end
