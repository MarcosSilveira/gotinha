//
//  JAGPlayGameScene.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGGota.h"
#import "JAGHud.h"
#import "JAGGota.h"

@interface JAGPlayGameScene : SKScene
{
    JAGGota *gota;
    //Scenario----
    SKSpriteNode *platform;
    SKSpriteNode *platform2;
    SKSpriteNode *fundo;
    SKSpriteNode *fundo2;
    SKNode *myWorld;
    SKNode *camera;
}

@property (nonatomic) int vidasTotais;

@property (nonatomic) JAGGota* gota;

@property (nonatomic) JAGHud* hud;

@property (strong, nonatomic) SKSpriteNode *picToMask;

@property (strong, nonatomic) SKSpriteNode *mask;

@property (strong, nonatomic) SKCropNode *cropNode;

- (id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world;

@end
