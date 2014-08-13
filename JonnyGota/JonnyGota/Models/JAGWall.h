//
//  JAGWall.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 13/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGWall : SKNode

@property (nonatomic) SKSpriteNode *sprite;

-(instancetype)initWithSprite:(SKSpriteNode *) imagem;

@end
