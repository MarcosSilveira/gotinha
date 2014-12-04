//
//  JAGObjeto.h
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGPlayGameScene.h"



@interface JAGObjeto : SKNode

@property (nonatomic) int tipo;

@property (strong, nonatomic) SKSpriteNode *sprite;

-(void) criarObj:(CGPoint)posi comTipo:(NSInteger)tipo eSprite:(SKSpriteNode *) sprite;
-(void) habilidade:(JAGPlayGameScene *)scene;

@end
