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

float lastposx;

float volumeNormal;

float volumeOposto;

float volumeAtual;

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
    
    self.managerSound =[JAGManagerSound sharedManager];
    
    [self addChild:self.sprite];
    
    self.physicsBody.dynamic=NO;
    
    self.position = ponto;
    
    self.physicsBody.restitution = 0;
    
    [self loadSound];
    
    return self;
}

-(void)loadSound{
    volumeNormal=1.0;
    
    volumeAtual=volumeNormal;
    
    volumeOposto=0.7;
    
    [self.managerSound addSound:@"AMBL" withEffects:true withKey:@"chuva"];
    
//    [self.managerSound carregar:@"AMBL" withEffects:true];
    
    [self.managerSound changeVolume:@"chuva" withSound:volumeNormal];
    
    [self.managerSound addSound:@"AMBL" withEffects:true withKey:@"chuvaOposto"];
    
    
    [self.managerSound changeVolume:@"chuvaOposto" withSound:volumeOposto];

    [self.managerSound playInLoop:@"chuva"];
    
    [self.managerSound playInLoop:@"chuvaOposto"];
}

-(void)update:(JAGGota *)gota{
    //    [self.chuva updateListener:gota.position.x withY:gota.position.y withZ:0.0f];
    
    float posx=self.position.x-gota.position.x;
    
    float posy=self.position.y-gota.position.y;
    
    float posxOpos=posx*(-1);
    
    if (  ((lastposx>0&& posx<0)  ||  (lastposx<0 && posx>0)) && volumeAtual==volumeNormal) {
        lastposx=posx;
        
        //Fazer Fade do volume
        
        volumeAtual=0.3;
        
        [self.managerSound changeVolume:@"chuva" withSound:volumeAtual];

        
        NSTimer *t=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(fadeVolume:) userInfo:nil repeats:YES];
        
        
        [[NSRunLoop mainRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
    }else{
        lastposx=posx;
    }
    
    [self.managerSound configureListener:@"chuva" withX:posx withY:posy withZ:0.0];
    [self.managerSound configureListener:@"chuvaOposto" withX:posxOpos withY:posy withZ:0.0];
//     changeVolume:@"chuva" withSound:volumeAtual];
//    
//    [self.chuva configureEffects:posx withY:posy withZ:0.0f];
//    [self.chuvaOposto configureEffects:posxOpos withY:posy withZ:0.0f];
//    [self.chuvaOposto configureEffects:posx withY:posy withZ:0.0f];

    //    NSLog(@"update gota");
}

-(void)fadeVolume:(NSTimer *)timer{

    volumeAtual+=0.12;
    [self.managerSound changeVolume:@"chuva" withSound:volumeAtual];
//    [self.chuva changeVolume:volumeAtual];
    if (volumeAtual>=volumeNormal) {
        volumeAtual=volumeNormal;
        [timer invalidate];
    }
//    volumeAtual=volumeOposto
}

-(void)soltar{
    [self.managerSound stopSound:@"chuva"];
    [self.managerSound stopSound:@"chuvaOposto"];
//    [self.chuva soltar];
//    [self.chuvaOposto soltar];
}

@end
