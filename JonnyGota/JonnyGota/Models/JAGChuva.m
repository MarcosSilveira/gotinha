//
//  JAGChuva.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGChuva.h"
#import "JAGCharacter.h"

@implementation JAGChuva

-(instancetype)initWithPosition:(CGPoint)ponto{
    self=[super init];
    
    self.sprite=[[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(32, 32)];
    
    self.name=@"chuva";
    
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = CHUVA;
    self.physicsBody.collisionBitMask = GOTA ;
    self.physicsBody.contactTestBitMask = GOTA;

    
    [self addChild:self.sprite];
    
    self.physicsBody.dynamic=NO;
    
    self.position=ponto;
    
    self.physicsBody.restitution=0;
    
    return self;
}

@end
