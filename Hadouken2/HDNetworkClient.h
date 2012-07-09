//
//  HDNetworkClient.h
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface HDNetworkClient : NSObject


+(AFHTTPClient*)sharedClient;

@end
