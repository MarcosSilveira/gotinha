//
//  JAGPressao.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 20/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGWall.h"
#import "JAGCharacter.h"

@interface JAGPressao : SKNode

@property (nonatomic) BOOL pressionado;

@property (nonatomic) SKSpriteNode *sprite;

@property (nonatomic) JAGWall *porta;

@property (nonatomic) int tipo;

-(void)criarParede:(SKSpriteNode*)sprite withPosition:(CGPoint)ponto;

-(void)pisar;

-(instancetype)initWithPosition:(CGPoint)ponto withTipo:(int)tipo;

-(BOOL)pisado:(NSMutableArray *)personagens;

-(void)pressionar:(BOOL)pressao;

@end
