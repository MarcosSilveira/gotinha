//
//  JAGInimigos.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGInimigos.h"

@implementation JAGInimigos
-(id)init{
    self =[super init];
    return self;
}

-(NSMutableDictionary *)createJson{
    NSMutableDictionary *json=[super createJson];
    
    NSNumber *temp=[[NSNumber alloc] initWithFloat:self.tipo];

    [json setValue:temp forKeyPath:@"tipo"];
    
    return json;
}
@end
