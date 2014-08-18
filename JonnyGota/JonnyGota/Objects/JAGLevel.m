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
    for (int i=0; i<altura&&i<_height; i++) {
                SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize-1, _tileSize-1)];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(ponto.x*_tileSize,_tileSize*(i+ponto.y)) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
       
        
        //Para o Json
       // [self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%lu",_paredes.count+1]];
    }
    
    for(int k=1;k<largura&&k<_width;k++){
        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize-1, _tileSize-1)];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(_tileSize*(k+ponto.x),ponto.y*_tileSize) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
        //Para o Json
        //[self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%d",k+1+altura]];
    }
}

-(CGPoint)calculateTile:(CGPoint)pontoMatriz{
    return CGPointMake(pontoMatriz.x*_tileSize,_tileSize*pontoMatriz.y);
}

-(CGSize)sizeTile{
    return CGSizeMake(_tileSize, _tileSize);
}

@end
