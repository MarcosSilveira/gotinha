//
//  JAGTrovaoEnemy.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGTrovaoEnemy.h"

@implementation JAGTrovaoEnemy

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    self = [super init];
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"gotinha.atlas"];
    self.sprite.texture = [self.atlas textureNamed:@"fire_idle.png"];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = ENEMY;
    self.physicsBody.collisionBitMask = GOTA|PORTA|PAREDE;
    self.physicsBody.contactTestBitMask = GOTA|PRESSAO;
    //    self.physicsBody.mass = 9000;
    //    desn.position = position;
    
    //[self addChild:desn];
    
    self.multi = 40;
    
    [self configPhysics];
    [self addChild:self.sprite];
    
    self.visaoRanged=150;
    
    self.position = position;
    
    self.delayAttack=5;
    
    return self;
}

-(void)ataque{
    
    
}


-(JAGAttack *)createAttackRanged: (CGVector)withImpulse{
    SKSpriteNode *trovao=[[SKSpriteNode alloc] initWithColor:[UIColor yellowColor] size:CGSizeMake(15, 15)];
    JAGAttack *attack=[[JAGAttack alloc] initWithPosition:self.position withImpulse:withImpulse withDano:3 withSprite:trovao];
    
    return attack;
}

-(BOOL)tocou:(CGPoint)ponto{
    BOOL toque;
    
    return toque;
    
}

-(void)mover:(CGPoint)ponto withInterval:(NSTimeInterval)time withTipe:(int)tipo{
    self.physicsBody.velocity=CGVectorMake(0, 0);
    
    switch (tipo) {
        case 1:
            
            //self.physicsBody.velocity=CGVectorMake(ponto.x, ponto.y);
            
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y - self.position.y)*self.multi)];
            
            //  action = [SKAction followPath:(CGPathCreateWithRect(CGRectMake(ponto.x, ponto.y, 10, 10), nil)) duration:2];
            //self.sprite.color=[UIColor greenColor];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
            // self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
            break;
            
        case 2:
            
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y - self.position.y)*self.multi)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:1.0 duration:0.0];
            
            //self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            break;
            
        case 3:
            
            [self.physicsBody applyForce:CGVectorMake((ponto.x - self.position.x)*self.multi,0)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:0.0];
            break;
            
        case 4:
            [self.physicsBody applyForce:CGVectorMake((ponto.x - self.position.x)*self.multi,0)];
            
            //            actionChangeSprite=[SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1.0 duration:0.0];
            
            break;
            
        default:
            break;
    }
}


@end
