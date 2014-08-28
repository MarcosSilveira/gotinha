//
//  JAGAttack.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 28/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGAttack : SKNode

@property SKSpriteNode *sprite;

@property (nonatomic) int dano;

-(instancetype)initWithPosition:(CGPoint) ponto
                    withImpulse:(CGVector) impulse
                       withDano:(int) dano
                     withSprite:(SKSpriteNode *)imagem;



@end
