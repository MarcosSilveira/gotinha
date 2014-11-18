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
#import "JAGMenu.h"
#import "JAGVida.h"

@implementation JAGLevelSelectionScene{
    SKSpriteNode *background;
    SKSpriteNode *vidas_sprite;
    SKLabelNode *vidas_quantidade;
    int vidas_diferenca_tempo_depois;
    int vidas_diferenca_tempo_antes;
    int vidas_restantes;
    bool vidas_carregando;
    bool sincronizado;
    NSDate * stopDate;
    NSString *stopDate_string;
    SKSpriteNode *backBT;
    JAGVida *vida;
    SKSpriteNode *gamepad;
    SKSpriteNode *check;
}

-(void)didMoveToView:(SKView *)view{
    [self verificaDefaults];
    
//    vida=[[JAGVida alloc] init];
    
    vida=[JAGVida sharedManager];
    
    
    vidas_sprite = [[SKSpriteNode alloc] initWithImageNamed:@"heart_sem_sombra.png"];
    vidas_sprite.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.89);
    vidas_sprite.size = CGSizeMake(self.frame.size.width*0.06, self.frame.size.height*0.075);
    background = [[SKSpriteNode alloc]initWithImageNamed:@"levelSelectBG"];
    background.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    background.size = self.frame.size;
    background.zPosition = 0;
    vidas_quantidade = [[SKLabelNode alloc]initWithFontNamed:@"VAGRoundedStd-Bold"];
//    vidas_quantidade.text = [NSString stringWithFormat:@" X %d",vidas_restantes];
    vidas_quantidade.text = [NSString stringWithFormat:@" X %ld",(long)vida.vidas];

    vidas_quantidade.position = CGPointMake(self.frame.size.width*0.87, self.frame.size.height*0.86);
    vidas_quantidade.fontSize = self.frame.size.width*0.05;
    backBT =[[SKSpriteNode alloc]initWithImageNamed:@"btBack"];
    backBT.zRotation = M_PI;
    backBT.position = CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.9);
    backBT.size = CGSizeMake(self.frame.size.width*0.08, self.frame.size.width*0.08);
    backBT.zPosition = 2;
    backBT.name = @"btBack";
    gamepad=[[SKSpriteNode alloc] initWithImageNamed:@"gamePad"];
    
    gamepad.size=CGSizeMake(self.frame.size.width*0.15, self.frame.size.height*0.2);
    
    gamepad.position=CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.58);
    
    gamepad.name=@"gamePad";
    
    
    [self.scene addChild:backBT];
    [self organizaBotoes];
    
    [self addChild:gamepad];
    
    [self addCheck];
}

