//
//  CollectionDataViewController.m
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import "PBCollectionDataViewController.h"
#import "DataCellConfigure.h"

@interface PBCollectionDataViewController ()

// to track changes using NSFetchResultController for CollectionView
@property(strong, nonatomic) NSMutableArray *sectionChanges;
@property(strong, nonatomic) NSMutableArray *itemChanges;
@property(strong, nonatomic) NSIndexPath *lastInsertIndexPath;

@end

@implementation PBCollectionDataViewController
@synthesize dataProvider = _dataProvider;

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup datasource
    self.collectionView.dataSource = self;

    // setup delegate
    self.collectionView.delegate = self;

    // setup UI
    [self setupCollectionUI];
}

#pragma mark - UI

- (void)setupCollectionUI {
}

#pragma mark - Accessors

- (void)setDataProvider:(PBDataProvider *)dataProvider {

    if (self.dataProvider != _dataProvider) {
        _dataProvider = dataProvider;
        _dataProvider.delegate = self;
        //        _dataProvider.shouldLoadAutomatically = YES;
        //        _dataProvider.automaticPreloadMargin = self.preloadSwitch.on ? FluentPagingCollectionViewPreloadMargin : 0;

        if ([self isViewLoaded]) {
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - <NSFetchedResultsControllerDelegate>

// Source: http://samwize.com/2014/07/07/implementing-nsfetchedresultscontroller-for-uicollectionview/
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.sectionChanges = [NSMutableArray new];
    self.itemChanges = [NSMutableArray new];
}

- (void)collectionViewDidChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
                               atIndex:(NSUInteger)sectionIndex
                         forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [NSMutableDictionary new];
    change[@(type)] = @(sectionIndex);
    [self.sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [self.collectionView performBatchUpdates:^{
      for (NSDictionary *change in self.sectionChanges) {
          [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSUInteger sectionIndex = [obj unsignedIntegerValue];
            switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
            }
          }];
      }
      for (NSDictionary *change in self.itemChanges) {
          [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertItemsAtIndexPaths:@[ obj ]];
                break;

            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteItemsAtIndexPaths:@[ obj ]];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.collectionView reloadItemsAtIndexPaths:@[ obj ]];
                break;
            case NSFetchedResultsChangeMove:
                [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                break;
            }
          }];
      }
    } completion:^(BOOL finished) {
      self.sectionChanges = nil;
      self.itemChanges = nil;
    }];
}

#pragma mark - #pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataProvider.useCoreData) {
        return [[self.dataProvider.fetchedResultsController sections] count];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataProvider.useCoreData) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.dataProvider.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    return [self.dataProvider.dataObjects count];
}

- (UICollectionViewCell<DataCellProtocol> *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<DataCellProtocol> *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:[[UICollectionViewCell class] cellReusableIdentifier] forIndexPath:indexPath];
    NSObject *item = [self.dataProvider dataAtIndexPath:indexPath];
    [cell configureCell:item];

    /** Xcode 6 on iOS 7 hot fix **/
    // http://stackoverflow.com/questions/24750158/autoresizing-issue-of-uicollectionviewcell-contentviews-frame-in-storyboard-pro
    cell.contentView.frame = cell.bounds;
    cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    /** End of Xcode 6 on iOS 7 hot fix **/

    [cell configureCell:item];
    return cell;
}

@end
