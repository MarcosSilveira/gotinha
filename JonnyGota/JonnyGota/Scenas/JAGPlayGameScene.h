//
//  JAGPlayGameScene.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JAGLevel.h"
#import "JAGGota.h"
#import "JAGHud.h"
#import "JAGFogoEnemy.h"


@interface JAGPlayGameScene : SKScene<SKPhysicsContactDelegate>
{
//    JAGGota *gota;
    //Scenario----
    SKSpriteNode *platform;
    SKSpriteNode *platform2;
    SKSpriteNode *fundo;
    SKSpriteNode *fundo2;
    SKNode *myWorld;
    SKNode *camera;
    SKTextureAtlas *atlas;

}

@property (nonatomic) NSNumber *currentLevel;
@property (nonatomic) NSNumber *currentWorld;

@property (nonatomic) int vidasTotais;
@property (nonatomic) JAGGota* gota;
@property (nonatomic) JAGHud* hud;

@property (nonatomic) JAGLevel *level;

@property (nonatomic) JAGFogoEnemy *fogo;
@property (nonatomic) SKCropNode *cropNode;

-(void)divideGota;
-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto;
- (id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world;



-(void)loadingWorld;

-(void)createMask:(int) radius
        withPoint:(CGPoint) ponto;
-(void)followPlayer;
@end
