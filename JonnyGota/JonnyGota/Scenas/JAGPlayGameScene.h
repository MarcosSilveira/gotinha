//
//  JAGPlayGameScene.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
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
@end
