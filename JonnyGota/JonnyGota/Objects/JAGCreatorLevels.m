//
//  JAGCreatorLevels.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCreatorLevels.h"
#import "JAGPlayGameScene.h"
#import "JAGObjeto.h"
#import "JAGPressao.h"
#import "JAGChuva.h"
#import "JAGChave.h"
#import "JAGFonte.h"
#import "JAGTrovaoEnemy.h"
#import "JAGPerdaFogo.h"
#import "JAGSparkRaio.h"
#import "JAGTrap.h"

@implementation JAGCreatorLevels

+ (NSNumber *)numberOfLevels:(int)mundo{
    switch (mundo) {
        case 1:
            return @2;
            break;
            
        default:
            return @1;
            break;
    }
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
    if([level intValue] <= [[self numberOfLevels:1] intValue]){
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
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundChuva"];
    
    scene.portas = [[NSMutableArray alloc] init];
    scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
    scene.level.tileSize = 64;
    
    CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
    
    scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 1)] withSize:tamanho];
    
    [scene configInit:bgImage];
    
    //Fogo
    JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 5)] withSize:tamanho];
    fogo.dano=10;
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y+100)]];
    [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
    
    fogo.arrPointsPath = paths;
    
    //Trovao
    
    JAGTrovaoEnemy *trovao = [[JAGTrovaoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 10)] withSize:tamanho];
    trovao.dano = 10;
    
    NSMutableArray *patht = [[NSMutableArray alloc] init];
    [patht addObject:[NSValue valueWithCGPoint:CGPointMake(trovao.position.x, trovao.position.y+100)]];
    [patht addObject:[NSValue valueWithCGPoint:CGPointMake(trovao.position.x, trovao.position.y)]];
    
    trovao.arrPointsPath = patht;
    
    [scene.characteres addObject:scene.gota];
    [scene.characteres addObject:fogo];
    [scene.characteres addObject:trovao];
    
    [scene.inimigos addObject:fogo];
    [scene.inimigos addObject:trovao];
    
    //_tileSize=32;
    //scene.diferenca = 80.0f;
    //tocou = false;
    
    JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTile:CGPointMake(7, 8)] withTipo:1];
    
    SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
    
    JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 17)] withSprite:spritePor];
    
    //Fonte
    
    SKSpriteNode *fonteSprite = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(scene.frame.size.width*0.1, scene.frame.size.width*0.1)];
    JAGFonte *fonte = [[JAGFonte alloc] initWithPosition:[scene.level calculateTile:CGPointMake(6, 13)] withSprite:fonteSprite];
    [scene.cropNode addChild:porta];
    [scene.cropNode addChild:fonte];
    [porta vincularBotao:presao];
    
    [scene.portas addObject:porta];
    
    JAGChuva *chuva = [[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 19)]];
    
    [scene.cropNode addChild:chuva];
    [scene.cropNode addChild:presao];
    
    //[scene.cropNode addChild:scene.gota];
    
    [scene createMask:100 withPoint:(scene.gota.position)];
    
    [scene.cropNode addChild:scene.gota];
    
    //Box limite
    
    [scene.level createWalls:CGPointMake(0, 0) withHeight:20 withWidth:10 withScene:scene];
    [scene.level createWalls:CGPointMake(10, 0) withHeight:20 withWidth:1 withScene:scene];
    [scene.level createWalls:CGPointMake(0, 20) withHeight:1 withWidth:11 withScene:scene];
    
    
    //Chave
    SKSpriteNode *oi = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(scene.frame.size.width*0.02, scene.frame.size.height*0.05)];
    JAGChave *chave = [[JAGChave alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 4)] withSprite:oi];
    
    //TRAP!
    SKSpriteNode *oi2 = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(scene.frame.size.width*0.05, scene.frame.size.height*0.05)];
    JAGTrap *trap = [[JAGTrap alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 10)] withSprite:oi2];
    trap.tipo = 1;
    //Box do Inimigo
    
    [scene.level createWalls:CGPointMake(3, 3) withHeight:10 withWidth:3 withScene:scene];
    [scene.level createWalls:CGPointMake(6, 3) withHeight:10 withWidth:1 withScene:scene];
    
    //Box do Challenge
    
    [scene.level createWalls:CGPointMake(8, 17) withHeight:3 withWidth:1 withScene:scene];
    
    [scene.cropNode addChild:chave];
    [scene.cropNode addChild:trap];
    
    scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
    
    scene.gota.vida = 15;
    scene.hud.gota  = scene.gota;
    
    [scene.cropNode addChild:fogo];
    [scene.cropNode addChild:trovao];
    
    [scene addChild: scene.cropNode];
    
    [scene.hud startTimer];
    
    JAGObjeto *obj = [[JAGObjeto alloc] init];
    SKSpriteNode *cron = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(scene.level.tileSize-1, scene.level.tileSize-1)];
    [obj criarObj:[scene.level calculateTile:CGPointMake(9, 3)] comTipo:2 eSprite:cron];
    
    [scene.cropNode addChild:obj];
    
    //JAGPerdaFogo *perda_fogo = [[JAGPerdaFogo alloc] initWithPosition:fogo.position withTimeLife:10];
    SKAction *diminuirSaude = [SKAction sequence:@[[SKAction waitForDuration:5],
                                                   [SKAction runBlock:^{
        JAGPerdaFogo *perda_fogo = [[JAGPerdaFogo alloc] initWithPosition:fogo.position withTimeLife:10];
        JAGSparkRaio *spark = [[JAGSparkRaio alloc] initWithPosition:trovao.position withTimeLife:10];
        
        [scene.cropNode addChild:perda_fogo.emitter];
        [scene.cropNode addChild:spark.emitter];
        
        SKAction *destruir = [SKAction sequence:@[[SKAction waitForDuration:5],
                                                  [SKAction runBlock:^{
            
            [perda_fogo.emitter removeFromParent];
            [spark.emitter removeFromParent];
            NSLog(@"pos %@", [NSValue valueWithCGPoint:trovao.position]);
            [trovao moveTelep];
            
        }]]];
        
        [scene runAction:destruir];
        
    }]]];
    
    SKAction *loop = [SKAction repeatActionForever:diminuirSaude];
    
    [scene runAction:loop];
    
    [scene configStart:8];
    
    scene.hud.zPosition = 1000;
    
    [scene addChild:scene.hud];
    
    // JAGHud *hud = [JAGHud alloc]
}

