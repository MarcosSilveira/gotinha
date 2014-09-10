//
//  JAGPerdaGota.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 27/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPerdaGota.h"
#import "JAGCharacter.h"

@implementation JAGPerdaGota

-(instancetype)initWithPosition:(CGPoint)ponto withTimeLife:(int)time{
    self = [super init];
    
    _emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Vapor" ofType:@"sks"]];
    _emitter.position = ponto;
    _emitter.name = @"perdida";

    _emitter.numParticlesToEmit = 1000;

    
    self.name = @"perdida";
    
    
    self.position = ponto;
    
    
    SKAction *destruir=[SKAction sequence:@[[SKAction waitForDuration:time],
                                            [SKAction runBlock:^{
        [self destruir];
        
    }]]];
    
   // NSLog(@"Minha position x: %f  y: %f",self.position.x,self.position.y);
    
    [self runAction:destruir];
    
    return self;
}

-(SKShapeNode*)areavisao:(int)raio{
    
    _circleMask = [[SKShapeNode alloc ]init];
    
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, 1, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    
    _circleMask.path = circle;
    _circleMask.lineWidth = raio*2; // replace 100 with DOUBLE the desired radius of the circle
    _circleMask.name = @"circleMask";
    _circleMask.userInteractionEnabled = NO;
    _circleMask.position=self.position;

    //NSLog(@"cir x: %f  y: %f",self.position.x,self.position.y);
    return _circleMask;
}

-(void)destruir{
    [_circleMask removeFromParent];
    [_emitter removeFromParent];
    [self removeFromParent];

}

@end
