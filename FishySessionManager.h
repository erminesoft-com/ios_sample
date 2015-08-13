//
//  FishySessionManager.h
//  Fishy
//
//  Created by Vlad Soroka on 8/6/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "AFHTTPSessionManager.h"

/**
 *  @param - receivedData is one of standart Foundation's collection types (NSArray, NSDictionary)
 *  concreate type of receivedData depends on server's reponce, so it's up to you to infer the type of collection that is 
 *  returned for your particular call
 */
typedef void(^FishyNetworkCallback)(id receivedData, NSError*  error);


@interface FishySessionManager : AFHTTPSessionManager

+ (instancetype) sharedInstance;

/**
 *  Common methods to access Fishy endpoint
 *  @param - relativePath. Base URL of Fishy endpoint is encapsulated withing class. Just pass unique part of concreate web method
 */

- (void) GET_withRelativePath:(NSString* ) path
                       params:(NSDictionary* )parametrs
                     callback:(FishyNetworkCallback ) callback;

- (void) POST_withRelativePath:(NSString* )path
                        params:(NSDictionary* )parametrs
                      callback:(FishyNetworkCallback ) callback;

- (void) POST_withRelativePath:(NSString* )path
                        params:(NSDictionary* )parametrs
                        images:(NSArray* )images
                      callback:(FishyNetworkCallback ) callback;



@end
