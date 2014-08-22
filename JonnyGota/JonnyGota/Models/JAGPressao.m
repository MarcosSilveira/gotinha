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

-(instancetype)initWithPosition:(CGPoint)ponto withTipo:(int)tipo{
    self=[super init];
    
    _sprite=[[SKSpriteNode alloc] initWithColor:[SKColor cyanColor] size:CGSizeMake(32,32)];
    
    self.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.categoryBitMask = PRESSAO;
    self.physicsBody.collisionBitMask = GOTA|ENEMY;
    self.physicsBody.contactTestBitMask = GOTA |ENEMY;

    self.name=@"pressao";
    
    [self addChild:_sprite];
    
    self.position=ponto;
    
    _presionado=FALSE;
    
    _tipo=tipo;
    
    //Tipo 1 pisa e fica normal 2 depois de um tempo libera
    //tipo 3 tem que ser precionado constantemente
    return self;
}

-(void)criarParede:(SKSpriteNode *)sprite withPosition:(CGPoint)ponto {
    
}

-(void)pisar{
    if(!_presionado){
        _presionado=true;
        }else{
        _presionado=false;
    }
    [self animar:!_presionado];
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
    if(_presionado!=pressao){
        if(pressao){
            _presionado=true;
            
            }else{
            _presionado=false;
        }
    }
    [self animar:_presionado];
}

-(void)animar:(BOOL)anima{
    SKAction *actionChangeSprite;
    if(!anima){
               actionChangeSprite = [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.0];
        
    }else{
      
        actionChangeSprite = [SKAction colorizeWithColor:[SKColor cyanColor] colorBlendFactor:1.0 duration:0.0];
        
    }
    [self.sprite runAction:actionChangeSprite];

}


@end
