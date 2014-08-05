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
        
        
        //Logica do invisivel
        //Tempo de pressao
        
        
    }
}

-(void)update:(NSTimeInterval)currentTime{
    
    //depois de um tempo? ou acao
    [_hud update];
}


@end
