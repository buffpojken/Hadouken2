//
//  HDDistributionManager.h
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDDistributionManagerDelegate <NSObject>

-(void)displayImage:(NSURL*)url;
-(void)displayText:(NSString*)text;

@end

@interface HDDistributionManager : NSObject{
    NSObject<HDDistributionManagerDelegate> *delegate;
    
}

@property(nonatomic, retain) NSObject<HDDistributionManagerDelegate> *delegate;

-(void)handleDistributions:(id)jsonResponse;
-(id)initWithDelegate:(NSObject<HDDistributionManagerDelegate>*)del;


@end
