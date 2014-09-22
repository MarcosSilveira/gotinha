//
//  JAGChuva.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGChuva.h"
#import "JAGCharacter.h"

@implementation JAGChuva

-(instancetype)initWithPosition:(CGPoint)ponto{
    
    self = [super init];
    
    self.nuvemText = [SKTexture textureWithImageNamed:@"nuvem"];
    self.sprite = [[SKSpriteNode alloc] initWithTexture:self.nuvemText];
    self.name = @"chuva";
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = CHUVA;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;

    self.chuva = [[Musica alloc] init];
    
    [self.chuva inici];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"rain" ofType:@"caf"];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];

    [self.chuva carregar:fileUrl withEffects:true];
    
    [self.chuva changeVolume:0.8];
    
//    [self.chuva updateListener:posx withY:posy withZ:0.0f];
    
//    [self.chuva configureEffects:ponto.x withY:ponto.y withZ:0.0f];
    
    [self.chuva playInLoop];
    
    [self addChild:self.sprite];
    
    self.physicsBody.dynamic=NO;
    
    self.position = ponto;
    
    self.physicsBody.restitution = 0;
    
    return self;
}

-(void)update:(JAGGota *)gota{
//    [self.chuva updateListener:gota.position.x withY:gota.position.y withZ:0.0f];
    
    float posx=self.position.x-gota.position.x;
    
    float posy=self.position.y-gota.position.y;
    
    [self.chuva configureEffects:posx withY:posy withZ:0.0f];
//    NSLog(@"update gota");
}

@end
