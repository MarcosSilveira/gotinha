//
//  JAGWall.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 13/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGWall.h"

@implementation JAGWall



-(id)init{
    self =[super init];
    
    
    
    return self;
}

-(instancetype)initWithSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    return self;
}

@end
