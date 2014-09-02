//
//  JAGInimigos.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGInimigos.h"

@implementation JAGInimigos

-(id)init {
    self = [super init];
    
    self.arrPointsFixes = [[NSMutableArray alloc] init];
    self.seguindo       = false;
    self.andandoIa      = false;
    self.sentido        = 0;
    
    self.seguindo=false;
    
    self.andandoIa=false;
    
    self.sentido=0;
    
    self.visaoRanged=0;
    
    self.visao=100;
    
    self.atacouRanged=false;
    
    return self;
}

-(void)ataque{
    
}

// IN PROGRESS ...
-(void)IAcomInfo{ // Inteligencia Artificial GENERICA
    
    // Movimentaçao
    
    if (!self.andandoIa) {
        
        self.andandoIa = true;
        
        if (self.arrPointsFixes.count == 0) {
            
            SKAction *sequenceTemp;
            
            for(int i = 0; i < self.arrPointsPath.count; i++){
                
                CGPoint ponto = [(NSValue *)[self.arrPointsPath objectAtIndex:i] CGPointValue];
                
                if(i == 0){
                    sequenceTemp = [SKAction sequence:@[[SKAction moveTo:ponto duration:1.5],
                                                        [SKAction waitForDuration:2.0]]];
                } else {
                    sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction moveTo:ponto duration:1.5],
                                                        [SKAction waitForDuration:2.0]]];
                }
            }
            _movePath = [SKAction repeatActionForever:sequenceTemp];
            
            [self runAction:_movePath withKey:@"move"];
            
        } else {
            //Correção - SABER QUAL PONTO Q ELE PAROU
            
            SKAction *sequenceTemp;
            
            for(int i = self.arrPointsFixes.count - 1.0; i >= 0; i--) {
                
                CGPoint ponto = [(NSValue *)[self.arrPointsFixes objectAtIndex:i] CGPointValue];
                
                if(i == self.arrPointsFixes.count - 1) {
                    sequenceTemp = [SKAction sequence:@[[SKAction moveTo:ponto duration:1],
                                                        [SKAction waitForDuration:0.1],
                                                        [SKAction runBlock:^{
                        [self.arrPointsFixes removeObjectAtIndex:i];
                    }]]];
                    
                } else {
                    sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction moveTo:ponto duration:1],
                                                        [SKAction waitForDuration:0.1],
                                                        [SKAction runBlock:^{
                        [self.arrPointsFixes removeObjectAtIndex:i];
                    }]]];
                }
                
                if(i == 0) {
                    sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction runBlock:^{
                        self.andandoIa = false;
                        NSLog(@"ponto: %@", [NSValue valueWithCGPoint:ponto]);
                    }]]];
                }
            }
            _movePath = sequenceTemp;
            [self runAction:_movePath withKey:@"move"];
        }
    }
}

-(void)follow:(JAGGota *) jogador{
    float distance = hypotf(self.position.x - jogador.position.x, self.position.y - jogador.position.y);
    
    if (distance < self.visao) {
        if (jogador.escondida == NO) {
            self.seguindo = true;
            self.andandoIa = false;
            int tempSentido = [self verificaSentido:jogador.position with:self.position];
            if(tempSentido != self.sentido){
                self.sentido = tempSentido;
                [self mover:(jogador.position) withInterval:2 withType:self.sentido];
                [self.arrPointsFixes addObject:[NSValue valueWithCGPoint:self.position]];
                [self removeActionForKey:@"move"];
            }
        }
        
    } else {
        
        self.seguindo = false;
        self.sentido  = 0;
        [self IAcomInfo];
    }
}

-(JAGAttack *)attackRanged:(JAGGota *)jogador{
    float distance = hypotf(self.position.x - jogador.position.x, self.position.y - jogador.position.y);
    
    JAGAttack *ata;
    
    if (distance < self.visaoRanged &&self.visaoRanged>0 && !self.atacouRanged) {
        self.physicsBody.velocity=CGVectorMake(0, 0);
        
        self.atacouRanged=YES;
        
        ata=[self createAttackRanged:CGVectorMake(jogador.position.x - self.position.x,  jogador.position.y - self.position.y)];
        
        SKAction *delay=[SKAction sequence:@[[SKAction waitForDuration:self.delayAttack], [SKAction runBlock:^{
            self.atacouRanged=NO;
        }]]];        
        [self runAction:delay];

    }
    return ata;
}

-(JAGAttack *)createAttackRanged: (CGVector)withImpulse{
    return nil;
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
