//
//  JAGFogoEnemy.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGFogoEnemy.h"

@implementation JAGFogoEnemy

-(id)initWithPosition:(CGPoint)position{
    self=[super init];
    
    SKSpriteNode *desn=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
    self.sprite=desn;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = ENEMY;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;
//    self.physicsBody.mass = 9000;
    //    desn.position=position;
    
    //[self addChild:desn];
    
    
    
    [self configPhysics];
    [self addChild:self.sprite];
    
    self.position=position;
    
    return self;
}

-(void)ataque{
    
    
}

-(BOOL)tocou:(CGPoint)ponto{
    BOOL toque;
    
    return toque;
    
}



@end
