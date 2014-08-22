//
//  JAGGotaDividida.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 21/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"

@interface JAGGotaDividida : JAGCharacter

-(id)initWithPosition:(CGPoint) position
             withSize:(CGSize) size;
-(BOOL)verificaToque:(CGPoint) ponto;

@end
