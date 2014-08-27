//
//  JAGInimigos.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGInimigos.h"

@implementation JAGInimigos {
    
    CGPoint point;
    CGPoint pointInit;
    JAGGota *personagem;
}
-(id)init {
    self = [super init];
    
    pointInit = self.position;
    
    
    return self;
}

-(void)ataque{
    
}

// IN PROGRESS ...
-(void)ia { // Inteligencia Artificial GENERICA
    
    // Movimentaçao;
    
    [self mover:point withInterval:1.0 withType:1]; // cima
    [self mover:point withInterval:1.0 withType:2]; // baixo
    [self mover:point withInterval:1.0 withType:3]; // esq
    [self mover:point withInterval:1.0 withType:4]; // dir
    
    // Detecçao;
    
    float distance = hypotf(self.position.x - personagem.position.x, self.position.y - personagem.position.y);
    
    if (distance < 100) {
        if (personagem.escondida == NO) {
            [self mover:(personagem.position) withInterval:2 withType:1];
        }
        else self.physicsBody.velocity = CGVectorMake(0, 0);
    }
    else self.physicsBody.velocity = CGVectorMake(0, 0);
}

-(NSMutableDictionary *)createJson {
    
    NSMutableDictionary *json = [super createJson];
    
    NSNumber *temp = [[NSNumber alloc] initWithFloat:self.tipo];
    [json setValue:temp forKeyPath:@"tipo"];
    
    return json;
}

@end
