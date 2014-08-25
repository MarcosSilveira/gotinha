//
//  JAGGotaDividida.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 21/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGotaDividida.h"

@implementation JAGGotaDividida

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    self = [super init];
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    
    self.physicsBody.friction = 0;
    
    //    desn.position=position;
    
    //[self addChild:desn];
    
    self.name=@"gotaDividida";
    
    self.sprite.name=@"gotaDividida";
    
    [self addChild:self.sprite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY |ITEM |PORTA;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY | CONTROLE_TOQUE |ITEM;
    
    [self configPhysics];
    
    self.position = position;
    
    self.sprite.zPosition=100;
    
    self.zPosition=100;
    
    return self;

}

@end
