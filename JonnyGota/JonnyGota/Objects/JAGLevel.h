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

@interface JAGLevel : NSObject

@property (nonatomic) JAGGota* gota;

@property (nonatomic) NSMutableArray *inimigos;

@property (nonatomic) NSMutableArray *itens;

@end
