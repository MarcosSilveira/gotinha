//
//  JAGPorta.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 20/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPorta.h"
#import "JAGCharacter.h"

@implementation JAGPorta

-(instancetype)initWithPosition:(CGPoint)ponto withSprite:(SKSpriteNode *)imagem{
    self=[super init];
    
    _sprite=imagem;
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    
    self.name=@"porta";

    [self configPhysicsBody];
    
    _aberta=FALSE;

    
    _pressoes=[[NSMutableArray alloc] init];
    
      return self;
}

-(void)configPhysicsBody{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];//CGSizeMake(self.sprite.size.width, self.sprite.size.height) ];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.restitution=0.015;
    
    
    self.physicsBody.categoryBitMask = PORTA;
    self.physicsBody.collisionBitMask = GOTA |ENEMY;
    self.physicsBody.contactTestBitMask = GOTA;

}

-(void)verificarBotoes{
    bool temp=true;
    for (int i=0; i<_pressoes.count; i++) {
        JAGPressao *obj=_pressoes[i];
        if(!obj.presionado){
            temp=false;
        }
    }
    
    [self abrir:temp];
    
    if (temp) {
        //Se aberta animar
        
    }
    _aberta=temp;
}

-(void)vincularBotao:(JAGPressao *)botao{
    [_pressoes addObject:botao];
}

-(void)abrir:(BOOL)aberto{
    if(_aberta!=aberto){
        if(aberto){
            _aberta=true;
            self.physicsBody=nil;
        }else{
            _aberta=false;
            [self configPhysicsBody];
        }
    }
   
}

-(BOOL)passar{
    
    if(_aberta){
        
        //Aberta
        return true;
    }else{
        //Fechar
        return false;
    }
    
}

@end
