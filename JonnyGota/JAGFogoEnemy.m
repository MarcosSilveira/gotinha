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
    self.sprite.texture = [self.atlas textureNamed:@"fogo_idle.png"];
    self.idleTexture = [self.atlas textureNamed:@"fogo_idle.png"];
    
    for (int i=1; i<=8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"fogo_correndo_lado%d@2x.png", i];
        [self.walkTexturesFront addObject:[self.atlas textureNamed:textureName]];
    }

    //physics config
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    self.physicsBody.categoryBitMask = ENEMY;
    self.physicsBody.collisionBitMask = GOTA|PORTA|PAREDE;
    self.physicsBody.contactTestBitMask = GOTA;
    self.physicsBody.restitution=0.0;
    self.physicsBody.usesPreciseCollisionDetection=NO;
    [self configPhysics];

    self.multi = 3;
    self.name=@"fogo";
    [self addChild:self.sprite];
    self.position = position;
    return self;
}

-(void)ataque {
    
}

-(void)mover:(CGPoint)ponto withInterval:(NSTimeInterval)time withTipe:(int)tipo{
    self.physicsBody.velocity=CGVectorMake(0, 0);
    
    switch (tipo) {
        case 1:
            
            //self.physicsBody.velocity=CGVectorMake(ponto.x, ponto.y);
            
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y - self.position.y)*self.multi)];
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingSide"];
            //  action = [SKAction followPath:(CGPathCreateWithRect(CGRectMake(ponto.x, ponto.y, 10, 10), nil)) duration:2];
            //self.sprite.color=[UIColor greenColor];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
            // self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
            break;
            
        case 2:
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingSide"];
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y - self.position.y)*self.multi)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:1.0 duration:0.0];
            
            //self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            break;
            
        case 3:
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingSide"];
            [self.physicsBody applyForce:CGVectorMake((ponto.x - self.position.x)*self.multi,0)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:0.0];
            break;
            
        case 4:
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingSide"];
            [self.physicsBody applyForce:CGVectorMake((ponto.x - self.position.x)*self.multi,0)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1.0 duration:0.0];
            
            break;
            
        default:
            break;
    }
}

@end
