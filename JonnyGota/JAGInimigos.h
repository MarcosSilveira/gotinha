//
//  JAGInimigos.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"
#import "JAGGota.h"
#import "JAGAttack.h"

@interface JAGInimigos : JAGCharacter

//Path definido por pontos; ao chegar no ponto, ESPERAR a ACTION e trocar para outro ponto de movimento;

@property int multi;
@property (nonatomic) int visao;
@property (nonatomic) int visaoRanged;
@property (nonatomic) int tipo;
@property (strong, nonatomic) SKAction *movePath;
@property (strong, nonatomic) NSMutableArray *arrPointsPath;
@property (strong, nonatomic) NSMutableArray *arrPointsFixes;
@property (nonatomic) BOOL seguindo;
@property (nonatomic) BOOL andandoIa;

@property (nonatomic) int delayAttack;

@property (nonatomic) BOOL atacouRanged;

@property (nonatomic) int dano;

@property (nonatomic) int sentido;

@property int lastPointToGo;

-(void)ataque;
-(void)IAcomInfo;
-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto;

-(void)follow:(JAGGota *) jogador;


-(JAGAttack *)createAttackRanged: (CGVector)withImpulse;

-(JAGAttack *)attackRanged:(JAGGota *)jogador;

@end
