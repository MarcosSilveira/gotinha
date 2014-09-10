//
//  JAGTrovaoEnemy.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGTrovaoEnemy.h"
#import "JAGSparkRaio.h"

@implementation JAGTrovaoEnemy {
    
    int x,
    y;
}

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
    //  self.physicsBody.mass = 9000;
    //  desn.position = position;
    
    //[self addChild:desn];
    
    self.multi = 2;
    self.spark = [[JAGSparkRaio alloc] initWithPosition:self.position withTimeLife:10];
    
    [self configPhysics];
    [self addChild:self.sprite];
    
    self.visaoRanged = 150;
    self.position = position;
    self.delayAttack = 5;
    
    return self;
}

-(void)ataque{
    
}

-(BOOL)tocou:(CGPoint)ponto {
    
    BOOL toque;
    
    return toque;
}

-(JAGAttack *)createAttackRanged: (CGVector)withImpulse{
    SKSpriteNode *trovao = [[SKSpriteNode alloc] initWithColor:[UIColor yellowColor] size:CGSizeMake(15, 15)];
    JAGAttack *attack = [[JAGAttack alloc] initWithPosition:self.position withImpulse:withImpulse withDano:3 withSprite:trovao];
    
    return attack;
}

-(void)moveTelep:(CGPoint) totp { // vou arrumar a volta do teleport, tp e tp de volta pra pos init;
    
    x = arc4random_uniform(200);
    y = arc4random_uniform(200);
    
    CGPoint back=self.position;
    
    SKAction *tp = [SKAction sequence:@[[SKAction waitForDuration:5],
                                        [SKAction runBlock:^{
        
        [self addChild:_spark.emitter];
        [self changePosition:totp];
        [_spark.emitter removeFromParent];
        
    }],[SKAction waitForDuration:4],[SKAction runBlock:^{
        [self addChild:_spark.emitter];
        [self changePosition:back];
        [_spark.emitter removeFromParent];
    }] ]];
    
    SKAction *loop = [SKAction repeatActionForever:tp];
    
    [self runAction:loop];
}

@end
