//
//  JAGHud.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGHud.h"

@implementation JAGHud

-(instancetype)initWithTempo:(int)tempo withVida:(int)vida withWindowSize:(CGSize)size{
    self= [super init];
    
    _tempoRestante=tempo;
    
    _vidaRestante=vida;
    
    NSString *fonte=@"AvenirNext-Bold";
    
    _vidas=[[SKLabelNode alloc] initWithFontNamed:fonte];
    _vidas.text=[NSString stringWithFormat:@"Vidas %d",_vidaRestante];
    
    _tempo=[[SKLabelNode alloc] initWithFontNamed:fonte];
    _tempo.text=[NSString stringWithFormat:@"%ds",_tempoRestante];
    
    _vidas.position=CGPointMake(size.width*0.2, size.height*0.95);
    
    _tempo.position=CGPointMake(size.width*0.6, size.height*0.95);
    
    [self addChild:_vidas];
    [self addChild:_tempo];
    
    return self;
}

-(void)update{
    _tempo.text=[NSString stringWithFormat:@"%ds",_tempoRestante];
    
    _vidas.text=[NSString stringWithFormat:@"Vidas %d",_vidaRestante];
}

-(void)cronometro:(NSTimer *)timer{
    
    if(!self.paused){
        if(_tempoRestante>0){
            _tempoRestante--;
            [self update];
        }
    }
    
    [self update];
}

-(void)startTimer{
    NSTimer *t = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(cronometro:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
}
@end
