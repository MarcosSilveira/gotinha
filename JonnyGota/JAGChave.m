//
//  JAGChave.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 25/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGChave.h"
#import "JAGCharacter.h"
@implementation JAGChave

-(instancetype)initWithPosition:(CGPoint)ponto withSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    
    self.name=@"chave";
    
    [self configPhysicsBody];
    
    return self;
}
-(void)configPhysicsBody{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];//CGSizeMake(self.sprite.size.width, self.sprite.size.height) ];
    
    self.physicsBody.dynamic=YES;
    
    self.physicsBody.restitution=0.015;
    
    
    self.physicsBody.categoryBitMask = CHAVE;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;
    
}
@end
