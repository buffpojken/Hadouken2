//
//  HDViewController.m
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDViewController.h"
#import "HDTabletCell.h"

@interface HDViewController ()

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tablet.png"]];
    
    spells = [NSArray arrayWithObjects:@",0,1,2,3", @",4,5,6,7", nil];
    [spells retain];
    
    cells = [[NSMutableArray alloc] init];
    int f = 0;
    for(int j = 1; j < 7; j++){
        for(int i = 1; i < 5; i++){
            HDTabletCell *cell = [[[HDTabletCell alloc] initWithFrame:CGRectMake(80*(i-1), 80*(j-1), 80, 80) andContent:@"A" andIndex:f] autorelease];
            [cells addObject:cell];
            cell.delegate = self;
            [self.view addSubview:cell];        
            f++;
        }
    }
}

-(void)cellReceivedTouch:(HDTabletCell*)cell withTouch:(UITouch*)touch{
    CGPoint point = [touch locationInView:self.view];
    for(HDTabletCell *cell in cells){
        if(CGRectContainsPoint(cell.frame, point)){
            if(!cell.activated){
                [currentSpell appendString:[NSString stringWithFormat:@",%@",[[NSNumber numberWithInt:cell.index] stringValue]]];
            }
            [cell activate];            
        }
    }
}

-(void)touchesEnded:(HDTabletCell*)cell withTouch:(UITouch*)touch{    
    NSLog(@"%@", currentSpell);
    for(HDTabletCell *cell in cells){
        [cell deactivate];            
    }
    for(NSString *spell in spells){
        if([currentSpell isEqualToString:spell]){
            NSLog(@"Do magic...");
        }
    }
}

-(void)touchesBegan:(HDTabletCell*)cell withTouch:(UITouch*)touch{
    if(currentSpell){
        [currentSpell release];
        currentSpell = nil;
    }
    currentSpell = [[NSMutableString alloc] init];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
