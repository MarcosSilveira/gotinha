//
//  JAGLevelSelectionScene.m
//  JonnyGota
//
//  Created by Marcos Sokolowski on 26/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGLevelSelectionScene.h"
#import "JAGPlayGameScene.h"
#import "JAGCreatorLevels.h"

@implementation JAGLevelSelectionScene{
    SKSpriteNode *background;
}

-(void)didMoveToView:(SKView *)view{
    
    
    
    
    background = [[SKSpriteNode alloc]initWithImageNamed:@"levelSelectBG"];
    background.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    background.size = self.frame.size;
    background.zPosition = 0;
    
    NSNumber *fases =  [JAGCreatorLevels numberOfLevels:1];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"faseAtual"]== nil) {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"faseAtual"];
    }
    
    NSInteger faseAtual = [[NSUserDefaults standardUserDefaults] integerForKey:@"faseAtual"];
    float posXInicial = self.frame.size.width*0.2;
    float posYInicial = self.frame.size.height*0.68;
    float posX = posXInicial;
    float posY = posYInicial;
    float somaX = self.frame.size.width*0.103;
    float somaY = self.frame.size.height*0.18;
    
    
    for (int i=1; i<=[fases intValue]; i++) {
        
        
        SKSpriteNode *nodo;
        NSString *nome = [[NSString alloc]initWithFormat:@"fase_semSombra%d",i];
        if (i>faseAtual) {
            nodo = [[SKSpriteNode alloc]initWithImageNamed:@"travada_semSombra"];
            nodo.size = CGSizeMake(self.frame.size.width*.1, self.frame.size.height*.16);
            nodo.name = @"fase_trancada";
            
        }
        else{
//            nodo=[[SKSpriteNode alloc]initWithImageNamed:nome];
            
            nodo=[[SKSpriteNode alloc] initWithImageNamed:@"levelX"];
            
            SKLabelNode *labelNum=[[SKLabelNode alloc] initWithFontNamed:@"VAGRoundedStd-thin"];
            
            
            //Setar um font size baseada na tela
            labelNum.fontSize=24;
            
            labelNum.text=[NSString stringWithFormat:@"%d",i];
            
            
            [nodo addChild:labelNum];
            
            
            nodo.size = CGSizeMake(self.frame.size.width*.1, self.frame.size.height*.16);
            
            labelNum.position=CGPointMake(-nodo.size.width/8, -5);
            

        
            

            nodo.name = [NSString stringWithFormat:@"%d",i];
            nodo.zPosition = 200;
        }
        posX = posX+somaX;
        
        //posY = posY*1.2;
        nodo.position = CGPointMake(posX,posY);
        if (nodo.position.x >= self.frame.size.width*0.7) {
            posX = posXInicial;
            posY = posY-somaY;
        }
        nodo.zPosition = 1;
        [self.scene addChild:nodo];
    }
    
    [self.scene addChild:background];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    JAGPlayGameScene *jogo;
    for (UITouch *touch in touches) {
        SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
        
        if (![node.name isEqualToString:@"fase_trancada"]) {
            int fase = [node.name intValue];
            NSNumber *faseA = [NSNumber numberWithInt:fase];
            if (fase!=0) {
                jogo = [[JAGPlayGameScene alloc]initWithSize:self.frame.size level:faseA andWorld:@1];
                [self.scene.view presentScene:jogo transition:[SKTransition fadeWithDuration:1]];}}
    }
}
























@end
