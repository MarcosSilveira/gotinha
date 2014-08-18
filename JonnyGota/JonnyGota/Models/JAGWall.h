//
//  JAGWall.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 13/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGWall : SKNode

/*typedef enum : uint32_t{
    GOTA = 0x1 << 0,
    ENEMY = 0x1 << 1,
    ATTACK = 0x1 << 2,
    WALL=0x1<<3
}colisao;
*/
@property (nonatomic) SKSpriteNode *sprite;

-(instancetype)initWithSprite:(SKSpriteNode *) imagem;

-(instancetype)initWithPosition:(CGPoint) ponto
                     withSprite:(SKSpriteNode *) imagem;

-(NSMutableDictionary*)createJson;

@end
