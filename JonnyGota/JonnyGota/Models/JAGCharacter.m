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
    
    _walkTexturesBack = [[NSMutableArray alloc]init];
    _walkTexturesFront = [[NSMutableArray alloc]init];
    _walkTexturesSide = [[NSMutableArray alloc]init];
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
    
    // tipo: 1 = Cima 2 = Baixo 3 = Esquerda 4 = Direita

    
    // [self removeAllActions];
    
    self.physicsBody.velocity = CGVectorMake(0, 0);

        switch (tipo) {
            case 1:
                
                [self.physicsBody applyImpulse:CGVectorMake(0,_multi)];

//                [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesBack timePerFrame:0.1f]]withKey:@"walkingBack"];
                self.sprite.xScale = 1.0;
                
                
                break;
                
            case 2:
                
                [self.physicsBody applyImpulse:CGVectorMake(0, - _multi)];
                [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingFront"];
                self.sprite.xScale = 1.0;

                
                break;
                
            case 3:
                
                [self.physicsBody applyImpulse:CGVectorMake(- _multi,0)];
//                [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesSide timePerFrame:0.1f]]withKey:@"walkingSide"];
                self.sprite.xScale = -1.0;

                
                break;
                
            case 4:
                
                [self.physicsBody applyImpulse:CGVectorMake(_multi,0)];
//                [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesSide timePerFrame:0.1f]]withKey:@"walkingSide"];
                self.sprite.xScale = 1.0;

                
                break;
                
            default:
                break;
        }

    
    //Mover em 2 passos para diagonal?
    

    

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
