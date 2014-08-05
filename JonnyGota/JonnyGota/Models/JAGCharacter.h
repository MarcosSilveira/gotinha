//
//  JAGCharacter.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JAGCharacter : SKNode

@property (nonatomic) NSInteger* vida;

@property (nonatomic) SKSpriteNode* sprite;

-(void)Animar;



@end
