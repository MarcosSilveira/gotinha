//
//  JAGMusicAction.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 29/10/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Musica.h"

@interface JAGMusicAction : SKAction

@property Musica *musica;

@property NSMutableArray *Musicas;

@property BOOL paused;



-(instancetype)initWithMusic:(Musica *)music;

-(void)dealloc;

-(void)play;

-(void)stop;

-(void)addNewMusica:(Musica *)musica;


@end
