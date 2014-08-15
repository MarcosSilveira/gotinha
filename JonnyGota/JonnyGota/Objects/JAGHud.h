//
//  JAGHud.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface JAGHud : NSObject

@property (nonatomic) int tempoRestante;
@property (nonatomic) int vidaRestante;

//Sprites da tela
@property (nonatomic) SKSpriteNode* sprite;

-(void)update;


@end
