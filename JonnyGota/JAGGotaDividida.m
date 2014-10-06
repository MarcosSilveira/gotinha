//
//  JAGGotaDividida.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 21/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGotaDividida.h"

@implementation JAGGotaDividida

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    self = [super init];
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    
    self.physicsBody.friction = 0;
    
    //    desn.position=position;
    
    //[self addChild:desn];
    
    self.name=@"gotaDividida";
    
    self.sprite.name=@"gotaDividida";
    
    [self addChild:self.sprite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    self.physicsBody.categoryBitMask = DIVIDIDA;
    self.physicsBody.collisionBitMask = ENEMY |ITEM |PORTA|PAREDE;
    self.physicsBody.contactTestBitMask = ENEMY | CONTROLE_TOQUE |ITEM |PRESSAO |GOTA;
    
    [self configPhysics];
    
    self.position = position;
    
    self.sprite.zPosition=100;
    
    self.zPosition=100;
    
    self.physicsBody.restitution=0;
    
    self.pronto=false;
    
    SKAction *stop=[SKAction sequence:@[[SKAction waitForDuration:1], [SKAction runBlock:^{
        self.physicsBody.velocity=CGVectorMake(0, 0);
        
        SKAction *pronto=[SKAction sequence:@[[SKAction waitForDuration:2], [SKAction runBlock:^{
            self.pronto=true;
        }]]];
        
        [self runAction:pronto];
    }]]];
    
    [self runAction:stop];
    
    return self;

}

@end
