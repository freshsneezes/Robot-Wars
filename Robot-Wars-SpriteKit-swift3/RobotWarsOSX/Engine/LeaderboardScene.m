//
//  LeaderboardScene.m
//  RobotWarsOSX
//
//  Created by Jonathan  Fotland on 6/28/17.
//  Copyright © 2017 Make School. All rights reserved.
//

#import "LeaderboardScene.h"
#import "TournamentScene.h"

#define numLabels 10

@implementation LeaderboardScene
{
    NSMutableArray<SKLabelNode *>* robotLabels;
    NSMutableArray<SKLabelNode *>* recordLabels;
    
    NSMutableArray* bestRobots;
}

- (void)didMoveToView:(SKView *)view
{
    
    robotLabels = [NSMutableArray array];
    recordLabels = [NSMutableArray array];
    
    for (int i = 1; i <= numLabels; i++) {
        
        NSString *robotLabelName = [NSString stringWithFormat:@"robot%d", i];
        NSString *recordLabelName = [NSString stringWithFormat:@"record%d", i];
        
        [robotLabels addObject: (SKLabelNode*) [self childNodeWithName:robotLabelName]];
        [recordLabels addObject: (SKLabelNode*) [self childNodeWithName:recordLabelName]];
    }
    
    for (int i = 0; i < numLabels; i++) {
        if ([bestRobots count] == i) {
            break;
        }
        robotLabels[i].text = [bestRobots[i] objectForKey:@"Name"];
        recordLabels[i].text = [NSString stringWithFormat:@"%d - %d", [[bestRobots[i] objectForKey:@"Wins"] intValue], [[bestRobots[i] objectForKey:@"Losses"] intValue]];
        
    }
    
    SKAction *wait = [SKAction waitForDuration:5.f];
    SKAction *performSelector = [SKAction performSelector:@selector(loadTournamentScene) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[wait, performSelector]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat withKey:@"updateCountdown"];
}

- (void)initWithCurrentResults:(NSDictionary *)results
{
    //NSDictionary* records = [schedule objectForKey:@"Records"];
    //NSDictionary* robotOneRecord = [records objectForKey:robotOneClass];
    //NSDictionary* robotTwoRecord = [records objectForKey:robotTwoClass];
    
    bestRobots = [NSMutableArray array];
    
    for (NSString* key in results) {
        NSDictionary *robotRecord = [results objectForKey:key];
        int wins = [[robotRecord objectForKey:@"Wins"] intValue];
        int losses = [[robotRecord objectForKey:@"Losses"] intValue];
        
        double winPercent = 0.0;
        int matches = wins + losses;
        if (matches > 0) {
            winPercent = (double)wins / (wins + losses);
        }
        
        int i = 0;
        for (; i < [bestRobots count]; i++) {
            NSDictionary *robot = bestRobots[i];
            double comparePercent = [[robot objectForKey:@"WinPercent"] doubleValue];
            if (comparePercent < winPercent ||
                (comparePercent == winPercent && [[robot objectForKey:@"Matches"] intValue] <= matches)) {
                break;
            }
        }
        
        NSDictionary* newRobotRecord = @{@"Name" : key, @"Wins" : @(wins), @"Losses" : @(losses), @"WinPercent" : @(winPercent), @"Matches" : @(matches) };
        
        if (i == [bestRobots count]) {
            [bestRobots addObject:newRobotRecord];
        } else {
            [bestRobots insertObject:newRobotRecord atIndex: i];
        }
    }
    
    //robotOneStats.text = [NSString stringWithFormat:@"%d - %d", [[robotOneRecord objectForKey:@"Wins"] intValue], [[robotOneRecord objectForKey:@"Losses"] intValue]];
}

- (void)loadTournamentScene
{
    TournamentScene* tournamentScene = [TournamentScene nodeWithFileNamed:@"TournamentScene"];
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.3f];
    
    [tournamentScene setCameFromLeaderboard];
    
    [self.view presentScene:tournamentScene transition:transition];
}

@end
