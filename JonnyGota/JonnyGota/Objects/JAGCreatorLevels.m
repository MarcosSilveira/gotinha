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
            return @3;
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
        
        scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
        scene.level.tileSize = 64;
        


        scene.level.frequenciaRelampago = 10.0;
        CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tamanho];

        tiledMap.position = CGPointMake(0, 0);
        [scene configInit];
        
        

        
        //Mapa
        [scene.cropNode addChild:tiledMap];
        
        [scene.cropNode addChild:[self createPhiscsBodytoLayer:tiledMap]];

        
        //Mascara
        
        [scene createMask:100 withPoint:(scene.gota.position)];
        
        
        //Add Monstros
        
        
        
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(3, 20)]];
        
        [scene.cropNode addChild:scene.level.chuva];

        

        //Config de hud e faze
        scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
        
        scene.gota.vida = 15;
        scene.hud.gota  = scene.gota;
        
        [scene.cropNode addChild:scene.gota];
        
       

        
        [scene addChild: scene.cropNode];
        
        [scene addChild:scene.hud];
        
        [scene.hud startTimer];

        [scene configStart:8];
        
        
    }
}

+ (void)initializeLevel03ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map2.tmx"];
    if (tiledMap){
        
        scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
        scene.level.tileSize = 64;
        
        
        
        scene.level.frequenciaRelampago = 10.0;
        CGSize tamanho = CGSizeMake(scene.level.tileSize, scene.level.tileSize);
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tamanho];
        
        tiledMap.position = CGPointMake(0, 0);
        [scene configInit];
        
        
        
        
        //Mapa
        [scene.cropNode addChild:tiledMap];
        
        [scene.cropNode addChild:[self createPhiscsBodytoLayer:tiledMap]];
        
        
        //Mascara
        
        [scene createMask:100 withPoint:(scene.gota.position)];
        
        
        //Add Monstros
        
        
        
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(2, 18)]];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        
        
        //Config de hud e faze
        scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
        
        scene.gota.vida = 15;
        scene.hud.gota  = scene.gota;
        
        [scene.cropNode addChild:scene.gota];
        
        
        
        
        [scene addChild: scene.cropNode];
        
        [scene addChild:scene.hud];
        
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
                
                
            }
		}
	}
    
    NSMutableArray *nodesPhy=[[NSMutableArray alloc] init];
    
    for (int i=nodes.count-1; i>0;i--) {
        JAGPreparePoints *ponto=(JAGPreparePoints *)nodes[i];
        
        if(i==nodes.count-1){
//            NSLog(@"ponto x. ponto y.  proximo.x  proximo. y  ")
        }
        
        CGPoint inicial1=CGPointMake(ponto.ponto.x-tileMap.tileSize.width/2, (ponto.ponto.y-tileMap.tileSize.height/2));
        
        CGPoint inicial2=CGPointMake(ponto.ponto.x+tileMap.tileSize.width/2, (ponto.ponto.y-tileMap.tileSize.height/2));
        
        if(ponto.proximo!=nil){
            inicial1=CGPointMake(ponto.ponto.x+tileMap.tileSize.width/2, ponto.ponto.y-tileMap.tileSize.height/2);
        }
        
    
        if (ponto.usadoAlto==false && ponto.usado==false) {
            
            CGMutablePathRef ponti=CGPathCreateMutable();
            
            CGPathMoveToPoint(ponti, nil, inicial1.x, inicial1.y);
            CGPathAddLineToPoint(ponti, nil, inicial2.x, inicial2.y);
            [nodesPhy addObject:[self fazColunas:ponto withPath:ponti withtileSize:tileMap.tileSize withArray:nodesPhy]];

            
        }
    }
    
    
    
    SKNode *nodofinal=[[SKNode alloc] init];
    nodofinal.physicsBody=[SKPhysicsBody bodyWithBodies:nodesPhy];
    nodofinal.physicsBody.dynamic=NO;
    nodofinal.physicsBody.restitution=0;
    
    nodofinal.physicsBody.categoryBitMask = PAREDE;
    nodofinal.physicsBody.collisionBitMask = ATTACK;
    nodofinal.name = @"wall";
    
//    return nil;
    return nodofinal;
}

