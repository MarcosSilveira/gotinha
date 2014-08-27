//
//  JAGFonte.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 26/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGFonte : SKNode
@property SKSpriteNode *sprite;
@property float aguaRestante;
-(instancetype)initWithPosition:(CGPoint) ponto
                     withSprite:(SKSpriteNode *) imagem;
@end
