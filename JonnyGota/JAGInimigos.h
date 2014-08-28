//
//  JAGInimigos.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"
#import "JAGGota.h"

@interface JAGInimigos : JAGCharacter

//Path definido por pontos; ao chegar no ponto, ESPERAR a ACTION e trocar para outro ponto de movimento;

@property int multi;
@property (nonatomic) int visao;
@property (nonatomic) int tipo;
@property (strong, nonatomic) SKAction *movePath;
@property (strong, nonatomic) NSMutableArray *arrPoints;

@property (nonatomic) int dano;

-(void)ataque;
-(void)IAcomInfo:(JAGGota *) jogador;
-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto;

@end