+(SKPhysicsBody*)fazColunas:(JAGPreparePoints *)inicial
                   withPath:(CGMutablePathRef) pontos
               withtileSize:(CGSize)tileSize
                  withArray:(NSMutableArray*)nodesPhy{
    if(inicial!=nil){
        
        
        JAGPreparePoints *proximoAlto=inicial;
        
        CGPoint fim1;
        CGPoint fim2;
        
        bool criou=false;
               
        while (proximoAlto!=nil && proximoAlto.usadoAlto==false ) {
            //            tamy+=tileMap.tileSize.height;
            proximoAlto.usadoAlto=true;
 
            fim1=CGPointMake(proximoAlto.ponto.x-tileSize.width/2, proximoAlto.ponto.y+tileSize.height/2);
            
            fim2=CGPointMake(proximoAlto.ponto.x+tileSize.width/2, proximoAlto.ponto.y+tileSize.height/2);
            
            if (proximoAlto.proximo!=nil &&proximoAlto.proximo.usado==false ) {
                CGPoint inicioReta=CGPointMake((proximoAlto.ponto.x+tileSize.width/2), proximoAlto.ponto.y-tileSize.height/2);
                
                CGPoint inicioReta2=CGPointMake((proximoAlto.ponto.x+tileSize.width/2)-2, proximoAlto.ponto.y+tileSize.height/2);
                //                CGPathAddLineToPoint(ponti, nil, inicioReta.x, inicioReta.y);
                
                
                
                if (proximoAlto.antes==false) {
                    inicioReta=CGPointMake((proximoAlto.ponto.x+tileSize.width/2)-3, proximoAlto.ponto.y-tileSize.height/2);
                }
                
                

                CGMutablePathRef pontosn=CGPathCreateMutable();
                
                CGPathMoveToPoint(pontosn, nil, inicioReta.x, inicioReta.y);
                
                CGPathAddLineToPoint(pontosn, nil, inicioReta2.x, inicioReta2.y);
                
                //                NSLog(@"4 casos");
                
               
                
                [nodesPhy addObject:[self fazlinhas:proximoAlto withPath:pontosn withtileSize:tileSize withArray:nodesPhy]];
                
                if(criou){
                    
                }
                
            }else{
                
                if (proximoAlto.antesAlto==false &&proximoAlto.proximoAlto!=nil) {
                    criou=true;
                }
                
            
            
            if(proximoAlto.proximoAlto==nil&& proximoAlto.proximo!=nil){
                fim1=CGPointMake(proximoAlto.ponto.x-tileSize.width/2, proximoAlto.ponto.y-tileSize.height/2);
                
            }
            
            if(proximoAlto.antes==false){
                fim1=CGPointMake(proximoAlto.ponto.x-tileSize.width/2, (proximoAlto.ponto.y+tileSize.height/2)-2);
                
                fim2=CGPointMake((proximoAlto.ponto.x+tileSize.width/2)-2, (proximoAlto.ponto.y+tileSize.height/2)-2);
            }
            
            
            }
            
            proximoAlto=proximoAlto.proximoAlto;
        }
       
        
        CGPathAddLineToPoint(pontos, nil, fim2.x, fim2.y);
        CGPathAddLineToPoint(pontos, nil, fim1.x, fim1.y);
        
        CGPathCloseSubpath(pontos);
        
        SKPhysicsBody *node;
        node=[SKPhysicsBody bodyWithPolygonFromPath:pontos];
        
        return node;
    }
    return nil;
}

