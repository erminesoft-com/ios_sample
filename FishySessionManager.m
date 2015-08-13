//
//  FishySessionManager.m
//  Fishy
//
//  Created by Vlad Soroka on 8/6/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "FishySessionManager.h"

#import "FishyResponceSerializer.h"
#import "FishyRequestSerializer.h"

#import "serverconstants.h"

@implementation FishySessionManager

#pragma mark - initialization

+ (instancetype) sharedInstance
{
    static FishySessionManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FishySessionManager alloc] initWithBaseURL:[NSURL URLWithString:kServerMainPath]];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if(self)
    {
        self.requestSerializer = [FishyRequestSerializer serializer];
        self.responseSerializer = [FishyResponceSerializer serializer];
    }
    
    return self;
}


#pragma mark - RESTful methods calls

- (void)GET_withRelativePath:(NSString *)path
                      params:(NSDictionary *)parametrs
                    callback:(FishyNetworkCallback)callback
{
    [self GET:path parameters:parametrs success:^(NSURLSessionDataTask *task, id responseObject)
    {
        callback(responseObject, nil);
    }
      failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback(nil, error);
    }];
}

- (void)POST_withRelativePath:(NSString *)path params:(NSDictionary *)parametrs callback:(FishyNetworkCallback)callback
{
    [self POST_withRelativePath:path params:parametrs images:nil callback:callback];
}

- (void)POST_withRelativePath:(NSString * )path
                       params:(NSDictionary * )parametrs
                       images:(NSArray * )images
                     callback:(FishyNetworkCallback )callback
{
    void(^successHandler)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        callback(responseObject, nil);
    };
    
    void (^failHandler)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error){
        callback(nil, error);
    };
    
    if(images.count > 0)
    {
        [self POST:kAddUser parameters:parametrs constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for(UIImage* image in images)
            {
                [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                            name:@"media"
                                        fileName:[NSString stringWithFormat:@"media_%u.png",arc4random()%10000000]
                                        mimeType:@"image/png"];
            }
        } success:successHandler failure:failHandler];
    }
    else
    {
        [self POST:path parameters:parametrs success:successHandler failure:failHandler];
    }
}

//- (void)PUT_withRelativePath:(NSString *)path
//                      params:(NSDictionary *)parametrs
//                    callback:(FishyNetworkCallback)callback
//{
//    [self PUT:path parameters:parametrs success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//         callback(responseObject, nil);
//     }
//      failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         callback(nil, error);
//     }];
//}
//
//-(void)DELETE_withRelativePath:(NSString *)path
//                        params:(NSDictionary *)parametrs
//                      callback:(FishyNetworkCallback)callback
//{
//    [self DELETE:path parameters:parametrs success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//         callback(responseObject, nil);
//     }
//      failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         callback(nil, error);
//     }];
//}

@end
