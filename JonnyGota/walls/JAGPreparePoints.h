//
//  JAGPreparePoints.h
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 16/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JAGPreparePoints : NSObject

@property (nonatomic) CGPoint ponto;

@property (nonatomic) JAGPreparePoints *proximo;

@property (nonatomic) JAGPreparePoints *proximoAlto;



@property (nonatomic) BOOL usado;

@property (nonatomic) BOOL usadoAlto;

@property (nonatomic) BOOL antes;

@property (nonatomic) BOOL antesAlto;


-(BOOL)procurarProximo:(NSMutableArray *)nodes
          withTileSize:(int) tilesize;

@end