+(SKPhysicsBody*)fazlinhas:(JAGPreparePoints *)inicial
        withPath:(CGMutablePathRef) pontos
    withtileSize:(CGSize)tileSize
                 withArray:(NSMutableArray*)nodesPhy{
    if(inicial!=nil){
        
        
        JAGPreparePoints *proximo=inicial;
        
        CGPoint fim1;
        CGPoint fim2;
        
        CGPoint save;
        while (proximo!=nil && proximo.usado==false) {
            proximo.usado=true;
            
            if((proximo.proximoAlto!=nil&& proximo.proximoAlto.proximo==nil && proximo.proximoAlto.usadoAlto==false)){
                //Recursivo do bloco coluna
                
                CGPoint inicioReta=CGPointMake((proximo.ponto.x-tileSize.width/2)-2, (proximo.ponto.y+tileSize.height/2));
                
                CGPoint inicioReta2=CGPointMake((proximo.ponto.x+tileSize.width/2)-2, proximo.ponto.y+tileSize.height/2);
                //                CGPathAddLineToPoint(ponti, nil, inicioReta.x, inicioReta.y);
                
                CGMutablePathRef pontosn=CGPathCreateMutable();
                
                CGPathMoveToPoint(pontosn, nil, inicioReta.x, inicioReta.y);
                
                 if(proximo.antes==true && proximo.proximo==nil){
                    
                     inicioReta=CGPointMake((proximo.ponto.x-tileSize.width/2)-2, (proximo.ponto.y-tileSize.height/2));
                     inicioReta2=CGPointMake((proximo.ponto.x+tileSize.width/2)-2, (proximo.ponto.y-tileSize.height/2));

                     CGPathMoveToPoint(pontosn, nil, inicioReta.x, inicioReta.y);
                     CGPathAddLineToPoint(pontosn, nil, inicioReta2.x, inicioReta2.y);
               
                     
                 }else{
                     
                     
                     if(proximo.antes==false){
                         inicioReta=CGPointMake((proximo.ponto.x-tileSize.width/2)-2, (proximo.ponto.y-tileSize.height/2));
                         inicioReta2=CGPointMake((proximo.ponto.x+tileSize.width/2)-3, (proximo.ponto.y-tileSize.height/2));
                         
                         CGPathMoveToPoint(pontosn, nil, inicioReta.x, inicioReta.y);
                         CGPathAddLineToPoint(pontosn, nil, inicioReta2.x, inicioReta2.y);

                     }else{
                     
                        CGPathMoveToPoint(pontosn, nil, inicioReta.x, inicioReta.y);
                        CGPathAddLineToPoint(pontosn, nil, inicioReta2.x, inicioReta2.y);
                     }
                 }

                
                [nodesPhy addObject:[self fazColunas:proximo.proximoAlto withPath:pontosn withtileSize:tileSize withArray:nodesPhy]];
            }else{
                
                if (proximo.proximoAlto!=nil) {
                    fim1=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y-tileSize.height/2);
                    
                    fim2=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y+tileSize.height/2);
//                    NSLog(@"KKK");

                    
                }else{
                    
                    if(proximo.antes==false){
                        fim1=CGPointMake((proximo.ponto.x-tileSize.width/2)-2, proximo.ponto.y-tileSize.height/2);
                        
                        fim2=CGPointMake((proximo.ponto.x+tileSize.width/2)-2, proximo.ponto.y+tileSize.height/2);
                        
//                        NSLog(@"YYY");

                    }
                    
                    if(proximo.proximo!=nil && proximo.proximo.antesAlto==true){
                        
                        fim1=CGPointMake(proximo.ponto.x-tileSize.width/2, (proximo.ponto.y-tileSize.height/2)+2);
                        
                        fim2=CGPointMake(proximo.ponto.x-tileSize.width/2, (proximo.ponto.y+tileSize.height/2)-2);
                        
//                        NSLog(@"QQQ");

 
                    }

                    fim1=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y-tileSize.height/2);
                    
                    fim2=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y+tileSize.height/2);
                    
                    if(proximo.proximo.proximoAlto!=nil&& proximo.proximo.proximoAlto.proximo==nil && proximo.proximo.proximoAlto.usadoAlto==false){
                        fim1=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y-tileSize.height/2);
                        
                        fim2=CGPointMake(proximo.ponto.x-tileSize.width/2, proximo.ponto.y+tileSize.height/2);

//                        NSLog(@"Quantas vezes");
                    }
                    
                    if(proximo.proximo==nil){
                        save=proximo.ponto;
                       
                    }

                }
               
                
                
               
            }
            
            

            
            proximo=proximo.proximo;
        }
        
        
        
        if(proximo.proximo==nil&&proximo.proximoAlto!=nil){
            NSLog(@"Final da linha com acima");
            
            fim2=CGPointMake((proximo.ponto.x+tileSize.width/2)+2, proximo.ponto.y-tileSize.height/2);
            
            fim1=CGPointMake((proximo.ponto.x-tileSize.width/2)+2, proximo.ponto.y-tileSize.height/2);

        }
        
       
        
        
        CGPathAddLineToPoint(pontos, nil, fim2.x, fim2.y);
        CGPathAddLineToPoint(pontos, nil, fim1.x, fim1.y);
        
        CGPathCloseSubpath(pontos);
        
        SKPhysicsBody *node;
        node=[SKPhysicsBody bodyWithPolygonFromPath:pontos];
        
        return node;
    }
    return nil;
}
@end
