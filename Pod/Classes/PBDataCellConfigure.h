//
//  DataCellConfigure.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBDataCellProtocol <NSObject>

#pragma mark - Class method

// Assign the to corresponding identifier to dequeue reusable cell
+ (NSString *)cellReusableIdentifier;

// Configure the cell using the data object
- (void)configureCell:(NSObject *)dataObject;

@end
