//
//  JAGPerdaGota.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 27/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGPerdaGota : SKNode

@property (nonatomic) int valor;

@property (nonatomic) SKSpriteNode *sprite;

@property SKTextureAtlas *atlas;

@property (nonatomic) SKShapeNode* circleMask;

@property (nonatomic)SKEmitterNode *emitter;

-(instancetype)initWithPosition:(CGPoint)ponto
                   withTimeLife:(int)time
                       withSize:(int) tamanho;

-(void)destruir;

-(SKShapeNode *)areavisao:(int) raio;

@end
