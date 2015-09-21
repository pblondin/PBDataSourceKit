//
//  DataLoadingOperation.m
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import "PBDataLoadingOperation.h"

@implementation PBDataLoadingOperation

- (instancetype)initWithSuccessBlock:(DataLoadingSuccessBlock)successBlock andFailureBlock:(DataLoadingFailureBlock)failureBlock {
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
    }
    return self;
}

@end
