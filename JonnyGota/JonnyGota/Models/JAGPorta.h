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

@property (nonatomic) BOOL aberta;

@property (nonatomic) NSMutableArray *pressoes;

@property (nonatomic)SKSpriteNode *sprite;

-(instancetype)initWithPosition:(CGPoint) ponto
                     withSprite:(SKSpriteNode *) imagem;

-(void)abrir:(BOOL)aberto;

-(BOOL)passar;

-(void)vincularBotao:(JAGPressao *)botao;

-(void)verificarBotoes;

@end
