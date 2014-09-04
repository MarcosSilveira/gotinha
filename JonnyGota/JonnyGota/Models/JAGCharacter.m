//
//  JAGCharacter.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGCharacter.h"

@implementation JAGCharacter

-(id)init{
    self = [super init];
    _EMTESTE = NO;

    return self;
}
-(void)configPhysics{
 //   self = [super configPhysics];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
 //   return self;

}

-(void)changePosition:(CGPoint) posicao{
    
    SKPhysicsBody *temp = self.physicsBody;
    
    self.physicsBody = nil;
    self.position = posicao;
    self.physicsBody = temp;
}

-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withType:(int)tipo {
    
    // 1 = Cima 2 = Baixo 3 = Esquerda 4 = Direita
    SKAction *action;
    
    SKAction *actionChangeSprite;
    
    // =CGVectorMake(ponto.x, ponto.y);
    
    //[self.physicsBody applyImpulse:CGVectorMake(0.3, 0.3) atPoint:ponto];
    
    // [self removeAllActions];
    
    self.physicsBody.velocity = CGVectorMake(0, 0);

        switch (tipo) {
            case 1:
                
                [self.physicsBody applyImpulse:CGVectorMake(0,_multi)];
                action = [SKAction moveToY:ponto.y duration:time];
                //  action = [SKAction followPath:(CGPathCreateWithRect(CGRectMake(ponto.x, ponto.y, 10, 10), nil)) duration:2];
                //self.sprite.color=[UIColor greenColor];
                
                actionChangeSprite = [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
                // self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(50, 50)];
                break;
                
            case 2:
                
                [self.physicsBody applyImpulse:CGVectorMake(0, - _multi)];
                action = [SKAction moveToY:ponto.y duration:time];
                
                actionChangeSprite = [SKAction colorizeWithColor:[SKColor brownColor] colorBlendFactor:1.0 duration:0.0];
                
                //self.sprite=[[SKSpriteNode alloc] initWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
                break;
                
            case 3:
                
                [self.physicsBody applyImpulse:CGVectorMake(- _multi,0)];
                
                action = [SKAction moveToX:ponto.x duration:time];
                
                actionChangeSprite = [SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:0.0];
                break;
                
            case 4:
                
                [self.physicsBody applyImpulse:CGVectorMake(_multi,0)];
                
                action = [SKAction moveToX:ponto.x duration:time];
                actionChangeSprite = [SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1.0 duration:0.0];
                
                break;
                
            default:
                break;
        }

    
    //Mover em 2 passos para diagonal?
    
    [self.sprite runAction:actionChangeSprite];
    
    //[self runAction:action];
}

-(void)animar{

}

-(NSMutableDictionary *)createJson{
    NSMutableDictionary *json = [[NSMutableDictionary alloc]init];
    
    NSNumber *temp = [[NSNumber alloc] initWithFloat:self.position.x];
    [json setObject:temp forKey:@"positionX"];
    
    temp = [[NSNumber alloc] initWithFloat:self.position.y];
    
    [json setObject:temp forKey:@"positionY"];
    [json setObject:_sprite.name forKey:@"sprite"];
    
    return json;
}

@end
