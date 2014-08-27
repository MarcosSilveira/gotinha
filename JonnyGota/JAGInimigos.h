//
//  JAGInimigos.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"

@interface JAGInimigos : JAGCharacter

@property (nonatomic) int visao;
@property (nonatomic) int tipo;
@property int multi;

@property (nonatomic) int dano;

-(void)ataque;

@end
