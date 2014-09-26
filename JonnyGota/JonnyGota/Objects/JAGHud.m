//
//  JAGHud.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGHud.h"

@implementation JAGHud

-(instancetype)initWithTempo:(int)tempo withVida:(int)vida saude:(float)saude withWindowSize:(CGSize)size{
    self= [super init];
    SKTexture *textura =[SKTexture textureWithImageNamed:@"hud_back.png"];
    _saude_sprites = [[NSMutableArray alloc] init];
    for (int i =0; i<=8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"vida%d",i];
        textura = [SKTexture textureWithImageNamed:textureName];
        _saude_sprites[i] = textura;
    }
    
    
    textura =[SKTexture textureWithImageNamed:@"hud_back.png"];
    
    _back = [[SKSpriteNode alloc]init];
    _back.texture =textura;
    _back.position = CGPointMake(size.width*0.01, size.height*.96);
    _back.size = CGSizeMake(size.width*2, size.height*.08);
    
    textura = [SKTexture textureWithImageNamed:@"heart.png"];
    _heart = [[SKSpriteNode alloc] init];
    _heart.texture = textura;
    _heart.position = CGPointMake(size.width*0.23, size.height*0.965);
    _heart.size = CGSizeMake(size.width*.05, size.height*.08);
    
    textura = [SKTexture textureWithImageNamed:@"clock.png"];
    _clock = [[SKSpriteNode alloc] init];
    _clock.texture = textura;
    _clock.position = CGPointMake(size.width*0.42, size.height*0.956);
    _clock.size = CGSizeMake(size.width*.05, size.height*.068);
    
    _life = [[SKSpriteNode alloc]init];
    _life.texture = _saude_sprites[0];
    _life.position = CGPointMake(size.width*0.88, size.height*0.955);
    _life.size = CGSizeMake(size.width*.15, size.height*.05);

    
    _pauseBT = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)];
    _pauseBT.position = CGPointMake(size.width*0.11, size.height*0.96);
    _pauseBT.name = @"pauseBT";
    _tempoRestante=tempo;
    _vidaRestante=vida;
    
    NSString *fonte=@"AvenirNext-Bold";
    
    _vidas=[[SKLabelNode alloc] initWithFontNamed:fonte];
    _vidas.fontSize = size.height*0.05;
    _vidas.position=CGPointMake(size.width*0.29, size.height*0.94);
    
    
    _tempo=[[SKLabelNode alloc] initWithFontNamed:fonte];
    _tempo.text=[NSString stringWithFormat:@"%ds",_tempoRestante];
    _tempo.fontSize = size.height*0.05;
    _tempo.position=CGPointMake(size.width*0.5, size.height*0.94);
    
    _saude=[[SKLabelNode alloc]initWithFontNamed:fonte];
    _saude.text=[NSString stringWithFormat:@"saúde: %d", _gota.vida];
    _saude.fontSize = size.height*0.05;
    _saude.position=CGPointMake(size.width*0.73, size.height*0.94);
    
    [self addChild:_back];
    [self addChild:_heart];
    [self addChild:_clock];
    [self addChild:_life];
    [self addChild:_vidas];
    [self addChild:_tempo];
    [self addChild:_saude];
    [self addChild:_pauseBT];
    self.zPosition = 100;
    return self;
}

-(void)update{
    _tempo.text=[NSString stringWithFormat:@"%ds",_tempoRestante];
    
    _vidas.text=[NSString stringWithFormat:@" x %d",_vidaRestante];
    
    _saude.text=[NSString stringWithFormat:@"saúde: " ];
    if (_gota.vida<=1){ _life.texture = _saude_sprites[0];
        SKSpriteNode *red = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:_life.size];
        red.position = _life.position;
        red.alpha = 0.9;
//        [self addChild:red];
        [red runAction:[SKAction repeatActionForever:[SKAction fadeAlphaTo:0.5 duration:2]]completion:^{
            [red runAction:[SKAction fadeAlphaTo:.9 duration:2]];
        }];
        
        
        
        
    }
 
   else if (_gota.vida<=2) _life.texture = _saude_sprites[1];
    
   else if (_gota.vida<=3) _life.texture = _saude_sprites[2];
   
   else if (_gota.vida<=5) _life.texture = _saude_sprites[3];
   
   else if (_gota.vida<=7) _life.texture = _saude_sprites[4];
   
   else if (_gota.vida<=9) _life.texture = _saude_sprites[5];
   
   else if (_gota.vida<=11)_life.texture = _saude_sprites[6];
   
   else if (_gota.vida<=13){_life.texture = _saude_sprites[7];
       SKSpriteNode *red = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:_life.size];
       red.position = _life.position;
       red.alpha = 0.9;
//       [self addChild:red];
       [red runAction:[SKAction repeatActionForever:[SKAction fadeAlphaTo:0 duration:2]]completion:^{
           [red runAction:[SKAction fadeAlphaTo:.9 duration:2]];
       }];}
   else if (_gota.vida<=15)_life.texture = _saude_sprites[8];
  //  NSLog(@"gota %s",_gota);
}

-(void)cronometro{
    
    if(!self.paused){
        if(_tempoRestante>0){
            _tempoRestante--;
            [self update];
        }
    }
    
    [self update];
}

-(void)startTimer{
    
    SKAction *timer=[SKAction sequence:@[[SKAction waitForDuration:1],
                                         [SKAction runBlock:^{
        [self cronometro];
    }]]];
    
    SKAction *runs=[SKAction repeatAction:timer count:self.tempoRestante];
    [self runAction:runs];
}
@end
