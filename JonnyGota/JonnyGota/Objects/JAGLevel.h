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



-(instancetype)initWithHeight:(int) height
                    withWidth:(int) width;

-(void)exportar;

@end
