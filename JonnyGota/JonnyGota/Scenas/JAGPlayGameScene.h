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
#import "JAGPorta.h"


@interface JAGPlayGameScene : SKScene<SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
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
    SKSpriteNode *fadeMask;
    //----Game over screen----
    
    SKSpriteNode *GObackground;
    SKSpriteNode *button1;
    SKSpriteNode *button2;
    SKSpriteNode *button3;
    SKLabelNode *message;

}

@property (nonatomic) NSNumber *currentLevel;
@property (nonatomic) NSNumber *currentWorld;

@property (nonatomic) int vidasTotais;
@property (nonatomic) JAGGota* gota;
@property (nonatomic) JAGHud* hud;

@property (nonatomic) JAGLevel *level;

@property (nonatomic) SKCropNode *cropNode;

@property (nonatomic) NSMutableArray *portas;

@property (nonatomic) NSMutableArray *characteres;

@property (nonatomic) NSMutableArray *inimigos;

@property (nonatomic) CGPoint posicaoInicial;

@property (nonatomic) SKNode *camadaPersonagens;

@property (nonatomic) SKNode *camadaItens;

-(void)divideGota;
-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto;
- (id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world;

-(void)gotaReduzVida;

-(void)loadingWorld;

-(void)createMask:(int) radius
        withPoint:(CGPoint) ponto;
-(void)followPlayer;

@property (nonatomic) SKAction* despresionar;

-(void)configStart:(int) time;

-(void)configInit:(SKSpriteNode *)background;

-(void)configInit;

-(void)presentGameOver:(int)withOP;

@end
