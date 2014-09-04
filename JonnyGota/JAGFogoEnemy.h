//
//  JAGFogoEnemy.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGInimigos.h"

// Habilidade Especial: Ao caminhar, deixa rastro que queima, durante alguns segundos

@interface JAGFogoEnemy : JAGInimigos

@property (nonatomic)SKEmitterNode *emitter;

-(id)initWithPosition:(CGPoint) position withSize:(CGSize)size;

@end
