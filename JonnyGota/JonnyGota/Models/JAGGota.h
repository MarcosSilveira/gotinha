//
//  JAGGota.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"
#import "JAGGotaDividida.h"

@interface JAGGota : JAGCharacter

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGest;
@property BOOL escondida;
@property BOOL dividida;
@property BOOL comChave;
@property BOOL emContatoFonte;
@property float aguaRestante;
-(SKSpriteNode*)dividir;
-(void)esconder;

//-(void)mover:(CGPoint)ponto
//withInterval:(NSTimeInterval) time
//    withTipe:(int) tipo;

-(id)initWithPosition:(CGPoint) position
             withSize:(CGSize) size;
-(BOOL)verificaToque:(CGPoint) ponto;

@end
