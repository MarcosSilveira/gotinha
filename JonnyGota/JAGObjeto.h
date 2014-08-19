//
//  JAGObjeto.h
//  JonnyGota
//
//  Created by Joao Pedro da Costa Nunes on 18/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint32_t { 
    CHAVE = 0x1 << 0,
    ITEM = 0x1 << 1,
    
} colisao;

@interface JAGObjeto : SKNode

@property (strong, nonatomic) SKSpriteNode *sprite;

-(void) criarObj:(CGPoint)posi comTipo:(NSInteger)tipo eSprite:(SKSpriteNode *) sprite;
-(void) habilidade:(NSInteger)tipo;

@end
