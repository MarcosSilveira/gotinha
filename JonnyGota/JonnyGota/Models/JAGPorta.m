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

static NSMutableArray *animation;

static NSMutableArray *animationReverse;

static SKTextureAtlas *atlas;

-(instancetype)initWithPosition:(CGPoint)ponto
                  withDirection:(int)direction
                    withReverse:(BOOL) reverse
                       withTipo:(int) tipo
                       withSize:(CGSize) size{
    self=[super init];
    
    self.reverse=reverse;

    
    if(animation==nil){
        animation=[[NSMutableArray alloc] init];
        animationReverse=[[NSMutableArray alloc] init];
        atlas  = [SKTextureAtlas atlasNamed:@"porta.atlas"];
        [self loadArrays];
        
    }
    
    [self defineSprite:direction withSize:size];
    [self addChild:_sprite];
    
    self.position=ponto;
    
    self.tipo=tipo;
    
    
    self.name=@"porta";

    [self configPhysicsBody];
    
    _aberta=FALSE;
    
    self.direction=direction;

    
    _pressoes=[[NSMutableArray alloc] init];
    
      return self;
}

-(void)configPhysicsBody{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sprite.size];
    
    self.physicsBody.dynamic=NO;
    
    self.physicsBody.restitution=0.0;
    
    
    self.physicsBody.categoryBitMask = PORTA;
    self.physicsBody.collisionBitMask = GOTA |ENEMY;
    self.physicsBody.contactTestBitMask = GOTA;

}

-(void)verificarBotoes{
    bool temp=true;
    for (int i=0; i<_pressoes.count; i++) {
        JAGPressao *obj=_pressoes[i];
        if(!obj.pressionado){
            temp=false;
        }
    }
    
    [self abrir:temp];
    
    if (temp) {
        //Se aberta animar
        
    }else{
        
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
            [self animarAbrir];
            //Animar
        }else{
            _aberta=false;
            [self configPhysicsBody];
            [self animarFechar];
            
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

-(void)defineSprite:(int) dire withSize:(CGSize) size{
    
    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];
    
    //1 Cima e baixo 3 esquerda 4 direita
    if (dire==1) {
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
    }else if(dire==2){
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        self.sprite.yScale=-1.0;
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
    }else if (dire==3){
        //Rotacionar
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        self.sprite.xScale=-1.0;
        if(self.reverse){
            self.sprite.yScale=-1.0;
        }
    }else{
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        if(self.reverse){
            self.sprite.yScale=-1.0;
        }
    }
}

-(void)loadArrays{
    for (int i=1; i<=5; i++) {
        NSString *textureName = [NSString stringWithFormat:@"porta000%d.png", i];
        [animation addObject:[atlas textureNamed:textureName]];
        int k=6-i;
        NSString *textureName2 = [NSString stringWithFormat:@"porta000%d.png", k];
        [animationReverse addObject:[atlas textureNamed:textureName2]];
    }
}

-(void)animarAbrir{
    if (self.direction==1) {
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animation timePerFrame:0.1f]];
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
//        [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.animation timePerFrame:0.1f]]withKey:@"walkingBack"];

    }else if(self.direction==2){
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animation timePerFrame:0.1f]];
        self.sprite.yScale=-1.0;
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
    }else if (self.direction==3){
        //Rotacionar
        
        //Do fim pro inicio aqui
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animationReverse timePerFrame:0.1f]];
        self.sprite.xScale=-1.0;
        if (self.reverse) {
            self.sprite.yScale=-1.0;
        }
    }else{
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animationReverse timePerFrame:0.1f]];
        self.sprite.xScale=-1.0;
        if (self.reverse) {
            self.sprite.yScale=-1.0;
        }
    }
}

-(void)animarFechar{
    if (self.direction==1) {
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animationReverse timePerFrame:0.1f]];
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
        //        [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.animation timePerFrame:0.1f]]withKey:@"walkingBack"];
        
    }else if(self.direction==2){
        self.sprite.texture = [atlas textureNamed:@"porta0005.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animationReverse timePerFrame:0.1f]];
        self.sprite.yScale=-1.0;
        if (self.reverse) {
            self.sprite.xScale=-1.0;
        }
    }else if (self.direction==3){
        //Rotacionar
        
        //Do fim pro inicio aqui
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animation timePerFrame:0.1f]];
        self.sprite.xScale=-1.0;
        if (self.reverse) {
            self.sprite.yScale=-1.0;
        }
    }else{
        self.sprite.texture = [atlas textureNamed:@"porta0001.png"];
        [self.sprite runAction:[SKAction animateWithTextures:animation timePerFrame:0.1f]];
        self.sprite.xScale=-1.0;
        if (self.reverse) {
            self.sprite.yScale=-1.0;
        }
    }

}

@end
