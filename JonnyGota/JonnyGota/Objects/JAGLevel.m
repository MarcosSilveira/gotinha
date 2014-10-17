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
    
    _botoes=[[NSMutableArray alloc] init];
    
    [self loadtile];
    
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
//        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize-1, _tileSize-1)];
        
        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithTexture:[self loadingSprite:i withHeight:altura isCima:YES]];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(ponto.x*_tileSize,_tileSize*(i+ponto.y)) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
        
       
        
        //Para o Json
       // [self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%lu",_paredes.count+1]];
    }
    
    for(int k=1;k<largura&&k<_width;k++){
//        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_tileSize-1, _tileSize-1)];
        
        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithTexture:[self loadingSprite:k withHeight:largura isCima:NO]];

        wall=[[JAGWall alloc] initWithPosition:CGPointMake(_tileSize*(k+ponto.x),ponto.y*_tileSize) withSprite:wallSpri];
        [scene.cropNode addChild:wall];
        
        //Para o Json
        //[self.paredes setValue:wall forKey:[NSString stringWithFormat:@"parede%d",k+1+altura]];
    }
}

-(CGPoint)calculateTile:(CGPoint)pontoMatriz{
    return CGPointMake(pontoMatriz.x*_tileSize,_tileSize*pontoMatriz.y);
}

-(CGPoint)calculateTileHalf:(CGPoint)pontoMatriz{
    return CGPointMake(pontoMatriz.x*_tileSize+_tileSize/2,(_tileSize*pontoMatriz.y)+_tileSize/2);
}

-(CGSize)sizeTile{
    return CGSizeMake(_tileSize, _tileSize);
}

-(SKTexture *)loadingSprite:(int)tile
                   withHeight:(int)tamanho
                       isCima:(BOOL) cima{
    
    
    
    SKTexture *img=[[SKTexture alloc] init];
    
    CGFloat xFinal, yFinal;
    
    xFinal =  _tilefull.size.width/64;
    yFinal =  _tilefull.size.height/64;

    
   // img=[SKTexture textureWithRect:CGRectMake(self.tileSize*0, self.tileSize*3, self.tileSize, self.tileSize) inTexture:_tilefull];
//    return img;
    
    if(tile==tamanho){
        tile=2;
    }
    
    if(tile>0 && tile<tamanho){
        tile=1;
    }
    
    if(cima){
        if(tile==0){
            NSLog(@"%d",self.tileSize);
//            img=[SKTexture textureWithRect:CGRectMake(self.tileSize*1, self.tileSize*3, self.tileSize, self.tileSize) inTexture:_tilefull];
            //[_tilefull textureRect];
            
//            img=[SKTexture textureWithRect:CGRectMake(self.tileSize*1, self.tileSize*3, self.tileSize, self.tileSize) inTexture:img];
            //img.size=CGSizeMake(self.tileSize, self.tileSize);
            
            
            
         //   NSLog(@"finals x:%f  y:%f  width: %f",xFinal ,yFinal,_tilefull.size.width);
            
            img=[SKTexture textureWithRect:CGRectMake(0,0.25,0.335, 0.25) inTexture:_tilefull];
         //   NSLog(@"img: %@",img);
            
            return img;
        }
        if(tile==1){
            img=[SKTexture textureWithRect:CGRectMake(0.25,0.25,0.335, 0.25) inTexture:_tilefull];
            return img;
        }
        
        img=[SKTexture textureWithRect:CGRectMake(1,0.25,0.335, 0.25) inTexture:_tilefull];
        return img;
    }else{
        if(tile==0){
            img=[SKTexture textureWithRect:CGRectMake(0.25,0.25,0.335, 0.25) inTexture:_tilefull];
            return img;

        }
        if(tile==1){
            img=[SKTexture textureWithRect:CGRectMake(0,0.25,0.335, 0.25) inTexture:_tilefull];
            return img;
        }
        if(tile==2){
            
        }
    }
    
    
    return img;
}

-(void)buildTileTextureAtlas {
    int numFormats = 3;
    NSMutableArray *tileImages = [NSMutableArray array];
    SKTextureAtlas *tileAtlas = [SKTextureAtlas atlasNamed:@"tilesset"];
    int numImages = tileAtlas.textureNames.count;
    for (int i = 1; i <= numImages/numFormats; i++) {
        NSString *textureName = [NSString stringWithFormat:@"tile%d", i];
        SKTexture *temp = [tileAtlas textureNamed:textureName];
        [tileImages addObject:temp];
    }
    _tilesFromAtlas = tileImages;
}

-(void)loadtile{
//    SKTextureAtlas *tileAtlas = [SKTextureAtlas atlasNamed:@"tilesset"];
//    _tilefull=[tileAtlas textureNamed:@"tileSheet.png"];
    
    _tilefull=[SKTexture textureWithImageNamed:@"tileSheet"];
}


@end
