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
#import "DSMultilineLabelNode.h"

@implementation JAGCreatorLevels



+ (NSNumber *)numberOfLevels:(int)mundo{
    switch (mundo) {
        case 1:
            return @9;
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

+(SKNode *)createPhiscsBodytoLayer:(JSTileMap*) tileMap{
    
    TMXLayer* bgLayer = [tileMap layerNamed:@"Tile"];
    
    NSMutableArray *nodes=[[NSMutableArray alloc] init];
    
    
    //Ler os pontos
    
    
    for (int a = 0; a < tileMap.mapSize.width; a++)
    {
        for (int b = 0; b < tileMap.mapSize.height; b++)
        {
            
            TMXLayerInfo* layerInfo=[bgLayer layerInfo];
            CGPoint pt = CGPointMake(a, b);
            NSInteger gid = [layerInfo.layer tileGidAt:[layerInfo.layer pointForCoord:pt]];
            
            
            if (gid != 0)
            {
                
                //Preapara o array de pontos
                JAGPreparePoints *ponto=[[JAGPreparePoints alloc] init];
                
                ponto.ponto=CGPointMake(tileMap.tileSize.width*a+tileMap.tileSize.width/2,  (tileMap.tileSize.height*(tileMap.mapSize.height-b-1)+tileMap.tileSize.height/2));
                
                ponto.usado=NO;
                
                if (![ponto procurarProximo:nodes withTileSize:tileMap.tileSize.width]) {
                    [nodes addObject:ponto];
                };
                
                
            }
        }
    }
    
    
    //Cria o physhics body
    NSMutableArray *nodesPhy=[[NSMutableArray alloc] init];
    
    for (int i=nodes.count-1; i>0;i--) {
        JAGPreparePoints *ponto=(JAGPreparePoints *)nodes[i];
        
        
        
        if (ponto.usadoAlto==false ) {
            
            CGMutablePathRef ponti=CGPathCreateMutable();
            
            //            SKPhysicsBody *temp=[self fazColunas:ponto withPath:ponti withtileSize:CGSizeMake(tamanho, tamanho) withArray:nodesPhy];
            SKPhysicsBody *temp=[self fazColunas:ponto withPath:ponti withtileSize:tileMap.tileSize withArray:nodesPhy];
            
            if(temp!=nil){
                [nodesPhy addObject:temp];
            }
            
            
        }
        if (ponto.usado==false){
            CGMutablePathRef ponti=CGPathCreateMutable();
            
            //            SKPhysicsBody *temp=[self fazlinhas:ponto withPath:ponti withtileSize:CGSizeMake(tamanho, tamanho) withArray:nodesPhy];
            
            SKPhysicsBody *temp=[self fazlinhas:ponto withPath:ponti withtileSize:tileMap.tileSize withArray:nodesPhy];
            if(temp!=nil){
                [nodesPhy addObject:temp];
            }
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
    if(inicial!=nil && (inicial.antes!=true|| inicial.proximo==nil)){
        
        
        
        JAGPreparePoints *proximoAlto=inicial;
        
        CGPoint fim1;
        CGPoint fim2;
        
        CGPoint inicial1=CGPointMake(proximoAlto.ponto.x-tileSize.width/2, (proximoAlto.ponto.y-tileSize.height/2)+2);
        
        CGPoint inicial2=CGPointMake(proximoAlto.ponto.x+tileSize.width/2, (proximoAlto.ponto.y-tileSize.height/2)+2);
        
        
        CGMutablePathRef pontosn=CGPathCreateMutable();
        
        CGPathMoveToPoint(pontosn, nil, inicial1.x, inicial1.y);
        
        CGPathAddLineToPoint(pontosn, nil, inicial2.x, inicial2.y);
        
        
        while (proximoAlto!=nil && proximoAlto.usadoAlto==false ) {
            //            tamy+=tileMap.tileSize.height;
            proximoAlto.usadoAlto=true;
            
            fim1=CGPointMake(proximoAlto.ponto.x-tileSize.width/2, (proximoAlto.ponto.y+tileSize.height/2)-2);
            
            fim2=CGPointMake(proximoAlto.ponto.x+tileSize.width/2, (proximoAlto.ponto.y+tileSize.height/2)-2);
            
            proximoAlto=proximoAlto.proximoAlto;
        }
        
        
        CGPathAddLineToPoint(pontosn, nil, fim2.x, fim2.y);
        CGPathAddLineToPoint(pontosn, nil, fim1.x, fim1.y);
        
        CGPathCloseSubpath(pontosn);
        
        SKPhysicsBody *node;
        node=[SKPhysicsBody bodyWithPolygonFromPath:pontosn];
        
        return node;
    }
    
    return nil;
}

+(SKPhysicsBody*)fazlinhas:(JAGPreparePoints *)inicial
                  withPath:(CGMutablePathRef) pontos
              withtileSize:(CGSize)tileSize
                 withArray:(NSMutableArray*)nodesPhy{
    
    if(inicial!=nil&& (inicial.antesAlto!=true || inicial.proximoAlto==nil)){
        
        
        JAGPreparePoints *proximo=inicial;
        
        CGPoint fim1;
        CGPoint fim2;
        
        CGPoint inicial1=CGPointMake((proximo.ponto.x+tileSize.width/2)-2, (proximo.ponto.y-tileSize.height/2));
        
        CGPoint inicial2=CGPointMake((proximo.ponto.x+tileSize.width/2)-2, (proximo.ponto.y+tileSize.height/2));
        
        
        CGMutablePathRef pontosn=CGPathCreateMutable();
        
        CGPathMoveToPoint(pontosn, nil, inicial1.x, inicial1.y);
        
        CGPathAddLineToPoint(pontosn, nil, inicial2.x, inicial2.y);
        
        
        while (proximo!=nil && proximo.usado==false) {
            proximo.usado=true;
            
            fim1=CGPointMake((proximo.ponto.x-tileSize.width/2)+2, (proximo.ponto.y+tileSize.height/2));
            
            fim2=CGPointMake((proximo.ponto.x-tileSize.width/2)+2, (proximo.ponto.y-tileSize.height/2));
            
            
            proximo=proximo.proximo;
        }
        
        
        
        CGPathAddLineToPoint(pontosn, nil, fim1.x, fim1.y);
        CGPathAddLineToPoint(pontosn, nil, fim2.x, fim2.y);
        
        CGPathCloseSubpath(pontosn);
        
        SKPhysicsBody *node;
        node=[SKPhysicsBody bodyWithPolygonFromPath:pontosn];
        
        return node;
    }
    return nil;
}

+(void)configTileMap:(JAGPlayGameScene *)scene
           withTtile:(JSTileMap*) tiledMap{
    scene.level = [[JAGLevel alloc] initWithHeight:30 withWidth:30];
    
    int tamanhot=scene.frame.size.width*0.1;
    
    scene.level.tileSize=tamanhot;
    
    
    float scale=tamanhot /(tiledMap.tileSize.width);
    
    [tiledMap setScale:scale];
    
    [tiledMap setTileSize:CGSizeMake(tamanhot, tamanhot)];
    
   
    
    
    scene.level.frequenciaRelampago = 10.0;
    //    CGSize tamanho = CGSizeMake(scene.level.tileSize*1.2, scene.level.tileSize*1.2);
}

+(void)configHud:(JAGPlayGameScene *)scene
{
    scene.hud = [[JAGHud alloc] initWithTempo:300 withVida:3 saude:scene.gota.aguaRestante withWindowSize:scene.frame.size];
    
    scene.gota.vida = 15;
    scene.hud.gota  = scene.gota;
    
    [scene.cropNode addChild:scene.gota];
    
    [scene addChild: scene.cropNode];
    
    [scene addChild:scene.hud];
    
    [scene.hud startTimer];
    
    [scene configStart:8];
}

+(void)configMap:(JAGPlayGameScene *)scene
       withTtile:(JSTileMap*) tiledMap{
    tiledMap.position = CGPointMake(0, 0);
    [scene configInit];
    
    //Mapa
    [scene.cropNode addChild:tiledMap];
    
    [scene.cropNode addChild:[self createPhiscsBodytoLayer:tiledMap]];
    
    
   
    
    //Mascara
    
    

    [scene createMask:tiledMap.tileSize.width*1.8 withPoint:(scene.gota.position)];
}



+ (void)initializeLevel99ofWorld01onScene:(JAGPlayGameScene *)scene
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
    
    JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 17)] withSprite:spritePor withTipo:3];
    
    //Fonte
    
    SKSpriteNode *fonteSprite = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:tamanho];
    JAGFonte *fonte = [[JAGFonte alloc] initWithPosition:[scene.level calculateTile:CGPointMake(6, 13)] withSprite:fonteSprite];
    [scene.cropNode addChild:porta];
    [scene.cropNode addChild:fonte];
    
    [porta vincularBotao:presao];
    
    [scene.portas addObject:porta];
    
    JAGChuva *chuva = [[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 19)] withSize:CGSizeMake(scene.level.tileSize, scene.level.tileSize) ];
    
    [scene.cropNode addChild:chuva];
    [scene.cropNode addChild:presao];
    
    //[scene.cropNode addChild:scene.gota];
    
    [scene createMask:scene.frame.size.height*0.33 withPoint:(scene.gota.position)];
    
    
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

