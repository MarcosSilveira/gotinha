//
//  JAGMusicAction.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 29/10/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGManagerSound.h"

@interface JAGMusicAction : SKAction

@property JAGManagerSound *managerSound;

@property BOOL paused;

@property SKNode *nodo;

-(instancetype)init;

-(void)dealloc;

-(void)play;

-(void)stop;

-(void)soltar;


@end
