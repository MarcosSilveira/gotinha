//
//  JAGPorta.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 20/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGPressao.h"

@interface JAGPorta : SKNode

//TIPO 1=Botao 2=Chave 3=Botao+Chave

@property (nonatomic) BOOL aberta;

@property (nonatomic) NSMutableArray *pressoes;

@property (nonatomic)SKSpriteNode *sprite;

@property (nonatomic)int tipo;

@property (nonatomic) int direction;

@property (nonatomic) BOOL reverse;


-(instancetype)initWithPosition:(CGPoint) ponto
                  withDirection:(int)direction
                    withReverse:(BOOL) reverse
                       withTipo:(int) tipo
                       withSize:(CGSize) size;

-(void)abrir:(BOOL)aberto;

-(BOOL)passar;

-(void)vincularBotao:(JAGPressao *)botao;

-(void)verificarBotoes;

@end
