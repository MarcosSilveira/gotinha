//
//  JAGManagerSound.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 06/12/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>
#import <SpriteKit/SpriteKit.h>

@interface JAGManagerSound : NSObject{
    JAGManagerSound *manager;
}


@property NSMutableDictionary *sound;

@property NSMutableDictionary *playing;

@property (nonatomic) ALuint outputSource;

@property (nonatomic) ALuint outputBuffer;

-(void)addSound:(NSString *)url withEffects:(BOOL)efeito withKey:(NSString *) key;

-(void)stopSound:(NSString *)key;

-(void)playSound:(NSString *)key;

-(void)configureListener:(NSString *)key withX:(float)x withY:(float)y withZ:(float)z;

-(void)liberar;

-(void)inative;

-(void)reative;

-(void)changeVolume:(NSString *)key withSound:(float)vol;

-(void)playInLoop:(NSString *)key;

-(NSTimeInterval)duration:(NSString *)key;

+(id)sharedManager;

-(SKAction*)playButton;

@end
