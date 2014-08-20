//
//  JAGPressao.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 20/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPressao.h"
#import "JAGCharacter.h"

@implementation JAGPressao

-(instancetype)initWithPosition:(CGPoint)ponto{
    self=[super init];
    
    _sprite=[[SKSpriteNode alloc] initWithColor:[SKColor cyanColor] size:CGSizeMake(32,32)];
    
    self.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.categoryBitMask = PRESSAO;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;

    self.name=@"pressao";
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    _presionado=FALSE;
    
    return self;
}



-(void)pisar{
    SKAction *actionChangeSprite;
    
    if(!_presionado){
        _presionado=true;
        actionChangeSprite = [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
        
        }else{
        _presionado=false;
        actionChangeSprite = [SKAction colorizeWithColor:[SKColor cyanColor] colorBlendFactor:1.0 duration:0.0];
        
    }
    [self.sprite runAction:actionChangeSprite];
}

@end
