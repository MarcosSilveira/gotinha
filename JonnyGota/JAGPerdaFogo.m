//
//  JAGPerdaFogo.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 29/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPerdaFogo.h"

@implementation JAGPerdaFogo

-(instancetype)initWithPosition:(CGPoint)ponto withTimeLife:(int)time{
    self = [super init];
    
    _emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Fogo" ofType:@"sks"]];
    _emitter.position = ponto;
    _emitter.name = @"perdida_fogo";
    
    _emitter.numParticlesToEmit = 1000;
    
    
    self.name = @"perdida_fogo";
    
    
    self.position = ponto;
    
    
    SKAction *destruir=[SKAction sequence:@[[SKAction waitForDuration:time],
                                            [SKAction runBlock:^{
        [self destruir];
        
    }]]];
    
    NSLog(@"Minha position x: %f  y: %f",self.position.x,self.position.y);
    
    [self runAction:destruir];
    
    return self;
}
-(void)destruir{
    [_emitter removeFromParent];
    [self removeFromParent];
    
}

@end
