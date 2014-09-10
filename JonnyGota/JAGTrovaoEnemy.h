//
//  JAGTrovaoEnemy.h
//  JonnyGota
//
//  Created by Marcos Sokolowski on 06/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGInimigos.h"
#import "JAGSparkRaio.h"

// Habilidade Especial: Se teletransporta ao redor da fase

@interface JAGTrovaoEnemy : JAGInimigos

@property (strong, nonatomic) JAGSparkRaio *spark;

-(id)initWithPosition:(CGPoint) position withSize:(CGSize)size;
-(void)moveTelep:(CGPoint) totp;

@end
