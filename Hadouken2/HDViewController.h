//
//  HDViewController.h
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTabletCell.h"

@interface HDViewController : UIViewController<HDTabletCellDelegate>{
    NSMutableArray *cells;
    NSArray *spells; 
    NSMutableString *currentSpell;
}

-(void)notifyServer:(NSDictionary*)spell;

@end
