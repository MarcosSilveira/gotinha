//
//  JAGLevel.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAGGota.h"
#import "JAGFogoEnemy.h"
#import "JAGWall.h"

@interface JAGLevel : NSObject

@property (nonatomic) JAGGota* gota;

@property (nonatomic) NSMutableDictionary *inimigos;

@property (nonatomic) NSMutableDictionary *itens;

@property (nonatomic) int width;

@property (nonatomic) int height;

@property (nonatomic) NSMutableDictionary *paredes;

@property (nonatomic) int tileSize;

@property (nonatomic) NSNumber *mundo;

@property (nonatomic) NSNumber *level;

@property (nonatomic) SKSpriteNode *background;


-(instancetype)initWithHeight:(int) height
                    withWidth:(int) width;

-(NSString *)exportar;


-(void)createWalls:(CGPoint) ponto
       withHeight:(int) altura
        withWidth:(int) largura
         withScene:(SKScene *)scene;

-(CGPoint)calculateTile:(CGPoint) pontoMatriz;

-(CGSize)sizeTile;


@end