+ (void)initializeLevel02ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //[self configure:scene withBackgroundColor:[UIColor whiteColor]];
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundChuva"];
    
    scene.portas = [[NSMutableArray alloc] init];
    
    scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
    
    scene.level.tileSize = 32;
    
    CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
    
    
    scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(3, 1)] withSize:tamanho];
    
    [scene configInit:bgImage];
    
    JAGTrovaoEnemy *fogo = [[JAGTrovaoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 5)] withSize:tamanho];
    fogo.dano = 10;
    
    [scene.characteres addObject:scene.gota];
    [scene.characteres addObject:fogo];
    
    [scene.inimigos addObject:fogo];
    
    //_tileSize=32;
    //scene.diferenca = 80.0f;
    //tocou = false;
    
    JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTile:CGPointMake(7, 8)] withTipo:1];
    
    SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
    
    JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 17)] withSprite:spritePor];
    
    //Fonte
    SKSpriteNode *fonteSprite = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(scene.frame.size.width*0.1, scene.frame.size.width*0.1)];
    JAGFonte *fonte = [[JAGFonte alloc] initWithPosition:CGPointMake(scene.frame.size.width*0.5, scene.frame.size.height*0.7) withSprite:fonteSprite];
    [scene.cropNode addChild:porta];
    [scene.cropNode addChild:fonte];
    [porta vincularBotao:presao];
    
    [scene.portas addObject:porta];
    
    JAGChuva *chuva = [[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 19)]];
    
    [scene.cropNode addChild:chuva];
    
    
    [scene.cropNode addChild:presao];
    
    //[scene.cropNode addChild:scene.gota];
    
    [scene createMask:100 withPoint:(scene.gota.position)];
    
    [scene.cropNode addChild:scene.gota];
    
    //Box limite
    
    [scene.level createWalls:CGPointMake(0, 0) withHeight:20 withWidth:10 withScene:scene];
    [scene.level createWalls:CGPointMake(10, 0) withHeight:20 withWidth:1 withScene:scene];
    [scene.level createWalls:CGPointMake(0, 20) withHeight:1 withWidth:11 withScene:scene];
    
    //Chave
    SKSpriteNode *oi = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(scene.frame.size.width*0.02, scene.frame.size.height*0.05)];
    JAGChave *chave = [[JAGChave alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 4)] withSprite:oi];
    
    
    
    //Box do Inimigo
    
    [scene.level createWalls:CGPointMake(3, 3) withHeight:10 withWidth:3 withScene:scene];
    
    [scene.level createWalls:CGPointMake(6, 3) withHeight:10 withWidth:1 withScene:scene];
    
    //Box do Challenge
    
    [scene.level createWalls:CGPointMake(8, 17) withHeight:3 withWidth:1 withScene:scene];
    
    [scene.cropNode addChild:chave];
    
    
    scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
    
    [scene addChild:scene.hud];
    
    
    scene.gota.vida = 15;
    scene.hud.gota = scene.gota;
    
    [scene.cropNode addChild:fogo];
    
    [scene addChild: scene.cropNode];
    
    [scene.hud startTimer];
    
    JAGObjeto *obj = [[JAGObjeto alloc] init];
    SKSpriteNode *cron = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(scene.level.tileSize-1, scene.level.tileSize-1)];
    [obj criarObj:[scene.level calculateTile:CGPointMake(9, 3)] comTipo:2 eSprite:cron];
    
    [scene.cropNode addChild:obj];
    
    [scene configStart:8];
    
    
    // JAGHud *hud=[JAGHud alloc]
}


@end
