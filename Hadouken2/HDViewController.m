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
#import "HDDistributionManager.h"
#import "UIImageView+AFNetworking.h"

@interface HDViewController ()

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tablet.png"]];
    [[HDNetworkClient sharedClient] getPath:@"/service/hadouken/spells" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {   
        spells = [NSArray arrayWithArray:[responseObject objectForKey:@"spells"]]; 
        [spells retain];
        NSLog(@"%@", spells);
        [self drawCells];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"Could not load the spells...");
    }];
    UILongPressGestureRecognizer *recog = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reloadSpells:)] autorelease];
    [self.view addGestureRecognizer:recog];
}

-(void)reloadSpells:(UILongPressGestureRecognizer*)recog{
    [ALToastView toastInView:self.view withText:@"Reloading spells..."];
    [[HDNetworkClient sharedClient] getPath:@"/service/hadouken/spells" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {   
        spells = [NSArray arrayWithArray:[responseObject objectForKey:@"spells"]]; 
        [spells retain];
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
}

-(void)notifyServer:(NSDictionary*)spell{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"spell_cast:Hadouken2Service" forKey:@"interaction"]; 
    [parameters setObject:[spell objectForKey:@"name"] forKey:@"keyword"];
    [parameters setObject:@"5f39191d8c9cc522837095a4dc9b83ebcfd7fcaf" forKey:@"service_api_key"];
    [parameters setObject:@"merlin:arthur" forKey:@"identifier"];
    SystemSoundID wand; 
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"wand" ofType:@"wav"]], &wand);
    AudioServicesPlaySystemSound(wand);

    [[HDNetworkClient sharedClient] postPath:@"/service/receive_keyword" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HDDistributionManager *mgn = [[HDDistributionManager alloc] initWithDelegate:self];
        [mgn handleDistributions:responseObject];
        [ALToastView toastInView:self.view withText:[NSString stringWithFormat:@"Casting %@", [spell objectForKey:@"name"]]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        NSLog(@"Failure...");
    }];
}


-(void)displayImage:(NSURL*)url{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    UITapGestureRecognizer *recog = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)] autorelease];
    recog.numberOfTapsRequired = 2;
    view.userInteractionEnabled = YES;
    view.tag = 100;
    [view addGestureRecognizer:recog];
    [view setImageWithURL:url];
    [self.view addSubview:view];
}

-(void)hideImageView:(UITapGestureRecognizer*)recog{
    UIImageView *view = [(UIImageView*)self.view viewWithTag:100];
    [view removeFromSuperview];
}   


-(void)displayText:(NSString*)text{
    [ALToastView toastInView:self.view withText:text];
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
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

@end
