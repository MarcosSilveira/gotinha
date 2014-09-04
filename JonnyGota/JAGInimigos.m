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
    self.seguindo       = false;
    self.andandoIa      = false;
    self.atacouRanged   = false;
    self.inColissao     = false;
    
    self.sentido       = 0;
    self.sentido       = 0;
    self.visaoRanged   = 0;
    self.visao         = 100;
    self.lastPointToGo = 0;
    
    return self;
}

-(void)ataque{
    
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
                    sequenceTemp = [SKAction sequence:@[[SKAction moveTo:ponto duration:0.5],
                                                        [SKAction waitForDuration:0.1],
                                                        [SKAction runBlock:^{
                        [self.arrPointsFixes removeObjectAtIndex:i];
                    }]]];
                    
                } else {
                    sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction moveTo:ponto duration:0.5],
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
            sequenceTemp = [SKAction sequence:@[[SKAction moveTo:ponto duration:1],
                                                [SKAction runBlock:^{
                self.lastPointToGo=i+1;
                          }],
                                                [SKAction waitForDuration:1.3]]];
        } else {
            sequenceTemp = [SKAction sequence:@[sequenceTemp,[SKAction moveTo:ponto duration:1],
                                                [SKAction runBlock:^{
                self.lastPointToGo=i+1;
                
            }],
                                                
                                                [SKAction waitForDuration:1.3]]];
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
            int tempSentido;
            if(!self.inColisao){
                tempSentido = [self verificaSentido:jogador.position with:self.position];
                if(tempSentido != self.sentido) {
                    self.sentido = tempSentido;
                    [self mover:(jogador.position) withInterval:2 withType:self.sentido];
                    [self addPointFIxes];
                }
            }else{
//                tempSentido=[self verificaSentidoColisao:jogador.position withPontoObjeto:self.position withSentido:self.sentido];
//                if (tempSentido!=self.sentidoCol) {
//                    self.sentidoCol=tempSentido;
//                    [self mover:(jogador.position) withInterval:2 withType:self.sentidoCol];
//                    [self addPointFIxes];
//                }
            }
            
        }
        
    } else {
        
        self.seguindo = false;
        self.sentido  = 0;
        self.sentidoCol=0;
        [self IAcomInfo];
    }
}

-(void)movernaParede:(JAGGota *) jogador{
    int tempSentido=[self verificaSentidoColisao:jogador.position withPontoObjeto:self.position withSentido:self.sentido];
    if (tempSentido!=self.sentidoCol) {
        self.sentidoCol=tempSentido;
        [self mover:(jogador.position) withInterval:2 withType:self.sentidoCol];
        [self addPointFIxes];
    }
}

-(void)addPointFIxes{
    
    
    if([self addPointOk]){
        [self.arrPointsFixes addObject:[NSValue valueWithCGPoint:self.position]];
//        NSLog(@"Counts. %d",self.arrPointsFixes.count);
    }
    [self removeActionForKey:@"move"];
}

-(bool)addPointOk{
    if (self.arrPointsFixes.count>0) {
        
        CGPoint ponto = [(NSValue *)[self.arrPointsFixes objectAtIndex:self.arrPointsFixes.count-1] CGPointValue]; 
       
        if(self.position.x==ponto.x&&self.position.y==ponto.y){
            return false;
        }
    }
    
    return true;
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

-(int)verificaSentidoColisao:(CGPoint)pontoReferencia withPontoObjeto:(CGPoint)pontoObjeto withSentido:(int) sentido{
    
    
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
    
    if(sentido<3){
        if(negx)
            tipo = 4;
        else
            tipo = 3;

    }else{
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
