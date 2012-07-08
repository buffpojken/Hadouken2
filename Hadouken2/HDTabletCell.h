//
//  HDTabletCell.h
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDTabletCell; 

@protocol HDTabletCellDelegate <NSObject>
-(void)touchesBegan:(HDTabletCell*)cell withTouch:(UITouch*)touch;
-(void)cellReceivedTouch:(HDTabletCell*)cell withTouch:(UITouch*)touch; 
-(void)touchesEnded:(HDTabletCell*)cell withTouch:(UITouch*)touch;
@end

@interface HDTabletCell : UIView{
    NSString                            *value; 
    int                               index; 
    NSObject<HDTabletCellDelegate>      *delegate; 
    UILabel                             *label;
    bool                                activated;
}

@property(nonatomic, retain) NSObject<HDTabletCellDelegate> *delegate; 
@property(nonatomic) int index; 
@property(nonatomic) bool activated;

- (id)initWithFrame:(CGRect)frame andContent:(NSString*)content andIndex:(int)ind;
- (void)activate; 
- (void)deactivate; 

@end
