//
//  JAGMyScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMyScene.h"
#import "JAGCharacter.h"
#import "JAGLevel.h"

@implementation JAGMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        JAGLevel *level1=[[JAGLevel alloc] initWithHeight:20 withWidth:20];
        
         CGSize tamanho=CGSizeMake(level1.tileSize, level1.tileSize);
        
        level1.gota=[[JAGGota alloc] initWithPosition:CGPointMake(level1.tileSize*2, level1.tileSize*2) withSize:tamanho];
        
        SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(level1.tileSize, level1.tileSize)];
        
        JAGWall *parede=[[JAGWall alloc] initWithSprite:wallSpri];
                                
        parede.position=CGPointMake(level1.tileSize*1, level1.tileSize*1);
                                
        [level1.paredes setValue:parede forKey:@"parede1"];
                                
    
        JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake(level1.tileSize*4, level1.tileSize*4) withSize:tamanho];
        
        [level1.inimigos setValue:inimigo forKey:@"inimigo1"];
        
        [level1 exportar];
    }
    return self;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
