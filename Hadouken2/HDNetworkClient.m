//
//  HDNetworkClient.m
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDNetworkClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


@implementation HDNetworkClient


+(AFHTTPClient*)sharedClient{
    static AFHTTPClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://creator.sykewarrior.com/"]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];        
    });
    return client;
}


@end
