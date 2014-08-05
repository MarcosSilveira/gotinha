//
//  Musica.h
//  AudiosTestes
//
//  Created by Henrique Manfroi da Silveira on 10/07/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>


@interface Musica : NSObject

@property (nonatomic) ALCcontext* openContext;


@property (nonatomic) ALuint outputSource;

@property (nonatomic) ALuint outputBuffer;



-(void)carregar: (NSString *)url
    withEffects:(BOOL) efeito;

-(void)soltar;

-(void)play;

-(void)playEffects;

-(void)configure:(ALCcontext*) context;

-(void)inici;

-(void)configureEffects:(float) x
                  withY:(float) y
                  withZ:(float) z;

-(void)stop;

-(void)playInLoop;

-(void)changeVolume:(float)vol;

-(id)initWithContext:(ALCcontext *)cont;

-(void)updateListener:(float) x
                withY:(float) y
                withZ:(float) z;

@end
