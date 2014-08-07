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
    
//    desn.position=position;
    
    //[self addChild:desn];
    
    self.sprite=desn;
    
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
    if((ponto.x>self.position.x)&&(ponto.x<(self.position.x+self.sprite.size.width))){
        if((ponto.y>self.position.y)&&(ponto.y<(self.position.y+self.sprite.size.height))){
            
          //  NSLog(@"Ponto %@",)
            return true;
        }
    }
    
    return false;
}

@end
