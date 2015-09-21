//
//  CollectionDataViewController.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDataReceiver.h"
#import "PBDataProvider.h"

#import <CoreData/CoreData.h>

#ifdef _COREDATADEFINES_H
#import <CoreData/CoreData.h>
#endif

@interface PBCollectionDataViewController
    : UIViewController <PBDataReceiver, DataProviderDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

#pragma mark - IBOutlets

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
