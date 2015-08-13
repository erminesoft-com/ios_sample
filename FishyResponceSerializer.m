//
//  FishyResponceSerializer.m
//  Fishy
//
//  Created by Vlad Soroka on 8/6/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "FishyResponceSerializer.h"

@implementation FishyResponceSerializer

+ (instancetype)serializer
{
    FishyResponceSerializer* ser = [super serializer];
    

    NSMutableSet* acceptedContentTypes = [NSMutableSet setWithSet:ser.acceptableContentTypes];
    [acceptedContentTypes addObject:@"text/html"];
    ser.acceptableContentTypes = acceptedContentTypes;
    
    return ser;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary* JSON = [super responseObjectForResponse:response data:data error:error];
    
    /**
     *  1. Parsing standart message returned from Fishy server
     */
    
    NSString* status = JSON[@"status"];
    NSString* message = JSON[@"message"];
    if([status isEqualToString:@"error"])
    {
        *error = [NSError errorWithDomain:@"com.fishy"
                                     code:0
                                 userInfo:@{@"message" : message}];
        return nil;
    }
    
    /**
     *  2. Preparing data that is returned from server for Key @"data"
     */
    
    NSObject* receivedJSONData = JSON[@"data"];
    if([receivedJSONData isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* receivedDictionary = [receivedJSONData mutableCopy];
        
        ///since user_token is placed otside of "data" content of received JSON
        ///we'll extract it and put to resulted dictionary 
        NSString* userToken = JSON[@"user_token"];
        if(userToken)
        {
            receivedDictionary[@"user_token"] = userToken;
        }
        
        
        receivedJSONData = receivedDictionary.copy;
    }
    else if([receivedJSONData isKindOfClass:[NSArray class]])
    {
        ///as for now, we'll just return an object as is
    }
    else
    {
        *error =[NSError errorWithDomain:@"com.fishy"
                                    code:0
                                userInfo:@{@"message" : @"Not supported type of \"data\" received"}];
        return nil;
    }
    
    return receivedJSONData;
}

@end
