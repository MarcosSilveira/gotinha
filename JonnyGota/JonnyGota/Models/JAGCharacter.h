//
//  JAGCharacter.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint32_t{
 GOTA = 0x1 << 0,
 ENEMY = 0x1 << 1,
 ATTACK = 0x1 << 2,
 CONTROLE_TOQUE = 0x1 << 3,
 FONTE_DA_JUVENTUDE = 0x1 <<4,
 CHAVE = 0x1<<11,
 ITEM = 0x1 << 12,
 PRESSAO = 0x1 <<13,
 PORTA = 0x1<<14,
 CHUVA=0x1<<20
}colisao;

@interface JAGCharacter : SKNode <UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger* vida;
@property (nonatomic) SKSpriteNode* sprite;
@property int multi;

-(void)configPhysics;
-(void)animar;
-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withType:(int)tipo;
-(NSMutableDictionary*)createJson;

@end
