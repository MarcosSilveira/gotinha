//
//  JAGGota.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGota.h"

@implementation JAGGota

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    
    self = [super init];
    
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    self.atlas = [SKTextureAtlas atlasNamed:@"gotinha.atlas"];
    self.sprite.texture = [_atlas textureNamed:@"gota_walk_1.png"];
    
    self.physicsBody.friction = 0;
    
//    desn.position=position;
    
    //[self addChild:desn];
    
    self.name=@"gota";
    
    self.sprite.name=@"gota";
    
    [self addChild:self.sprite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY |ITEM;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY | CONTROLE_TOQUE |ITEM;
    
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

-(void) dividir {
    SKAction *dividAction;

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
    if((ponto.x >= (self.position.x - self.sprite.size.width/2)) && (ponto.x < (self.position.x+self.sprite.size.width/2))){
        if((ponto.y >= (self.position.y - self.sprite.size.height/2)) && (ponto.y < (self.position.y+self.sprite.size.height/2))){
            
            return true;
        }
    }
    
    //NSLog(@"Ponto x:%f  y:%f Calc x: %f ",ponto.x,ponto.y,self.position.x+self.sprite.size.width);
    //NSLog(@"Positions x: %f  y: %f  calc y: %f",self.position.x,self.position.y,self.position.y+self.sprite.size.height);
    
    return false;
}

@end
