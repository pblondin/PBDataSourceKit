//
//  DataLoadingOperation.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <Foundation/Foundation.h>

// Completion block called when DataLoading operation succeeds
typedef void (^DataLoadingSuccessBlock)(NSOperation *operation, NSObject *result);

// Completion block called when DataLoading operation fails.
typedef void (^DataLoadingFailureBlock)(NSOperation *operation, NSError *error);

@interface PBDataLoadingOperation : NSBlockOperation

- (instancetype)initWithSuccessBlock:(DataLoadingSuccessBlock)successBlock andFailureBlock:(DataLoadingFailureBlock)failureBlock;

@property(nonatomic, copy) DataLoadingSuccessBlock successBlock;
@property(nonatomic, copy) DataLoadingFailureBlock failureBlock;

@end
