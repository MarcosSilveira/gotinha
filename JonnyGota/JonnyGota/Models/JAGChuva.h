//
//  JAGChuva.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Musica.h"
#import "JAGGota.h"


@interface JAGChuva : SKNode

@property (nonatomic) SKSpriteNode *sprite;
@property (strong, nonatomic) SKTexture *nuvemText;

@property (nonatomic) Musica *chuva;

-(instancetype)initWithPosition:(CGPoint) ponto;

-(void)update:(JAGGota *)gota;

@end
