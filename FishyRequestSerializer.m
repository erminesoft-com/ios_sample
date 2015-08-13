//
//  FishyRequestSerializer.m
//  Fishy
//
//  Created by Vlad Soroka on 8/6/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "FishyRequestSerializer.h"

@implementation FishyRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSDictionary* signedParametrs = [self authorizedParametrsDictionary:parameters];
    NSMutableURLRequest* req = [[super requestBySerializingRequest:request withParameters:signedParametrs error:error] mutableCopy];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    return req.copy;
}

#pragma mark - parametrs signing

- (NSDictionary*) authorizedParametrsDictionary:(NSDictionary*)inputParams
{
    NSString* userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    if(userToken.length > 0)
    {
        NSMutableDictionary* authorizedParametrs = [NSMutableDictionary dictionaryWithDictionary:inputParams];
        authorizedParametrs[@"connectionToken"] = userToken;
        return authorizedParametrs.copy;
    }
    
    return inputParams;
}

@end
