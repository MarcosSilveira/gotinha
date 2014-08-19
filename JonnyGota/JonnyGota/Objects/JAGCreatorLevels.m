//
//  JAGCreatorLevels.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCreatorLevels.h"
#import "JAGPlayGameScene.h"
#import "JAGHud.h"

@implementation JAGCreatorLevels

+ (NSNumber *)numberOfLevels{
    return @1;
}

+ (NSString *)nameOfLevel:(NSNumber *)level{
    return [NSString stringWithFormat:@"fase %d",[level intValue]];
}
+ (NSString *)nameOfWorld:(NSNumber *)world{
    return @"House";
}

+ (NSNumber *)numberOfWorlds{
    return @1;
}
+ (NSString *)descriptionOfLevel:(NSNumber *)level{
    return @"Descrição do Level 1";
}
+ (void)playLevel:(NSNumber *)level ofWorld:(NSNumber *)world withTransition:(SKTransition *)transition onScene:(SKScene *)lastScene{
    if([level intValue]<=[[self numberOfLevels] intValue]){
        /*
         PGPlayGameScene *nextScene = [[PGPlayGameScene alloc] initWithSize:lastScene.size level:level andWorld:world];
         
         [lastScene.view presentScene:nextScene transition:transition];
         */
    }else NSLog(@"BUG");
}

+ (void)initializeLevel:(NSNumber *)level ofWorld:(NSNumber *)world onScene:(SKScene *)scene
{
    SEL aSelector = NSSelectorFromString([NSString stringWithFormat:@"initializeLevel%02dofWorld%02donScene:", [level intValue], [world intValue]]);
    
    [self performSelector:aSelector withObject:scene];
}


+ (void)initializeLevel01ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //[self configure:scene withBackgroundColor:[UIColor whiteColor]];
    
    scene.level=[[JAGLevel alloc] initWithHeight:30 withWidth:30];
    
    scene.level.tileSize=32;
    
    CGSize tamanho=CGSizeMake(scene.level.tileSize, scene.level.tileSize);
    
    scene.gota= [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 1)] withSize:tamanho];
    scene.fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 5)] withSize:tamanho];
    
    //_tileSize=32;
    //scene.diferenca = 80.0f;
    //tocou = false;
    
    scene.cropNode = [[SKCropNode alloc] init];
    
    
    
    //[scene.cropNode addChild:scene.gota];
    
    [scene createMask:100 withPoint:(scene.gota.position)];
    
    [scene.cropNode addChild:scene.gota];
    
    [scene.level createWalls:CGPointMake(0, 0) withHeight:20 withWidth:10 withScene:scene];
    
    [scene.level createWalls:CGPointMake(3, 3) withHeight:10 withWidth:3 withScene:scene];
    
    [scene.level createWalls:CGPointMake(6, 3) withHeight:10 withWidth:1 withScene:scene];
    
    scene.hud =[[JAGHud alloc] initWithTempo:300 withVida:3 withWindowSize:scene.frame.size];
    
    [scene addChild:scene.hud];
    
    [scene.cropNode addChild:scene.fogo];
    
    [scene addChild: scene.cropNode];
    
    [scene.hud startTimer];
    
    
   // JAGHud *hud=[JAGHud alloc]
}

@end
