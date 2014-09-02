//
//  JAGTrap.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 02/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGCharacter.h"
/*
    PARA TIPO
 0 para armadinha do tipo perda de agua
 1 para armadilha de redução de velocidade
 2 para armadilha que tranca a gota no local
 
 */

@interface JAGTrap : SKNode

@property (nonatomic) int tipo;

@property (nonatomic) SKSpriteNode *sprite;

-(instancetype)initWithPosition:(CGPoint) ponto
                     withSprite:(SKSpriteNode *) imagem;

-(void)capturouAGota:(JAGCharacter *)gota;
@end
