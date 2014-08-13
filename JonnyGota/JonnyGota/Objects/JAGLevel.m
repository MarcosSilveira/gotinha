//
//  JAGLevel.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGLevel.h"

@implementation JAGLevel

-(instancetype)initWithHeight:(int)height withWidth:(int)width{
    self=[super init];
    
    
    _width=width;
    
    _height=height;
    
    return self;
}

@end
