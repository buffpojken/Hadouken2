//
//  HDViewController.h
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTabletCell.h"
#import "HDDistributionManager.h"

@interface HDViewController : UIViewController<HDTabletCellDelegate, HDDistributionManagerDelegate>{
    NSMutableArray *cells;
    NSArray *spells; 
    NSMutableString *currentSpell;
}

-(void)notifyServer:(NSDictionary*)spell;
-(void)hideImageView:(UITapGestureRecognizer*)recog;
-(void)reloadSpells:(UILongPressGestureRecognizer*)recog;

@end
