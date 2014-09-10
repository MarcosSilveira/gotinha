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
    int multiAux = gota.multi;
    _newVelocity = gota.multi/2;
    _fastVelocity = gota.multi*2;
    
    if (_tipo==0){
//        gota.vida = gota.vida - 5;
    }
    else if(_tipo==1){

        SKAction *diminuirVelocidade=[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                     [SKAction runBlock:^{
            gota.multi = _newVelocity;
            
            SKAction *recuperarVelocidade=[SKAction sequence:@[[SKAction waitForDuration:10],
                                                    [SKAction runBlock:^{
                gota.multi = multiAux;
                
            }]]];
            
            [self runAction:recuperarVelocidade];
            
        }]]];
        [self runAction:diminuirVelocidade];
    }
    else if(_tipo==2){
        
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
    
    else if (_tipo==3){
        SKAction *acelerar=[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                          [SKAction runBlock:^{
            gota.multi = _fastVelocity;
            
            SKAction *recuperarVelocidade=[SKAction sequence:@[[SKAction waitForDuration:10],
                                                               [SKAction runBlock:^{
                gota.multi = multiAux;
                
            }]]];
            
            [self runAction:recuperarVelocidade];
            
        }]]];
        [self runAction:acelerar];

    }
}

@end
