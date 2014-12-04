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

-(instancetype)initWithPosition:(CGPoint)ponto withSize:(CGSize)size{
    
    self = [super init];
    
    size=CGSizeMake(size.width*2, size.width*1.5);
    
    self.nuvemText = [SKTexture textureWithImageNamed:@"nuvem"];
    self.sprite = [[SKSpriteNode alloc] initWithTexture:self.nuvemText];
    self.sprite.size=size;
    self.name = @"chuva";
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = CHUVA;
    self.physicsBody.collisionBitMask = GOTA;
    self.physicsBody.contactTestBitMask = GOTA;
    
    self.chuva = [[Musica alloc] init];
    
    [self.chuva inici];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AMBL" ofType:@"caf"];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    

    [self.chuva carregar:fileUrl withEffects:true];
    
    [self.chuva changeVolume:1];
    
    
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"AMBR" ofType:@"caf"];
    NSURL* fileUrl2 = [NSURL fileURLWithPath:filePath2];

    
    self.chuvaOposto = [[Musica alloc] init];
    
    [self.chuvaOposto inici];
    
    [self.chuvaOposto carregar:fileUrl2 withEffects:true];
    
    [self.chuvaOposto changeVolume:1];
    
    
    
    //    [self.chuva updateListener:posx withY:posy withZ:0.0f];
    
    //    [self.chuva configureEffects:ponto.x withY:ponto.y withZ:0.0f];
    
    [self.chuva playInLoop];
    
    [self.chuvaOposto playInLoop];
    
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
    
    float posxOpos=posx*(-1);
    
    [self.chuva configureEffects:posx withY:posy withZ:0.0f];
    [self.chuvaOposto configureEffects:posxOpos withY:posy withZ:0.0f];
    //    NSLog(@"update gota");
}

-(void)soltar{
    [self.chuva soltar];
    [self.chuvaOposto soltar];
}

@end
