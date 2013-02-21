//
//  HDDistributionManager.m
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDistributionManager.h"
#import "HDNetworkClient.h"
#import "UIImageView+AFNetworking.h"

@implementation HDDistributionManager
@synthesize delegate;

-(id)initWithDelegate:(NSObject<HDDistributionManagerDelegate>*)del{
    if(self = [super init]){
        self.delegate = del;
    }
    return self;
}

-(void)handleDistributions:(id)jsonResponse{
    NSLog(@"%@", jsonResponse);    
    NSArray *distributions = [jsonResponse objectForKey:@"distributions"];
    for (NSDictionary* dist in distributions) {        
        [[HDNetworkClient sharedClient] postPath:@"/service/distribution" parameters:[NSDictionary dictionaryWithObjectsAndKeys:[dist objectForKey:@"id"], @"id", @"3", @"status", @"5f39191d8c9cc522837095a4dc9b83ebcfd7fcaf", @"service_api_key", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[dist objectForKey:@"payload_type"] isEqualToString:@"Image"]){
                [self.delegate displayImage:[NSURL URLWithString:[dist objectForKey:@"payload"]]];
            }else if([[dist objectForKey:@"payload_type"] isEqualToString:@"String"]){
                [self.delegate displayText:[dist objectForKey:@"payload"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"Failed to update distribution...");
        }];
    }
}


@end
