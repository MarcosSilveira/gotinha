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
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    CGPoint pointInit;
}
-(id)init {
    self = [super init];

    point2 = CGPointMake(self.position.x - 10, 0);
    point3 = CGPointMake(self.position.x + 10, 0);
    
    return self;
}

-(void)ataque{
    
}

// IN PROGRESS ...
-(void)IAcomInfo:(JAGGota *) jogador { // Inteligencia Artificial GENERICA

    // Detecçao;
    
    float distance = hypotf(self.position.x - jogador.position.x, self.position.y - jogador.position.y);
    
    if (distance < 100) {
        if (jogador.escondida == NO) {
            [self mover:(jogador.position) withInterval:2 withType:[self verificaSentido:jogador.position with:self.position]];
        }
    }
    
    // Movimentaçao
    
    else {
        CGPoint ponto=CGPointMake(0, 100);
        _movePath = [SKAction sequence:@[[SKAction moveTo:CGPointMake(0, self.position.y+ponto.y) duration:1.0],
                                         [SKAction waitForDuration:10.0],
                                         [SKAction moveTo:CGPointMake(0, self.position.y-ponto.y) duration:1.0],
                                         //[SKAction repeatActionForever:_movePath]
                                         ]];
        
        NSLog(@"pos: %f", self.position.y);
        
        [self runAction:_movePath];
    }
}

-(NSMutableDictionary *)createJson {
    
    NSMutableDictionary *json = [super createJson];
    
    NSNumber *temp = [[NSNumber alloc] initWithFloat:self.tipo];
    [json setValue:temp forKeyPath:@"tipo"];
    
    return json;
}

-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto {
    
    int tipo;
    
    float difx = pontoObjeto.x - pontoReferencia.x;
    float dify = pontoObjeto.y - pontoReferencia.y;
    
    BOOL negx = false;;
    bool negy = false;
    
    if(difx < 0){
        negx = true;
        difx *= -1;
    }
    if(dify < 0){
        negy = true;
        dify *= -1;
    }
    
    if (difx > dify) {
        if(negx)
            tipo = 4;
        else
            tipo = 3;
    }
    else{
        if(negy)
            tipo = 1;
        else
            tipo = 2;
    }
    
    return tipo;
}


@end
