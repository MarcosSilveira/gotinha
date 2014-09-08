//
//  JAGHud.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "JAGGota.h"


@interface JAGHud : SKNode

@property (nonatomic) int tempoRestante;
@property (nonatomic) int vidaRestante;
@property (nonatomic) float saudeRestante;


@property (nonatomic) SKLabelNode *vidas;

@property (nonatomic) SKLabelNode *tempo;

@property (nonatomic) SKLabelNode *saude;

@property (nonatomic) JAGGota *gota;

@property (nonatomic) SKSpriteNode *pauseBT;


//Sprites da tela
@property (nonatomic) SKSpriteNode* sprite;

-(instancetype)initWithTempo:(int) tempo
                    withVida:(int) vida
                       saude:(float)saude
              withWindowSize:(CGSize) size;

-(void)update;

-(void)startTimer;

@end
