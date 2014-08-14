//
//  JAGGota.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"

@interface JAGGota : JAGCharacter

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGest;
@property BOOL *escondida;
@property BOOL *dividida;
-(void)dividir;
-(void)esconder;

//-(void)mover:(CGPoint)ponto
//withInterval:(NSTimeInterval) time
//    withTipe:(int) tipo;

-(id)initWithPosition:(CGPoint) position;
-(BOOL)verificaToque:(CGPoint) ponto;

@end
