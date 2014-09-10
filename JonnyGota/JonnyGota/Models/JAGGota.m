//
//  JAGGota.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGota.h"

@implementation JAGGota

-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    
    self = [super init];
    
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    self.atlas  = [SKTextureAtlas atlasNamed:@"gotinha.atlas"];
    self.sprite.texture = [self.atlas textureNamed:@"gota_walk_1.png"];
    
    self.physicsBody.friction = 0;
    
    self.multi = size.width/2;
    
    //    desn.position=position;
    
    //[self addChild:desn];
    
    self.name = @"gota";
    
    self.sprite.name = @"gota";
    
    [self addChild:self.sprite];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.sprite.size.width, self.sprite.size.height)];
    //self.zPosition = 1;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY |ITEM |PORTA | CHUVA | CHAVE | PAREDE;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY | CONTROLE_TOQUE |ITEM | CHUVA |CHAVE | FONTE_DA_JUVENTUDE | PAREDE | TRAP;
    
    [self configPhysics];
    
    self.position = position;
    
    self.sprite.zPosition=10;
    
    self.zPosition=10;
    
    _escondida = NO;
    _dividida = NO;
    _emContatoFonte = NO;
    _comChave = NO;
    _aguaRestante = 10;
    
    self.gotinhas=[[NSMutableArray alloc] init];
    
    self.qtGotinhas=2;
    
    //Musicas
//    self.musandar=[Musica alloc] in
    
    return self;
}

-(void)esconder{
    SKAction *pocaAction;
    pocaAction = [SKAction scaleYTo:-.5 duration:1.0];
    if (_escondida == NO) {
        _escondida = YES;
        [self runAction:pocaAction];
    }
    else if (_escondida){
        pocaAction = [SKAction scaleYTo:+1 duration:1.0];
        _escondida = NO;
        [self runAction:pocaAction];
        
    }
}

-(JAGGotaDividida*) dividir {
    SKAction *dividAction;
    
    if (_dividida) {
        dividAction = [SKAction fadeInWithDuration:1.0];
        _dividida = NO;
    }
    else{
        dividAction = [SKAction fadeOutWithDuration:1.0];
        _dividida = YES;
    }
//    [self runAction:dividAction];
    
    CGSize aux = self.sprite.size;
    aux.height = aux.height/2;
    aux.width = aux.width/2;
    CGPoint aux2;
    aux2.x = self.position.x+5;
    aux2.y = self.position.y+5;
    JAGGotaDividida *gota2 = [[JAGGotaDividida alloc]initWithPosition:aux2 withSize:aux];
    gota2.sprite.texture = self.sprite.texture;
    
    [self.gotinhas addObject:gota2];
    
    if (self.gotinhas.count>self.qtGotinhas) {
        JAGGotaDividida *temp=(JAGGotaDividida *)self.gotinhas[0];
        [temp removeFromParent];
        [self.gotinhas removeObject:temp];
    }


    
    return gota2;
}

-(JAGGotaDividida*) dividirwithSentido:(int)sentido{
    SKAction *dividAction;
    
    if (_dividida) {
        dividAction = [SKAction fadeInWithDuration:1.0];
        _dividida = NO;
    }
    else{
        dividAction = [SKAction fadeOutWithDuration:1.0];
        _dividida = YES;
    }
    //    [self runAction:dividAction];
    
    CGSize aux = self.sprite.size;
    aux.height = aux.height/2;
    aux.width = aux.width/2;
    CGPoint aux2;
    aux2.x = self.position.x;
    aux2.y = self.position.y;
    JAGGotaDividida *gota2 = [[JAGGotaDividida alloc]initWithPosition:aux2 withSize:aux];
    gota2.sprite.texture = self.sprite.texture;
        

    [self.gotinhas addObject:gota2];
    
    if (self.gotinhas.count>self.qtGotinhas) {
        JAGGotaDividida *temp=(JAGGotaDividida *)self.gotinhas[0];
        [temp removeFromParent];
        [self.gotinhas removeObject:temp];
    }
    


    return gota2;
}


//-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withTipe:(int)tipo{
//
//
//
//}

-(BOOL)verificaToque:(CGPoint) ponto{
    if((ponto.x >= (self.position.x - self.sprite.size.width/2)) && (ponto.x < (self.position.x+self.sprite.size.width/2))){
        if((ponto.y >= (self.position.y - self.sprite.size.height/2)) && (ponto.y < (self.position.y+self.sprite.size.height/2))){
            
            return true;
        }
    }
    
    //NSLog(@"Ponto x:%f  y:%f Calc x: %f ",ponto.x,ponto.y,self.position.x+self.sprite.size.width);
    //NSLog(@"Positions x: %f  y: %f  calc y: %f",self.position.x,self.position.y,self.position.y+self.sprite.size.height);
    
    return false;
}

@end
