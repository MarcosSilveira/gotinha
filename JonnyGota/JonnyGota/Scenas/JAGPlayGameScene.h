//
//  JAGPlayGameScene.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGHud.h"
#import "JAGGota.h"

@interface JAGPlayGameScene : SKScene

@property (nonatomic) int vidasTotais;

@property (nonatomic) JAGGota* gota;

@property (nonatomic) JAGHud* hud;

- (id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world;

@end
