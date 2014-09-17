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
#import "JSTileMap.h"
#import "JAGPreparePoints.h"

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
    scene.level.frequenciaRelampago = 10.0;
    CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
    
    scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 1)] withSize:tamanho];
    
    [scene configInit:bgImage];
    
    //Fogo
    JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 5)] withSize:tamanho];
    fogo.dano=10;
    
    [fogo activateIa];
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y+100)]];
    [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
    
    

    fogo.arrPointsPath = paths;
    
    //Trovao
    
    JAGTrovaoEnemy *trovao = [[JAGTrovaoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 10)] withSize:tamanho];
    trovao.dano = 10;
   [trovao moveTelep:[scene.level calculateTile:CGPointMake(2, 3)]];
    
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
    
    JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTile:CGPointMake(7, 8)] withTipo:3 withSize:tamanho];
    
    SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
    
    JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 17)] withSprite:spritePor];
    
    //Fonte
    
    SKSpriteNode *fonteSprite = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:tamanho];
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
    
    
    //Box limite
    
    [scene.level createWalls:CGPointMake(0, 0) withHeight:20 withWidth:10 withScene:scene];
    [scene.level createWalls:CGPointMake(10, 0) withHeight:20 withWidth:1 withScene:scene];
    [scene.level createWalls:CGPointMake(0, 20) withHeight:1 withWidth:11 withScene:scene];
    
    
    //Chave
    SKSpriteNode *oi = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(scene.frame.size.width*0.02, scene.frame.size.height*0.05)];
    JAGChave *chave = [[JAGChave alloc] initWithPosition:[scene.level calculateTile:CGPointMake(5, 4)] withSprite:oi];
    
    //TRAP!
    SKSpriteNode *oi2 = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:tamanho];
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
    
    [scene.cropNode addChild:scene.gota];

    
    //JAGPerdaFogo *perda_fogo = [[JAGPerdaFogo alloc] initWithPosition:fogo.position withTimeLife:10];
    SKAction *diminuirSaude = [SKAction sequence:@[[SKAction waitForDuration:5],
                                                   [SKAction runBlock:^{
        JAGPerdaFogo *perda_fogo = [[JAGPerdaFogo alloc] initWithPosition:fogo.position withTimeLife:10];
//        JAGSparkRaio *spark = [[JAGSparkRaio alloc] initWithPosition:trovao.position withTimeLife:10];
        
        [scene.cropNode addChild:perda_fogo.emitter];
//        [scene.cropNode addChild:spark.emitter];
        
        SKAction *destruir = [SKAction sequence:@[[SKAction waitForDuration:5],
                                                  [SKAction runBlock:^{
            
            [perda_fogo.emitter removeFromParent];
//            [spark.emitter removeFromParent];
//            NSLog(@"pos %@", [NSValue valueWithCGPoint:trovao.position]);
//            [trovao moveTelep:[scene.level calculateTile:CGPointMake(2, 3)]];
            
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
//    JSTileMap *map;
//    TMXLayer *tile;
//    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map1.tmx"];
    if (tiledMap){
        
        
//        [bgLayer physicsBody];
        scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
        scene.level.tileSize = 64;
        
//        [scene configInit:bgImage];

        scene.level.frequenciaRelampago = 10.0;
        CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(2, 2)] withSize:tamanho];
        
//        CGRect mapBounds = [tiledMap calculateAccumulatedFrame];
//        tiledMap.position = CGPointMake(-mapBounds.size.width/2.0, -mapBounds.size.height/2.0);

        tiledMap.position = CGPointMake(0, 0);
        [scene configInit];
        
        
//        [self createPhiscsBodytoLayer:tiledMap];
        
//        [scene addChild:tiledMap];
        
        
        [scene.cropNode addChild:tiledMap];
        
        [scene.cropNode addChild:[self createPhiscsBodytoLayer:tiledMap]];

        
//        [scene.cropNode addChild:bgLayer];
        
        
        
//        [tiledMap.imageLayers[0]];
        
        [scene createMask:100 withPoint:(scene.gota.position)];

        
        scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
        
        scene.gota.vida = 15;
        scene.hud.gota  = scene.gota;
        
        [scene.cropNode addChild:scene.gota];

        
        [scene addChild: scene.cropNode];
        
        [scene.hud startTimer];

        [scene configStart:8];
        
        
    }
}


+(SKNode *)createPhiscsBodytoLayer:(JSTileMap*) tileMap{
   
    TMXLayer* bgLayer = [tileMap layerNamed:@"Tile"];
    
    NSMutableArray *nodes=[[NSMutableArray alloc] init];
    
    
    
    for (int a = 0; a < tileMap.mapSize.width; a++)
	{
		for (int b = 0; b < tileMap.mapSize.height; b++)
		{
//			TMXLayerInfo* layerInfo = [tileMap.layers firstObject];
            TMXLayerInfo* layerInfo=[bgLayer layerInfo];
			CGPoint pt = CGPointMake(a, b);
			NSInteger gid = [layerInfo.layer tileGidAt:[layerInfo.layer pointForCoord:pt]];
            
//            NSLog(@"ptx:%d y:%d  gid:%d",a,b,gid);
            
//            NSLog(@"a: %d  b:%d  gid:%d",a,b,gid);
			if (gid != 0)
			{
                
//                SKPhysicsBody *node=[[SKNode alloc] init];
//                node.size=tileMap.tileSize;
                
                JAGPreparePoints *ponto=[[JAGPreparePoints alloc] init];
                
                ponto.ponto=CGPointMake(tileMap.tileSize.width*a+tileMap.tileSize.width/2,  (tileMap.tileSize.height*(tileMap.mapSize.height-b-1)+tileMap.tileSize.height/2));
                
                ponto.usado=NO;
                
                if (![ponto procurarProximo:nodes withTileSize:tileMap.tileSize.height]) {
                    [nodes addObject:ponto];
                };
                
                
               
//                NSLog(@"a: %d  b:%d  gid:%d",a,b,gid);
//                SKPhysicsBody *node;
//                node=[SKPhysicsBody bodyWithRectangleOfSize:tileMap.tileSize center:CGPointMake(tileMap.tileSize.width*a+tileMap.tileSize.width/2,  (tileMap.tileSize.height*(tileMap.mapSize.height-b-1)+tileMap.tileSize.height/2))];
//                node.dynamic = NO;
//                node.restitution=0.0;
                
//                node.position=CGPointMake(tileMap.tileSize.width*a, tileMap.tileSize.height*b);
                
//                [nodes addObject:node];
//				SKSpriteNode* node = [layerInfo.layer tileAtCoord:pt];
                
//                NSLog(@"node %d",node);
//              [nodes addObject:node];
                
//				node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
//				node.physicsBody.dynamic = NO;
//                node.physicsBody.restitution=0.0;
                //				NSLog(@"BRICK AT (%d, %d) is (%.2f, %.2f, %.2f, %.2f)", a, b, node.frame.origin.x, node.frame.origin.y, node.frame.size.width, node.frame.size.height);
                //				SKSpriteNode* node2 = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:node.frame.size];
                //				node2.position = node.frame.origin;
                //				node2.anchorPoint = CGPointMake(0, 0);
                //				[self addChild:node2];
			}
		}
	}
    
    NSMutableArray *nodesPhy=[[NSMutableArray alloc] init];
    
        for (int i=nodes.count-1; i>0;i--) {
        JAGPreparePoints *ponto=(JAGPreparePoints *)nodes[i];
        
        CGPoint pontos=ponto.ponto;
        
//        while (proximoAlto.proximo!=nil && (proximoAlto.usado!=YES)) {
        int tamy=tileMap.tileSize.height;

        int tamx=tileMap.tileSize.width;
//        JAGPreparePoints *proximo=ponto.proximo;
//        while (proximo!=nil && (proximo.usado==false) && ponto.usado==false) {
//            tamx+=tileMap.tileSize.width;
//            proximo.usado=true;
//            pontos.x=proximo.ponto.x;
//            proximo=proximo.proximo;
//        }
            
        JAGPreparePoints *proximoAlto=ponto.proximoAlto;
        while (proximoAlto!=nil && proximoAlto.usadoAlto==false ) {
            tamy+=tileMap.tileSize.height;
            proximoAlto.usadoAlto=true;
                
            pontos.y=proximoAlto.ponto.y;
            proximoAlto=proximoAlto.proximoAlto;
        }
        
        if (ponto.usado==false && ponto.usadoAlto==false) {
            ponto.usado=true;
            SKPhysicsBody *node;
//            node=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(tamx, tamy) center:CGPointMake(ponto.ponto.x+(tamx-tileMap.tileSize.width)/2, ponto.ponto.y+(tamy-tileMap.tileSize.height)/2)];
            
            
            node=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(tamx, tamy) center:CGPointMake(pontos.x+(tamx-tileMap.tileSize.width)/2, ponto.ponto.y+(tamy-tileMap.tileSize.height)/2)];
            
            [nodesPhy addObject:node];
        }
    }
    
    
    
    
    SKNode *nodofinal=[[SKNode alloc] init];
    nodofinal.physicsBody=[SKPhysicsBody bodyWithBodies:nodesPhy];
    nodofinal.physicsBody.dynamic=NO;
    nodofinal.physicsBody.restitution=0;
    
    return nodofinal;
}
@end
