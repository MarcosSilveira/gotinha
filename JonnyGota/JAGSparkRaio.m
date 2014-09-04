//
//  JAGSparkRaio.m
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 03/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGSparkRaio.h"

@implementation JAGSparkRaio

-(instancetype)initWithPosition:(CGPoint)ponto withTimeLife:(int)time {
    
    self = [super init];
    
    _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Raio" ofType:@"sks"]];
    _emitter.position = ponto;
    _emitter.name = @"perdida_raio";
    _emitter.numParticlesToEmit = 50;
    
    self.name = @"perdida_raio";
    self.position = ponto;
    
    SKAction *destruir = [SKAction sequence:@[[SKAction waitForDuration:time],
                                            [SKAction runBlock:^{
        [self destruir];
        
    }]]];
    
    [self runAction:destruir];
    
    return self;
}

-(void)destruir {
    [_emitter removeFromParent];
    [self removeFromParent];
}

@end
