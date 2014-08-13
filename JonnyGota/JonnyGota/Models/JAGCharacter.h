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
 ATTACK = 0x1 << 2
}colisao;

@interface JAGCharacter : SKNode <UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger* vida;
@property (nonatomic) SKSpriteNode* sprite;

-(void)configPhysics;

-(void)animar;


-(void)mover;

-(NSMutableDictionary*)createJson;

@end
