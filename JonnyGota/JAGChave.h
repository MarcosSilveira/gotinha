//
//  JAGChave.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 25/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGChave : SKNode

@property (nonatomic)SKSpriteNode *sprite;
-(instancetype)initWithPosition:(CGPoint) ponto
                     withSprite:(SKSpriteNode *) imagem;
@end
