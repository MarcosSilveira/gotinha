//
//  JAGAttack.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 28/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGAttack.h"
#import "JAGCharacter.h"

@implementation JAGAttack

-(instancetype)initWithPosition:(CGPoint)ponto withImpulse:(CGVector)impulse withDano:(int)dano withSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    self.sprite = imagem;
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = ATTACK;
    self.physicsBody.collisionBitMask = GOTA|PAREDE;
    self.physicsBody.contactTestBitMask = GOTA|PAREDE;
    
       //    self.physicsBody.mass = 9000;
    //    desn.position = position;
    
    //[self addChild:desn];
    self.physicsBody.velocity=impulse;
    
    
    [self addChild:self.sprite];
    
    self.position = ponto;
    
    self.dano=dano;
    
   // self.physicsBody.dynamic=NO;

    self.zPosition=100;
    
    self.name=@"attack";
    
    return self;
}

@end
