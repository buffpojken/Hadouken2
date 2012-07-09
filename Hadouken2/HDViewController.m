//
//  HDViewController.m
//  Hadouken2
//
//  Created by Daniel Sundström on 2012-07-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDViewController.h"
#import "HDTabletCell.h"
#import "HDNetworkClient.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ALToastView.h"

@interface HDViewController ()

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tablet.png"]];
    [[HDNetworkClient sharedClient] getPath:@"/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        spells = [NSArray arrayWithArray:[responseObject objectForKey:@"spells"]]; 
        [spells retain];
        [self drawCells];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"Could not load the spells...");
    }];

}


-(void)drawCells{
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
    for(HDTabletCell *cell in cells){
        [cell deactivate];            
    }
    for(NSDictionary *spell in spells){        
        NSLog(@"%@", spell);
        if([currentSpell isEqualToString:[spell objectForKey:@"key"]]){            
            [self notifyServer:spell];
            return;            
        }
    }
    SystemSoundID down; 
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"powerdown" ofType:@"wav"]], &down);
    AudioServicesPlaySystemSound(down);
//    AudioServicesDisposeSystemSoundID(wand); 
}

-(void)notifyServer:(NSDictionary*)spell{
    [[HDNetworkClient sharedClient] postPath:@"/" parameters:[NSDictionary dictionaryWithObject:[spell objectForKey:@"id"] forKey:@"spell_id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SystemSoundID wand; 
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wand" ofType:@"wav"]], &wand);
        AudioServicesPlaySystemSound(wand);
        [ALToastView toastInView:self.view withText:[NSString stringWithFormat:@"Casting %@ for X mana", [spell objectForKey:@"name"]]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure...");
    }];
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
