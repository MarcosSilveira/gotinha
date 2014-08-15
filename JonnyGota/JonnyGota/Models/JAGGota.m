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
    
    self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
   
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
  //  self.zPosition = 1;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self configPhysics];
    
    self.physicsBody.friction = 0;
    
    
    self = [super init];
    
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    
    [self addChild:self.sprite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY;
    
    [self configPhysics];
    
    self.name = @"gota";
    self.position = position;
    
    _escondida = NO;
    _dividida = NO;
    
    return self;
}


-(void)esconder{
    SKAction *pocaAction;
    pocaAction = [SKAction scaleYTo:-.5 duration:1.0];
    if (_escondida == NO) {
        _escondida = YES;
        [self runAction:pocaAction];
    }
    else if (_escondida){
        pocaAction = [SKAction scaleYTo:+1 duration:1.0];
        _escondida = NO;
        [self runAction:pocaAction];
        
    }
}

-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withTipe:(int)tipo{
    
    // 1 = Cima 2= Baixo 3= Esquerda 4 = Direita
    SKAction *action;
    
    SKAction *actionChangeSprite;

    
   // =CGVectorMake(ponto.x, ponto.y);
    
    //[self.physicsBody applyImpulse:CGVectorMake(0.3, 0.3) atPoint:ponto];
    
   // [self removeAllActions];
    
    self.physicsBody.velocity=CGVectorMake(0, 0);
    
    int multi=1000;
    
    
    switch (tipo) {
        case 1:
            
            //self.physicsBody.velocity=CGVectorMake(ponto.x, ponto.y);
           
            
            [self.physicsBody applyForce:CGVectorMake(0,multi)];
            action=[SKAction moveToY:ponto.y duration:time];
          //  action = [SKAction followPath:(CGPathCreateWithRect(CGRectMake(ponto.x, ponto.y, 10, 10), nil)) duration:2];
            //self.sprite.color=[UIColor greenColor];
            
            actionChangeSprite=[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
           // self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
            break;
            
        case 2:
            
            [self.physicsBody applyForce:CGVectorMake(0,-multi)];
            action=[SKAction moveToY:ponto.y duration:time];
            
            actionChangeSprite=[SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:1.0 duration:0.0];

            //self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            break;
            
        case 3:
            
            [self.physicsBody applyForce:CGVectorMake(-multi,0)];

            action=[SKAction moveToX:ponto.x duration:time];
            
            actionChangeSprite=[SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:0.0];
            break;
            
        case 4:
            [self.physicsBody applyForce:CGVectorMake(multi,0)];

    if (_dividida) {
        dividAction = [SKAction fadeInWithDuration:1.0];
        _dividida = NO;
    }
    else{
        dividAction = [SKAction fadeOutWithDuration:1.0];
        _dividida = YES;
    }
    [self runAction:dividAction];
}

//-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withTipe:(int)tipo{
//    
//
//    
//}

-(BOOL)verificaToque:(CGPoint) ponto{
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
