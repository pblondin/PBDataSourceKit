//
//  DataReceiver.h
//  BaseDataProvider
//
//  Created by Philippe Blondin on 2015-09-19.
//  Copyright (c) 2015 Philippe Blondin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBDataProvider;
@protocol PBDataReceiver <NSObject>

@property(strong, nonatomic) PBDataProvider *dataProvider;

@end
