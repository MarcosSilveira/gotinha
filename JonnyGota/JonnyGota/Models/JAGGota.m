//
//  JAGGota.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGota.h"

@implementation JAGGota

-(id)initWithPosition:(CGPoint)position{
    self=[super init];
    
    SKSpriteNode *desn=[[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    self.sprite=desn;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
  //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY;
//    desn.position=position;
    
    //[self addChild:desn];
    
    
    
    [self addChild:self.sprite];
    
    self.position=position;
    
    return self;
}

-(id)init{
    self=[super init];
    
    SKSpriteNode *desn=[[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(200, 200)];
    
    //desn.position=
    
    return self;
}

-(void)esconder{
    
}

-(void)dividir{
    
}

-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time{
    SKAction *action;
    
    action=[SKAction moveTo:ponto duration:time];
    
    [self runAction:action];

    
    NSLog(@"Movendo?");
}

-(BOOL)tocou:(CGPoint) ponto{
    if((ponto.x>=(self.position.x-self.sprite.size.width/2))&&(ponto.x<(self.position.x+self.sprite.size.width/2))){
        if((ponto.y>=(self.position.y-self.sprite.size.height/2))&&(ponto.y<(self.position.y+self.sprite.size.height/2))){
            
            return true;
        }
    }
    
    //NSLog(@"Ponto x:%f  y:%f Calc x: %f ",ponto.x,ponto.y,self.position.x+self.sprite.size.width);
    //NSLog(@"Positions x: %f  y: %f  calc y: %f",self.position.x,self.position.y,self.position.y+self.sprite.size.height);
    
    return false;
}

@end
