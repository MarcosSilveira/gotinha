//
//  JAGSparkRaio.h
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 03/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGSparkRaio : SKNode

@property (nonatomic)SKEmitterNode *emitter;

-(instancetype)initWithPosition:(CGPoint)ponto
                   withTimeLife:(int)time;

-(SKEmitterNode *)createEmitter:(CGPoint)ponto
                              withTimeLife:(int)time;

-(void)destruir;

-(void)destruir:(SKEmitterNode *)node;

@end
