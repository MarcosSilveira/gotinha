//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"

@implementation JAGPlayGameScene

float timeTouch;

CGPoint locations;

float diferenca=80;


-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
       // self.physicsWorld.contactDelegate = self;
         self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _gota= [[JAGGota alloc] initWithPosition:CGPointMake(100, 100)];
        
        [self addChild:_gota];
        //_boing = [SKAction playSoundFileNamed:@"boing.mp3" waitForCompletion:NO];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        locations = [touch locationInNode:self];
        
        
        timeTouch=touch.timestamp;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        
        //Logica da movimentacao
        //PathFinder
        //
        
        
        //logica da divisao
        //Condicaos de diferenca dos pontos
        if(locations.x-location.x<diferenca*-1){
                //Lado direito ?
            [_gota mover:location withInterval:1.0];
            
            break;
        }else{
            if(locations.x-location.x<diferenca){
                //lado esquerdo ?
                
                [_gota mover:location withInterval:1.0];
                break;
            }
        }
        if(locations.y-location.y<diferenca*-1){
            //pra Cima ?
            
            [_gota mover:location withInterval:1.0];
            break;
        }else{
            if(locations.y-location.y<diferenca){
                //pra baixo ?
                
                
                [_gota mover:location withInterval:1.0];
                break;
            }
        }
        
        
        //Logica do invisivel
        //Tempo de pressao
        
        
    }
}

-(void)update:(NSTimeInterval)currentTime{
    
    //depois de um tempo? ou acao
    [_hud update];
}


@end
