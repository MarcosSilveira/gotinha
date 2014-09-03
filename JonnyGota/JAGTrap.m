//
//  JAGTrap.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 02/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGTrap.h"

@implementation JAGTrap

-(instancetype)initWithPosition:(CGPoint)ponto withSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.restitution=0.015;
    
    self.physicsBody.friction = 0;
    
    self.physicsBody.categoryBitMask = TRAP;
    self.physicsBody.contactTestBitMask = GOTA;
    
    return self;
}

-(void)capturouAGota:(JAGCharacter *)gota{
    if (_tipo==0){
//        gota.vida = gota.vida - 5;
    }
    else if(_tipo==1){
        
        SKAction *diminuirVelocidade=[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                     [SKAction runBlock:^{
            gota.multi = gota.multi/2;
            
            SKAction *recuperarVelocidade=[SKAction sequence:@[[SKAction waitForDuration:10],
                                                    [SKAction runBlock:^{
                gota.multi = gota.multi*2;
                
            }]]];
            
            [self runAction:recuperarVelocidade];
            
        }]]];
        [self runAction:diminuirVelocidade];
    }
    else if(_tipo==2){
        int multiAux = gota.multi;
        SKAction *diminuirVelocidade=[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                          [SKAction runBlock:^{
            gota.multi = 0;
            
            SKAction *recuperarVelocidade=[SKAction sequence:@[[SKAction waitForDuration:10],
                                                               [SKAction runBlock:^{
                gota.multi = multiAux;
                
            }]]];
            
            [self runAction:recuperarVelocidade];
            
        }]]];
        [self runAction:diminuirVelocidade];
    }
}

@end
