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
    self.atlas = [SKTextureAtlas atlasNamed:@"enemies.atlas"];
    self.sprite.texture = [self.atlas textureNamed:@"fogo_idle.png"];
    self.idleTexture = [self.atlas textureNamed:@"fogo_idle.png"];
    
    for (int i=1; i<=8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"fogo_correndo_lado%d@2x.png", i];
        [self.walkTexturesFront addObject:[self.atlas textureNamed:textureName]];
    }
    
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


-(JAGAttack *)createAttackRanged: (CGVector)withImpulse{
    SKSpriteNode *trovao = [[SKSpriteNode alloc] initWithColor:[UIColor yellowColor] size:CGSizeMake(15, 15)];
    JAGAttack *attack = [[JAGAttack alloc] initWithPosition:self.position withImpulse:withImpulse withDano:3 withSprite:trovao];
    
    return attack;
}

-(void)moveTelep:(CGPoint)totp { // vou arrumar a volta do teleport, tp e tp de volta pra pos init;
    
    x = arc4random_uniform(200);
    y = arc4random_uniform(200);
    
    CGPoint back=self.position;
    
    SKAction *tp = [SKAction sequence:@[[SKAction waitForDuration:5], [self preparetp:totp],
                                        [SKAction waitForDuration:4], [self preparetp:back]]];
    
    SKAction *loop = [SKAction repeatActionForever:tp];
    
    [self runAction:loop];
}

-(SKAction *)preparetp:(CGPoint) ponto{
    SKAction *tprepare=[SKAction sequence:@[[SKAction runBlock:^{
        SKEmitterNode *trovao=[self.spark createEmitter:CGPointMake(ponto.x-self.position.x, ponto.y-self.position.y) withTimeLife:0.5];
        NSLog(@"Ponto x:%f  y:%f",ponto.x,ponto.y);
        [self addChild:trovao];
            }], [SKAction waitForDuration:1], [SKAction runBlock:^{
        //[self addChild:_spark.emitter];
        [self changePosition:ponto];
                SKEmitterNode *trovao=[self.spark createEmitter:CGPointMake(ponto.x-self.position.x, ponto.y-self.position.y) withTimeLife:0.1];
                [self addChild:trovao];
      //  [_spark.emitter removeFromParent];
    }]
                                             ]]  ;
    
    return tprepare;
}

@end
