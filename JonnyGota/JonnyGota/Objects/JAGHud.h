//
//  JAGHud.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface JAGHud : SKNode

@property (nonatomic) int tempoRestante;
@property (nonatomic) int vidaRestante;

@property (nonatomic) SKLabelNode *vidas;

@property (nonatomic) SKLabelNode *tempo;

@property (nonatomic) SKLabelNode *saude;



//Sprites da tela
@property (nonatomic) SKSpriteNode* sprite;

-(instancetype)initWithTempo:(int) tempo
                    withVida:(int) vida
              withWindowSize:(CGSize) size;

-(void)update;

-(void)startTimer;

@end
