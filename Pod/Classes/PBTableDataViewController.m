//
//  TableDataViewController.m
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import "PBTableDataViewController.h"
#import "PBDataCellConfigure.h"

@interface PBTableDataViewController () <DataProviderDelegate>

// refreshing control
@property(strong, nonatomic) UIRefreshControl *refreshControl;

// stop listening to the fetched results controller delegate methods
@property(nonatomic, getter=isPaused) BOOL paused;

@end

@implementation PBTableDataViewController
@synthesize dataProvider = _dataProvider;

#pragma mark - Initialization

- (void)awakeFromNib {
    [super awakeFromNib];

    self.addPullToRefreshControl = NO;
    self.rowHeight = UITableViewAutomaticDimension;
    self.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.sectionFooterHeight = UITableViewAutomaticDimension;
    self.rowAnimation = UITableViewRowAnimationFade;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup datasource
    self.tableView.dataSource = self;

    // setup delegate
    self.tableView.delegate = self;
    self.tableView.rowHeight = self.rowHeight;
    self.tableView.sectionHeaderHeight = self.sectionHeaderHeight;
    self.tableView.sectionFooterHeight = self.sectionFooterHeight;

    // setup UI
    [self setupTableDataUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.paused = YES;
}

#pragma mark - UI

- (void)setupTableDataUI {
    // iOS7+
    if ([self.tableView respondsToSelector:@selector(setKeyboardDismissMode:)]) {
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }

    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // remove background color
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Accessors

// Source: https://www.objc.io/issues/4-core-data/full-core-data-application/
- (void)setPaused:(BOOL)isPaused {
    self.paused = isPaused;
    if (self.paused) {
        self.dataProvider.fetchedResultsController.delegate = nil;
    } else {
        self.dataProvider.fetchedResultsController.delegate = self;
        [self.dataProvider.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}

- (void)setAddPullToRefreshControl:(BOOL)addPullToRefreshControl {
    _addPullToRefreshControl = addPullToRefreshControl;

    if (addPullToRefreshControl) {
        // Source: http://stackoverflow.com/questions/12497940/uirefreshcontrol-without-uitableviewcontroller
        UITableViewController *tableViewController = [UITableViewController new];
        tableViewController.tableView = self.tableView;

        self.refreshControl = [UIRefreshControl new];
        [self.refreshControl addTarget:self.dataProvider action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        tableViewController.refreshControl = self.refreshControl;
    }
}

- (void)setDataProvider:(PBDataProvider *)dataProvider {

    if (self.dataProvider != _dataProvider) {
        _dataProvider = dataProvider;
        _dataProvider.delegate = self;
        //        _dataProvider.shouldLoadAutomatically = YES;
        //        _dataProvider.automaticPreloadMargin = self.preloadSwitch.on ? FluentPagingCollectionViewPreloadMargin : 0;

        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - <DataProviderDelegate>

- (void)dataProvider:(PBDataProvider *)dataProvider willLoadDataAtIndexes:(NSIndexSet *)indexes {
}

- (void)dataProvider:(PBDataProvider *)dataProvider didLoadDataAtIndexes:(NSIndexSet *)indexes {
}

- (void)dataProviderWillFinishedLoading:(PBDataProvider *)provider {
    // Hide loading indicators
    [self.refreshControl endRefreshing];
}

#pragma mark - <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;
    UITableViewRowAnimation rowAnimation = self.rowAnimation;

    switch (type) {
    case NSFetchedResultsChangeInsert:
        [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:rowAnimation];
        break;

    case NSFetchedResultsChangeDelete:
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:rowAnimation];
        break;

    case NSFetchedResultsChangeMove:
    case NSFetchedResultsChangeUpdate:
        break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    UITableViewRowAnimation rowAnimation = self.rowAnimation;

    switch (type) {
    case NSFetchedResultsChangeInsert:
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:rowAnimation];
        break;

    case NSFetchedResultsChangeDelete:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:rowAnimation];
        break;

    case NSFetchedResultsChangeUpdate: {
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:rowAnimation];
        break;
    }

    case NSFetchedResultsChangeMove:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:rowAnimation];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:rowAnimation];
        break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - <UITableViewDelegate>

// Source: http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataProvider.useCoreData) {
        return [[self.dataProvider.fetchedResultsController sections] count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataProvider.useCoreData) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.dataProvider.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    return [self.dataProvider.dataObjects count];
}

- (UITableViewCell<PBDataCellProtocol> *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<PBDataCellProtocol> *cell =
        [tableView dequeueReusableCellWithIdentifier:[[UITableViewCell class] cellReusableIdentifier] forIndexPath:indexPath];
    NSObject *item = [self.dataProvider dataAtIndexPath:indexPath];
    [cell configureCell:item];
    return cell;
}

@end