-(void)addCheck{
    if (check!=nil) {
        [check removeFromParent];
    }
    
    if (vida.gamePad) {
        check=[[SKSpriteNode alloc] initWithImageNamed:@"check"];
    }else{
        check=[[SKSpriteNode alloc] initWithImageNamed:@"noCheck"];
    }
    
    check.size=CGSizeMake(self.frame.size.width*0.09, self.frame.size.height*0.15);
    
    check.position=CGPointMake(self.frame.size.width*0.1, self.frame.size.height*0.38);
    
    check.name=@"check";
    
    [self addChild:check];

}
-(void)update:(NSTimeInterval)currentTime{
//    [self recuperaVida];
    
    
//    vidas_quantidade.text = [NSString stringWithFormat:@" x %d",vidas_restantes];
    vidas_quantidade.text = [NSString stringWithFormat:@" X %ld",(long)vida.vidas];

}
-(void)verificaDefaults{
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"vidas_restantes"]==nil){
//        [[NSUserDefaults standardUserDefaults]setInteger:5 forKey:@"vidas_restantes"];
//        [[NSUserDefaults standardUserDefaults]setFloat:0 forKey:@"tempo_para_vida"];
//    }
//    vidas_restantes = [[NSUserDefaults standardUserDefaults]integerForKey:@"vidas_restantes"];
//    if(vidas_restantes<5){
//        NSDate *dataSalva = [[NSUserDefaults standardUserDefaults]objectForKey:@"tempo_para_vida"];
//        NSDate *now = [NSDate date];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        NSString *after_string = [dateFormatter stringFromDate:now];
//        NSString *data_salva_string = [dateFormatter stringFromDate:dataSalva];
//        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR_POSIX"]];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        
//        NSDate* firstDate = [dateFormatter dateFromString:data_salva_string];
//        NSDate* secondDate = [dateFormatter dateFromString:after_string];
//        
//        NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
//        
//        if (timeDifference>=0) {
//            vidas_restantes++;
//            if(timeDifference>=30){
//                vidas_restantes++;
//                if (timeDifference>=90) {
//                    vidas_restantes++;
//                    if (timeDifference>=120) {
//                        vidas_restantes++;
//                    }
//                }
//            }
//        
//            
////            NSLog(@"Diferença apos ligar: %f",timeDifference);
//        }
//    }
    
}
-(void)recuperaVida{
//        if (vidas_restantes<5 && !vidas_carregando) {
//        stopDate = [NSDate dateWithTimeIntervalSinceNow:30];
//        [[NSUserDefaults standardUserDefaults] setObject:stopDate forKey:@"tempo_para_vida"];
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        [outputFormatter setDateFormat:@"HH:mm:ss"];
//        stopDate_string= [outputFormatter stringFromDate:stopDate];
//        vidas_carregando = !vidas_carregando;
//    }
//    
//    if (vidas_restantes<5 && vidas_carregando) {
//        NSDate *after = [NSDate date];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        NSString *after_string = [dateFormatter stringFromDate:after];
//        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR_POSIX"]];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        
//        NSDate* firstDate = [dateFormatter dateFromString:stopDate_string];
//        NSDate* secondDate = [dateFormatter dateFromString:after_string];
//        
//        NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
//        if (!sincronizado) {
//            vidas_diferenca_tempo_antes = timeDifference;
//            sincronizado = YES;
//        }
//
////        NSLog(@"diferenca: %f",timeDifference);
//        [[NSUserDefaults standardUserDefaults]setObject:stopDate forKey:@"tempo_para_vida"];
//        [[NSUserDefaults standardUserDefaults]setFloat:timeDifference forKey:@"ultimo_tempo"];
//        if (timeDifference>=0) {
//            vidas_restantes++;
//            [[NSUserDefaults standardUserDefaults]setInteger:vidas_restantes forKey:@"vidas_restantes"];
//            vidas_carregando = NO;
//        }
//        
//        if (vidas_restantes>=5) {
//            vidas_carregando = NO;
//        }
//
//
//    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    JAGPlayGameScene *jogo;
    for (UITouch *touch in touches) {
        SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
        if ([node.name isEqualToString:@"btBack"]) {
            JAGMenu* menu = [[JAGMenu alloc]initWithSize:self.frame.size];
            [self.scene.view presentScene:menu transition:[SKTransition fadeWithDuration:1]];
        }
        if (![node.name isEqualToString:@"fase_trancada"]) {
            int fase = [node.name intValue];
            NSNumber *faseA = [NSNumber numberWithInt:fase];
            
            //            if (fase!=0 && vidas_restantes>0) {
            if (fase!=0 && vida.vidas>0) {
                jogo = [[JAGPlayGameScene alloc]initWithSize:self.frame.size level:faseA andWorld:@1];
                [self.scene.view presentScene:jogo transition:[SKTransition fadeWithDuration:1]];
            }
        }
        
        if ([node.name isEqualToString:@"gamePad"]||[node.name isEqualToString:@"check"]) {
            [vida changeGamepad];
            [self addCheck];
        }
    }
    

}




-(void)organizaBotoes{
    
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
            
            nodo=[[SKSpriteNode alloc] initWithImageNamed:@"lvlX"];
            
            SKLabelNode *labelNum=[[SKLabelNode alloc] initWithFontNamed:@"VAGRoundedStd-Bold"];
            
           
            //Setar um font size baseada na tela
            labelNum.fontSize=self.frame.size.height*0.1;
            
            labelNum.text=[NSString stringWithFormat:@"%d",i];
            
            labelNum.name=[NSString stringWithFormat:@"%d",i];
            
            
            [nodo addChild:labelNum];
            
            
            nodo.size = CGSizeMake(self.frame.size.width*.1, self.frame.size.height*.16);
            
            labelNum.position=CGPointMake(-nodo.size.width*0.03, self.frame.size.height*-0.04);
            
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
    [self.scene addChild:vidas_sprite];
    [self.scene addChild:vidas_quantidade];
}





















@end
