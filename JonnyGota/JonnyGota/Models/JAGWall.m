//
//  JAGWall.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 13/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGWall.h"
#import "JAGCharacter.h"

@implementation JAGWall



-(id)init{
    self =[super init];
    
    return self;
}

-(instancetype)initWithSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    return self;
}

-(instancetype)initWithPosition:(CGPoint)ponto withSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];//CGSizeMake(self.sprite.size.width, self.sprite.size.height) ];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.restitution=0.015;
    
    self.physicsBody.usesPreciseCollisionDetection=NO;
    
    self.physicsBody.friction = 0;

    
    
    
    self.physicsBody.categoryBitMask = PAREDE;
    self.physicsBody.collisionBitMask = GOTA|ATTACK|ENEMY;
 
    return self;
}

-(NSMutableDictionary *)createJson{
    NSMutableDictionary *json=[[NSMutableDictionary alloc]init];
    
    NSNumber *temp=[[NSNumber alloc] initWithFloat:self.position.x];
    
    
    
    [json setObject:temp forKey:@"positionX"];
    
    temp=[[NSNumber alloc] initWithFloat:self.position.y];

    
    [json setObject:temp forKey:@"positionY"];
    
    [json setObject:_sprite.name forKey:@"sprite"];
    
    
    return json;
}


@end
