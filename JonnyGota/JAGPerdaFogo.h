//
//  JAGPerdaFogo.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 29/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGPerdaFogo : SKNode

@property (nonatomic)SKEmitterNode *emitter;

-(instancetype)initWithPosition:(CGPoint)ponto
                   withTimeLife:(int)time;

-(void)destruir;

@end
