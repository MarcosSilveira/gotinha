//
//  JAGGota.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGGota.h"
#import "JAGMusicAction.h"

@implementation JAGGota


-(id)initWithPosition:(CGPoint)position withSize:(CGSize)size{
    
    self = [super init];
    self.name = @"gota";
    self.position = position;
    
    //textures load
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"super gotinha"]){
        self.atlas  = [SKTextureAtlas atlasNamed:@"gotinha.atlas"];
        self.sprite.texture = [self.atlas textureNamed:@"gotinha_correndo_frente1@2x.png"];
        self.sprite.zPosition=10;
        self.sprite.name = @"gota";
        self.idleTexture = [self.atlas textureNamed:@"gotinha_correndo_frente1@2x.png"];
        
        for (int i=1; i<=9; i++) {
            NSString *textureName = [NSString stringWithFormat:@"gotinha_correndo_frente%d@2x.png", i];
            [self.walkTexturesFront addObject:[self.atlas textureNamed:textureName]];
        }
        for (int i=1; i<=9; i++) {
            NSString *textureName = [NSString stringWithFormat:@"gotinha_correndo_costa%d@2x.png", i];
            [self.walkTexturesBack addObject:[self.atlas textureNamed:textureName]];
        }
        for (int i=1; i<=7; i++) {
            NSString *textureName = [NSString stringWithFormat:@"gotinha_correndo_lado%d@2x.png", i];
            [self.walkTexturesSide addObject:[self.atlas textureNamed:textureName]];
        }
}
    else{
        self.atlas  = [SKTextureAtlas atlasNamed:@"super_gotinha.atlas"];
        self.sprite.texture = [self.atlas textureNamed:@"super_gotinha_frente1.png"];
        self.sprite.zPosition=10;
        self.sprite.name = @"gota";
        self.idleTexture = [self.atlas textureNamed:@"super_gotinha_frente1.png"];
        
        for (int i=1; i<=8; i++) {
            NSString *textureName = [NSString stringWithFormat:@"super_gotinha_frente%d.png", i];
            [self.walkTexturesFront addObject:[self.atlas textureNamed:textureName]];
        }
        for (int i=1; i<=8; i++) {
            NSString *textureName = [NSString stringWithFormat:@"super_gotinha_costas%d.png", i];
            [self.walkTexturesBack addObject:[self.atlas textureNamed:textureName]];
        }
        for (int i=1; i<=8; i++) {
            NSString *textureName = [NSString stringWithFormat:@"super_gotinha_lado%d.png", i];
            [self.walkTexturesSide addObject:[self.atlas textureNamed:textureName]];
        }

    }


    self.sprite = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:size];

        [self addChild:self.sprite];

    self.sprite.size=size;

    
    //variaveis de controle
    _escondida = NO;
    _dividida = NO;
    _emContatoFonte = NO;
    _comChave = NO;
    _aguaRestante = 10;
    
    if (size.width>100) {
        self.multi = (size.width)/2.2;

    }else{
        self.multi = (size.width)/6;
    }
    
    self.gotinhas=[[NSMutableArray alloc] init];
    self.qtGotinhas=2;
    
    [self loadSound];
    
    
    self.zPosition=500;

    
    return self;
}

-(void)loadSound{
    //Musicas
    self.andarM=[[JAGMusicAction alloc] init];
}

-(void)removeActionWithSound{
    [self.andarM stop];
    [self.sprite removeAllActions];
}

-(void)playAndar{
    
}

-(void)soltar{
    [self.andarM soltar];
}

-(void)addPhysics{
    //physics body config
    self.physicsBody.friction = 0;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.sprite.size.width*0.6, self.sprite.size.height*0.6)];
    //self.zPosition = 1;
    self.physicsBody.restitution=0;
    self.physicsBody.categoryBitMask = GOTA;
    self.physicsBody.collisionBitMask = ATTACK | ENEMY |ITEM |PORTA | CHUVA | CHAVE |PAREDE;
    self.physicsBody.contactTestBitMask = ATTACK | ENEMY | CONTROLE_TOQUE |ITEM | CHUVA |CHAVE | FONTE_DA_JUVENTUDE | PAREDE | TRAP|DIVIDIDA;
    [self configPhysics];  //herdado de character
//    self.physicsBody.usesPreciseCollisionDetection=NO;

}

-(void)esconder{
    SKAction *pocaAction;
    pocaAction = [SKAction scaleYTo:-.5 duration:1.0];
    if (_escondida == NO) {
        _escondida = YES;
//        [self runAction:pocaAction];
        self.sprite.texture = [SKTexture textureWithImageNamed:@"poca.png"];
    }
    else if (_escondida){
        pocaAction = [SKAction sequence:@[[SKAction scaleYTo:+1 duration:1.0], [SKAction waitForDuration:0.3], [SKAction runBlock:^{
            _escondida = NO;
        }]]];   
        
//        [self runAction:pocaAction];
        self.sprite.texture = self.idleTexture;
        _escondida = NO;
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
    
//    if (self.gotinhas.count>self.qtGotinhas) {
//        JAGGotaDividida *temp=(JAGGotaDividida *)self.gotinhas[0];
//        
//        [temp removeAllActions];
//        temp.physicsBody=nil;
//        [temp removeFromParent];
//        [self.gotinhas removeObject:temp];
//        
//        temp=nil;
//    }
    
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

-(void)mover:(CGPoint)ponto withInterval :(NSTimeInterval)time withType:(int)tipo {
    
    // tipo: 1 = Cima 2 = Baixo 3 = Esquerda 4 = Direita
    
    
    // [self removeAllActions];
    
    self.physicsBody.velocity = CGVectorMake(0, 0);
    
   
    
    [self.andarM play];
    
    
    
    switch (tipo) {
        case 1:
            
            [self.physicsBody applyImpulse:CGVectorMake(0,self.multi)];
            
            [self.sprite runAction:[SKAction repeatActionForever:
                                    [SKAction sequence:@[[SKAction animateWithTextures:self.walkTexturesBack timePerFrame:0.1f]]]]withKey:@"walkingBack"];
            //                self.sprite.xScale = 1.0;
            
            
            break;
            
        case 2:
            
            [self.physicsBody applyImpulse:CGVectorMake(0, - self.multi)];
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesFront timePerFrame:0.1f]]withKey:@"walkingFront"];
            //                self.sprite.xScale = 1.0;
            
            
            break;
            
        case 3:
            
            [self.physicsBody applyImpulse:CGVectorMake(- self.multi,0)];
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesSide timePerFrame:0.1f]]withKey:@"walkingSide"];
            self.sprite.xScale = -1.0;
            
            
            break;
            
        case 4:
            
            [self.physicsBody applyImpulse:CGVectorMake(self.multi,0)];
            [self.sprite runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.walkTexturesSide timePerFrame:0.1f]]withKey:@"walkingSide"];
            self.sprite.xScale = 1.0;
            
            
            break;
            
        default:
            break;
    }
    
    
    
    
    //Mover em 2 passos para diagonal?
    
    
    
    
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