+ (void)tutorial:(JAGPlayGameScene *) scene {
    
    SKSpriteNode *tutorialView = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(scene.size.width*.25, scene.size.height*.3)];
    tutorialView.position = CGPointMake(scene.size.width/1.15, scene.size.height/1.4);
    tutorialView.alpha = .7;
    tutorialView.zPosition = 201;
    DSMultilineLabelNode *nodeLabel = [DSMultilineLabelNode labelNodeWithFontNamed:@"VAGRoundedStd-Thin"];
    nodeLabel.fontSize = scene.frame.size.width*.02;
    nodeLabel.text = @"Funcione ";
    
    nodeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    SKAction *changeLabel = [SKAction sequence:@[[SKAction runBlock:^{
        nodeLabel.text = @"Olá Gotinha! Seja bem-vinda! Que tal se mexer um pouco? Clique em alguma direção para que você possa andar.";
        nodeLabel.paragraphWidth = tutorialView.size.width*.9;
    }],
                                                 [SKAction waitForDuration:13.0],
                                                 [SKAction runBlock:^{
        nodeLabel.text = @"Muito bem! Agora que sabe se mexer, quem sabe você dá um pequeno toque em sí própria, vamos ver o que acontece";
        nodeLabel.paragraphWidth = tutorialView.size.width*.9;
    }],
                                                 [SKAction waitForDuration:13.0],
                                                 [SKAction runBlock:^{
        nodeLabel.text = @"Isso aí! O que você acha sobre poder se dividir? Clique e arraste o dedo sobre sí mesma. ";
        nodeLabel.paragraphWidth = tutorialView.size.width*.9;
    }],
                                                 [SKAction waitForDuration:13.0],
                                                 [SKAction runBlock:^{
        nodeLabel.text = @"Agora sim! Você sabe muito bem controlar uma Gota, ande por essa casa e tente achar a sua família.";
        nodeLabel.paragraphWidth = tutorialView.size.width*.9;
    }]]];
    
    [scene runAction:changeLabel];
    
    [tutorialView addChild:nodeLabel];
    [scene addChild:tutorialView];
}

