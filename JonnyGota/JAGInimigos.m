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
    
    self.seguindo     = false;
    self.andandoIa    = false;
    self.sentido      = 0;
    self.visaoRanged  = 0;
    self.visao        = 100;
    self.atacouRanged = false;
    
    self.lastPointToGo = 0;
    
    return self;
}

-(void)ataque{
    
}

-(void)habilEspec:(int)tipo {
    
    if (tipo == 1) {
        
        SKAction *habilid = [SKAction sequence:@[[SKAction waitForDuration:5.0],
                                                 [SKAction runBlock:^{
            
            _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Raio" ofType:@"sks"]];
            _emitter.position = self.position;
            _emitter.name = @"perdida_raio";
            _emitter.numParticlesToEmit = 1000;
            
            [self destruirParti];
            
        }],
                                                 [SKAction runBlock:^{
            [self changePosition:CGPointMake(0, 0)];
        }],
                                                 [SKAction waitForDuration: 5.0],
                                                 [SKAction runBlock:^{
            
            _emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Raio" ofType:@"sks"]];
            _emitter.position = self.position;
            _emitter.name = @"perdida_raio";
            _emitter.numParticlesToEmit = 1000;
            
            [self destruirParti];
        }],
                                                 [SKAction runBlock:^{
            [self changePosition:self.position];
        }]]];
        [self runAction:habilid];
    }
    
    else {
        // rastro fogo;
    }
}

-(void) destruirParti {
    
    [_emitter removeFromParent];
}

-(BOOL)tocou:(CGPoint)ponto {
    
    BOOL toque;
    
    return toque;
}

// IN PROGRESS ...
-(void)IAcomInfo{ // Inteligencia Artificial GENERICA
    
    // Movimentaçao
    
    if (!self.andandoIa) {
        
        self.andandoIa = true;
        
        if (self.arrPointsFixes.count == 0) {
            [self createPathto];
            _movePath = [SKAction repeatActionForever:_movePath];
            [self runAction:_movePath withKey:@"move"];
        } else {
            //Correção - SABER QUAL PONTO Q ELE PAROU
            
            //self.andandoIa = true;
            
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
            }
            
            [self createPathto];
            _movePath = [SKAction sequence:@[sequenceTemp,_movePath]];
            
            
            _movePath = [SKAction sequence:@[_movePath,[SKAction runBlock:^{
                self.andandoIa = false;
                self.lastPointToGo=0;
            }]]];
            
            [self runAction:_movePath withKey:@"move"];
        }
    }
}

-(void)createPathto{
    
    SKAction *sequenceTemp;
    
    if(self.lastPointToGo>=self.arrPointsPath.count){
        self.lastPointToGo=0;
    }
    
    for(int i = self.lastPointToGo; i < self.arrPointsPath.count; i++){
        
        CGPoint ponto = [(NSValue *)[self.arrPointsPath objectAtIndex:i] CGPointValue];
        
        if(sequenceTemp==nil){
            sequenceTemp = [SKAction sequence:@[[SKAction moveTo:ponto duration:1.5],
                                                [SKAction runBlock:^{
                self.lastPointToGo=i+1;
            }],
                                                [SKAction waitForDuration:2.0]]];
        } else {
            sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction moveTo:ponto duration:1.5],
                                                [SKAction runBlock:^{
                self.lastPointToGo=i+1;
                
            }],
                                                
                                                [SKAction waitForDuration:2.0]]];
        }
        
    }
    sequenceTemp = [SKAction sequence:@[sequenceTemp,
                                        [SKAction runBlock:^{
        self.lastPointToGo=0;
    }]
                                        ]];
    
    //_movePath = [SKAction repeatActionForever:sequenceTemp];
    
    _movePath = sequenceTemp;
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
        
        [self removeActionForKey:@"move"];
        self.atacouRanged=YES;
        //self.andandoIa = true;
        
        [self.arrPointsFixes addObject:[NSValue valueWithCGPoint:self.position]];
        
        ata=[self createAttackRanged:CGVectorMake(jogador.position.x - self.position.x,  jogador.position.y - self.position.y)];
        
        //[self mover:(jogador.position) withInterval:2 withType:self.sentido];
        
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

-(int)localizePoint:(CGPoint) ponto{
    return 0;
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

//Usado para atualizar os liteners
-(void)update:(JAGGota *)gota{
    
}


@end
