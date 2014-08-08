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

-(void)mover:(CGPoint)ponto
withInterval:(NSTimeInterval) time
    withTipe:(int) tipo;

-(id)initWithPosition:(CGPoint) position;

-(BOOL)tocou:(CGPoint) ponto;
@end
