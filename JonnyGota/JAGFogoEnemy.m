//
//  JAGFogoEnemy.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGFogoEnemy.h"

@implementation JAGFogoEnemy

-(id)initWithPosition:(CGPoint)position{
    self=[super init];
    
    SKSpriteNode *desn=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
    self.sprite=desn;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = ENEMY;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;
//    self.physicsBody.mass = 9000;
    //    desn.position=position;
    
    //[self addChild:desn];
    
    
    
    [self configPhysics];
    [self addChild:self.sprite];
    
    self.position=position;
    
    return self;
}

-(void)ataque{
    
    
}

-(BOOL)tocou:(CGPoint)ponto{
    BOOL toque;
    
    return toque;
    
}

-(void)mover:(CGPoint)ponto withInterval:(NSTimeInterval)time withTipe:(int)tipo{
    self.physicsBody.velocity=CGVectorMake(0, 0);
    
    int multi=2;
    
    
    switch (tipo) {
        case 1:
            
            //self.physicsBody.velocity=CGVectorMake(ponto.x, ponto.y);
            
            
            
            
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y-self.position.y)*multi)];

            //  action = [SKAction followPath:(CGPathCreateWithRect(CGRectMake(ponto.x, ponto.y, 10, 10), nil)) duration:2];
            //self.sprite.color=[UIColor greenColor];
            
//            actionChangeSprite=[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
            // self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
            break;
            
        case 2:
            
            [self.physicsBody applyForce:CGVectorMake(0,(ponto.y-self.position.y)*multi)];

            
//            actionChangeSprite=[SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:1.0 duration:0.0];
            
            //self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            break;
            
        case 3:
            
            [self.physicsBody applyForce:CGVectorMake((ponto.x-self.position.x)*multi,0)];
            

            
//            actionChangeSprite=[SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:0.0];
            break;
            
        case 4:
            [self.physicsBody applyForce:CGVectorMake((ponto.x-self.position.x)*multi,0)];
            

//            actionChangeSprite=[SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1.0 duration:0.0];
            
            break;
            
        default:
            break;
    }


    

}

@end
