//
//  JAGPressao.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 20/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPressao.h"
#import "JAGCharacter.h"

 
@implementation JAGPressao

-(instancetype)initWithPosition:(CGPoint)ponto
                       withTipo:(int)tipo
                       withSize:(CGSize) tamanho{
    self=[super init];
    


    if (tipo==1) {
         _sprite=[[SKSpriteNode alloc] initWithImageNamed:@"botao1.png"];
    }else if (tipo==2){
        _sprite=[[SKSpriteNode alloc] initWithImageNamed:@"botao2_1.png"];
    }else if (tipo==3){
        _sprite=[[SKSpriteNode alloc] initWithImageNamed:@"botao3_1.png"];
    }
   
    
    _sprite.size=tamanho;
    
    self.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.categoryBitMask = PRESSAO;
    self.physicsBody.collisionBitMask = GOTA|ENEMY;
    self.physicsBody.contactTestBitMask = GOTA |ENEMY;
    
//    self.sprite.colorBlendFactor=1.10;

    self.name=@"pressao";
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    _pressionado=FALSE;
    
    _tipo=tipo;
    //Tipo 1 pisa e fica normal 2 depois de um tempo libera
    //tipo 3 tem que ser precionado constantemente

    return self;
}

-(void)criarParede:(SKSpriteNode *)sprite withPosition:(CGPoint)ponto {
    
}

-(void)pisar{
    if(!_pressionado){
        
        _pressionado=true;
        }else{

        _pressionado=false;
    }
    
        [self animar:!_pressionado];
   }


-(BOOL)pisado:(NSMutableArray *)personagens{
    for (int i=0; i<personagens.count; i++) {
        JAGCharacter *obj=(JAGCharacter *)personagens[i];
        if((obj.position.x >= (self.position.x - self.sprite.size.width/2)) && ((obj.position.x < (self.position.x+self.sprite.size.width/2)))){
            if((obj.position.y >= (self.position.y - self.sprite.size.height/2)) && ((obj.position.y < (self.position.y+self.sprite.size.height/2)))){
                //Continuar pisado
                //[self pressionar:true];
                return true;
            }
        }
    }
    //Liberar
    [self pressionar:true];
    return false;
}

-(void)pressionar:(BOOL)pressao{
    if(_pressionado!=pressao){
        if(pressao){
            _pressionado=true;
            
            }else{
            _pressionado=false;
        }
         [self animar:!_pressionado];
    }
}

-(void)animar:(BOOL)anima{
    if(!anima){
        
        if (self.tipo==1) {
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao2"]];
        }else if (_tipo==2){
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao2_2"]];
        }else if (_tipo==3){
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao3_2"]];

        }
        
    }else{
      
       
        if (self.tipo==1) {
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao1"]];

        }else if (_tipo==2){
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao2_1"]];
        }else if (_tipo==3){
            [self.sprite setTexture:[SKTexture textureWithImageNamed:@"botao3_1"]];
        }

    }
//    [self.sprite runAction:actionChangeSprite];

}


@end