+ (void)initializeLevel01ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map1.tmx"];
    if (tiledMap){
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tiledMap.tileSize];
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        NSLog(@"Multi ? %d tile Size %f",scene.gota.multi,tiledMap.tileSize.width);

//        scene.gota.multi=14;
                //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(3, 20)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
        // Tutorial
        [JAGCreatorLevels tutorial: scene];
    }
}

+ (void)initializeLevel02ofWorld01onScene:(JAGPlayGameScene *)scene
{
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map2.tmx"];
    if (tiledMap){
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        //Gotinha
        
        
        
        
        //Mapa
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(8, 3)] withSize:tiledMap.tileSize];

        
        
        //Add Monstros
        
        JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(17, 13)] withSize:tiledMap.tileSize];
        fogo.dano=10;
        
        [fogo activateIa];
        
        fogo.activeFix=YES;
        
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y+100)]];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
        
        fogo.arrPointsPath = paths;
        
        
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(2, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        
        
        //Colocar nos arrays sempre depois do configInit
        
        [scene.characteres addObject:scene.gota];
        [scene.characteres addObject:fogo];
        
        [scene.inimigos addObject:fogo];
        
        
        //Add no crop
        [scene.cropNode addChild:fogo];
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel03ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map3.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 1)] withSize:tiledMap.tileSize];
        
        
        
        
         //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(2, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel04ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map4.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tiledMap.tileSize];
        
        
        //Colocar Portas

        
        
        
        JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(17, 12)] withTipo:3 withSize:tiledMap.tileSize];
        
        
       
        
        SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];

        
        JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(16, 9)] withSprite:spritePor withTipo:1];
        
        [porta vincularBotao:presao];
        
        [scene.level.botoes addObject:presao];
        
        scene.portas=[[NSMutableArray alloc] init];
        
        [scene.portas addObject:porta];
        
       
        
        //Config Map Antes de colocar na scene
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        

        [scene.cropNode addChild:presao];
        [scene.cropNode addChild:porta];
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(18, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel05ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map5.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(13, 18)] withSize:tiledMap.tileSize];
        
        
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        
        JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(6, 10)] withSize:tiledMap.tileSize];
        fogo.dano=10;
        
        [fogo activateIa];
        fogo.activeFix=YES;
        
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y-100)]];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
        
        fogo.arrPointsPath = paths;
        
        
        [scene.inimigos addObject:fogo];

        
        JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(4, 2)] withTipo:1 withSize:tiledMap.tileSize];
        
        
        
        
        SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
        
        
        JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(10, 6)] withSprite:spritePor withTipo:1];
        
        [porta vincularBotao:presao];
        
        [scene.level.botoes addObject:presao];
        
        scene.portas=[[NSMutableArray alloc] init];
        
        [scene.portas addObject:porta];


        
        
        //Add objetos
        
        
        
        [scene.cropNode addChild:fogo];
        
        [scene.cropNode addChild:presao];
        [scene.cropNode addChild:porta];
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(17, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel06ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map6.tmx"];
    if (tiledMap){
        
    
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(9, 2)] withSize:tiledMap.tileSize];
        
        scene.portas=[[NSMutableArray alloc] init];

        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        
        JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(1, 2)] withTipo:1 withSize:tiledMap.tileSize];
        
        JAGPressao *presao2 = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(18, 1)] withTipo:1 withSize:tiledMap.tileSize];
        
        JAGPressao *presao3 = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(18, 18)] withTipo:3 withSize:tiledMap.tileSize];

        
         [scene.level.botoes addObject:presao];
        
         [scene.level.botoes addObject:presao2];
        
         [scene.level.botoes addObject:presao3];
        
        
        
        SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
        
        
        JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(9, 13)] withSprite:spritePor withTipo:1];
        
        [porta vincularBotao:presao];
        
        [porta vincularBotao:presao2];
        
        [porta vincularBotao:presao3];
        
        
        
        [scene.portas addObject:porta];
        
        
        SKSpriteNode *spritePor2 = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];

        
        JAGPorta *porta2 = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(10, 13)] withSprite:spritePor2 withTipo:1];
        
        
        [porta2 vincularBotao:presao];
        
        [porta2 vincularBotao:presao2];
        
        [porta2 vincularBotao:presao3];
        
        
        [scene.portas addObject:porta2];

        

        JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 13)] withSize:tiledMap.tileSize];
        fogo.dano=10;
        
       
        [fogo activateIa];
        
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x+150, fogo.position.y)]];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
        
        fogo.arrPointsPath = paths;
        
        
        [scene.inimigos addObject:fogo];

        
        
        //Add objetos
        
        [scene.cropNode addChild:presao];
        [scene.cropNode addChild:presao2];
        [scene.cropNode addChild:presao3];
        [scene.cropNode addChild:porta];
        [scene.cropNode addChild:porta2];
        
        [scene.cropNode addChild:fogo];
        
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(10, 16)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel07ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map7.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 18)] withSize:tiledMap.tileSize];
        
        
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(7, 1)] withSize:tiledMap.tileSize];
        fogo.dano=10;
        
        
        
        [scene.inimigos addObject:fogo];
        
        
        
        
        //Add objetos
        
        [scene.cropNode addChild:fogo];
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(18, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel08ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map8.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(1, 18)] withSize:tiledMap.tileSize];
        
        
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(15, 2)] withTipo:1 withSize:tiledMap.tileSize];
        
        JAGPressao *presao2 = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(18, 1)] withTipo:1 withSize:tiledMap.tileSize];
        
        JAGPressao *presao3 = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(18, 18)] withTipo:3 withSize:tiledMap.tileSize];
        
        
        [scene.level.botoes addObject:presao];
        
        [scene.level.botoes addObject:presao2];
        
        [scene.level.botoes addObject:presao3];
        
        
        
        SKSpriteNode *spritePor = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
        
        
        JAGPorta *porta = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(13, 14)] withSprite:spritePor withTipo:1];
        
        [porta vincularBotao:presao];
        
        [porta vincularBotao:presao2];
        
        [porta vincularBotao:presao3];
        
        
        
        [scene.portas addObject:porta];
        
        
        SKSpriteNode *spritePor2 = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(scene.level.tileSize, scene.level.tileSize)];
        
        
        JAGPorta *porta2 = [[JAGPorta alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(14, 14)] withSprite:spritePor2 withTipo:1];
        
        
        [porta2 vincularBotao:presao];
        
        [porta2 vincularBotao:presao2];
        
        [porta2 vincularBotao:presao3];
        
        
        [scene.portas addObject:porta2];
        
        
        
        JAGFogoEnemy *fogo = [[JAGFogoEnemy alloc] initWithPosition:[scene.level calculateTile:CGPointMake(14, 1)] withSize:tiledMap.tileSize];
        fogo.dano=10;
        
        fogo.visao=tiledMap.tileSize.width*2;
        
        [fogo activateIa];
        
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y+tiledMap.tileSize.height)]];
        [paths addObject:[NSValue valueWithCGPoint:CGPointMake(fogo.position.x, fogo.position.y)]];
        
        fogo.arrPointsPath = paths;
        
        
        [scene.inimigos addObject:fogo];
        
        
        
        //Add objetos
        
        [scene.cropNode addChild:presao];
        [scene.cropNode addChild:presao2];
        [scene.cropNode addChild:presao3];
        [scene.cropNode addChild:porta];
        [scene.cropNode addChild:porta2];
        
        [scene.cropNode addChild:fogo];

        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(13, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel09ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"mapTeste.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tiledMap.tileSize];
        
        
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        JAGPressao *presao = [[JAGPressao alloc] initWithPosition:[scene.level calculateTileHalf:CGPointMake(3, 3)] withTipo:1 withSize:tiledMap.tileSize];

        
        [scene.level.botoes addObject:presao];
        
        
        
        
        
        //Add objetos
        
        [scene.cropNode addChild:presao];
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(18, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}

+ (void)initializeLevel10ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //    JSTileMap *map;
    //    TMXLayer *tile;
    //    TMXLayer *bg;
    
    JSTileMap* tiledMap = [JSTileMap mapNamed:@"map10.tmx"];
    if (tiledMap){
        
        
        [JAGCreatorLevels configTileMap:scene withTtile:tiledMap];
        
        
        //Gotinha
        
        scene.gota = [[JAGGota alloc] initWithPosition:[scene.level calculateTile:CGPointMake(4, 3)] withSize:tiledMap.tileSize];
        
        
        
        
        //Config Map
        [JAGCreatorLevels configMap:scene withTtile:tiledMap];
        
        
        
        
        //Add objetos
        
        scene.level.chuva=[[JAGChuva alloc] initWithPosition:[scene.level calculateTile:CGPointMake(18, 18)] withSize:tiledMap.tileSize];
        
        [scene.cropNode addChild:scene.level.chuva];
        
        //Add Monstros
        
        
        
        //Portas
        
        
        
        //Config de hud e fase
        [JAGCreatorLevels configHud:scene];
        
    }
}






@end
