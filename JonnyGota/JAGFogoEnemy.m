//
//  JAGFogoEnemy.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGFogoEnemy.h"

@implementation JAGFogoEnemy

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    self = [super init];
    
    //texture config
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"enemies.atlas"];
    self.sprite.texture = [SKTexture textureWithImageNamed:@"fogo_parado.png"];
    self.idleTexture =  [SKTexture textureWithImageNamed:@"fogo_parado.png"];
    
    for (int i=1; i<=8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"fogo_correndo_lado%d@2x.png", i];
        [self.walkTexturesSide addObject:[self.atlas textureNamed:textureName]];
        [self.walkTexturesBack addObject:[self.atlas textureNamed:textureName]];
        [self.walkTexturesFront addObject:[self.atlas textureNamed:textureName]];
    }



    //physics config
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.sprite.texture.size.width/2, self.sprite.texture.size.height/2)];
    self.physicsBody.categoryBitMask = ENEMY;
    self.physicsBody.collisionBitMask = GOTA|PORTA|PAREDE;
    self.physicsBody.contactTestBitMask = GOTA;
    self.physicsBody.restitution=0.0;
    self.physicsBody.usesPreciseCollisionDetection=NO;
    [self configPhysics];

    self.multi = size.width/8;
    self.name=@"fogo";
    [self addChild:self.sprite];
    self.position = position;
    return self;
}

-(void)ataque {
    
}


@end
