//
//  JAGLevel.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGLevel.h"
#import "JAGPlayGameScene.h"

@implementation JAGLevel

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




-(instancetype)initWithHeight:(int)height withWidth:(int)width{
    self=[super init];
    
    
    _width=width;
    
    _height=height;
    
    _tileSize=32;
    
    _inimigos=[[NSMutableDictionary alloc] init];
    
    _paredes=[[NSMutableDictionary alloc] init];
    
    _itens=[[NSMutableDictionary alloc] init];
    
    return self;
}


-(NSString *)exportar{
    
    NSMutableDictionary *jsonFinal=[[NSMutableDictionary alloc] init];
    
    NSNumber *temp=[[NSNumber alloc] initWithFloat:self.width];
    
    [jsonFinal setObject:temp forKey:@"width"];
    
    temp=[[NSNumber alloc] initWithFloat:self.height];
    
    [jsonFinal setObject:temp forKey:@"height"];
    
    [jsonFinal setObject:_mundo forKey:@"mundo"];
    
    [jsonFinal setObject:_level forKey:@"level"];
    
    temp=[[NSNumber alloc] initWithFloat:self.inimigos.count];
    
    [jsonFinal setObject:temp forKey:@"inimigos"];

    temp=[[NSNumber alloc] initWithFloat:self.paredes.count];
    
    [jsonFinal setObject:temp forKey:@"paredes"];

    temp=[[NSNumber alloc] initWithFloat:self.itens.count];
    
    [jsonFinal setObject:temp forKey:@"itens"];

    
    
    //Salvar tileSize?
    
    /*
    temp=[[NSNumber alloc] initWithFloat:self.tileSize];
    
    [jsonFinal setObject:temp forKey:@"tileSize"];
     */
    
    
    [jsonFinal setObject:[_gota createJson] forKey:@"gota"];


    
    NSArray *chaves=[_paredes allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGWall *temps=[_paredes objectForKey:chaves[i]];
        //NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
        //NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        [jsonFinal setObject:[temps createJson] forKey:chaves[i]];
        
    }
    
    /*
    chaves=[_itens allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGWall *temps=[_itens objectForKey:chaves[i]];
        NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
        NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        [jsonFinal setObject:json2 forKey:chaves[i]];
    }
    
    */
    
    
    chaves=[_inimigos allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGInimigos *temps=[_inimigos objectForKey:chaves[i]];
        //NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
        // NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        //[jsonFinal setObject:json2 forKey:chaves[i]];
        
        [jsonFinal setObject:[temps createJson] forKey:chaves[i]];
    }
    

    
    NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:jsonFinal options:kNilOptions error:nil];
    NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"level.txt"];
    
    NSError *err;
    
    BOOL ok = [json2 writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@",
              filePath, [err localizedFailureReason]);
    }

    return json2;
   // NSLog(@"\n\n%@",json2);
}

-(void)createWalls:(CGPoint)ponto withHeight:(int)altura withWidth:(int)largura withScene:(JAGPlayGameScene *)scene{
    
    //wallSpri.name=@"brownColor";

    
    JAGWall *wall;
    for (int i=0; i<altura; i++) {
                SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize, _tileSize)];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(ponto.x*_tileSize,_tileSize*(i+ponto.y)) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
       
        
        //Para o Json
       // [self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%lu",_paredes.count+1]];
    }
    
    for(int k=1;k<largura;k++){
        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize, _tileSize)];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(_tileSize*(k+ponto.x),ponto.y*_tileSize) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
        //Para o Json
        //[self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%d",k+1+altura]];
    }
}


+ (void)initializeLevel01ofWorld01onScene:(JAGPlayGameScene *)scene
{
    //[self configure:scene withBackgroundColor:[UIColor whiteColor]];
    
    scene.gota= [[JAGGota alloc] initWithPosition:CGPointMake(100, 100)];
    scene.fogo = [[JAGFogoEnemy alloc] initWithPosition:CGPointMake(200, 100)];
    
    //_tileSize=32;
    //scene.diferenca = 80.0f;
    //tocou = false;
    
    scene.cropNode = [[SKCropNode alloc] init];
    
    scene.level=[[JAGLevel alloc] initWithHeight:30 withWidth:30];
    
    scene.level.tileSize=32;
    
    //[scene.cropNode addChild:scene.gota];
    
    [scene createMask:100 withPoint:(scene.gota.position)];
    
    [scene.cropNode addChild:scene.gota];
    
    [scene.level createWalls:CGPointMake(1, 1) withHeight:10 withWidth:2 withScene:scene];
    
    [scene.level createWalls:CGPointMake(4, 4) withHeight:10 withWidth:3 withScene:scene];

    
    [scene.cropNode addChild:scene.fogo];
    
    [scene addChild: scene.cropNode];
    
    
    
    
   // self createWalls:<#(CGPoint)#> withHeight:<#(int)#> withWidth:<#(int)#>
}


@end
