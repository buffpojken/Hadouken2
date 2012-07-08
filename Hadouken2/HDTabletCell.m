//
//  HDTabletCell.m
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTabletCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HDTabletCell
@synthesize delegate, index, activated;

- (id)initWithFrame:(CGRect)frame andContent:(NSString*)content andIndex:(int)ind
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.userInteractionEnabled = YES; 
    
    value = content; 
    index = ind;
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)] autorelease];
    label.font = [UIFont fontWithName:@"Enochian" size:52];
    label.text = content; 
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    [label setShadowColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3]];
    [label setShadowOffset:CGSizeMake(0, +1)];
    
    [self addSubview:label];
        
    return self;
}

-(void)deactivate{
    activated = NO;
    label.layer.shadowOpacity = 0;
}

- (void)activate{
    if(!activated){
        label.layer.shadowColor     = [UIColor blueColor].CGColor;
        label.layer.shadowOffset    = CGSizeMake(0.0, 0.0);
        label.layer.shadowRadius    = 5.0; 
        label.layer.shadowOpacity   = 1; 
        label.layer.masksToBounds   = NO;
        activated = YES;
    }
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate touchesBegan:self withTouch:[touches anyObject]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate cellReceivedTouch:self withTouch:[touches anyObject]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate touchesEnded:self withTouch:[touches anyObject]];
}

@end
