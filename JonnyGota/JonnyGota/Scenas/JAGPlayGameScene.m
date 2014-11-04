//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"
#import "JAGLevel.h"
#import "JAGCreatorLevels.h"
#import "JAGObjeto.h"
#import "JAGPressao.h"
#import "JAGPerdaGota.h"
#import "JAGPerdaFogo.h"
#import "JAGChave.h"
#import "JAGTrap.h"
#import "JAGMenu.h"
#import <AVFoundation/AVFoundation.h>

@implementation JAGPlayGameScene {
    
    float width;   //largura da tela
    float height;  //altura da tela
    CGPoint toqueInicio;   //ponto inicial do toque
    SKShapeNode *circleMask;  //circulo da mascara
    CGPoint toqueFinal;  //ponto final do toque
    BOOL tocou_gota;     //gota foi tocada?
    BOOL toque_moveu;    //toque mudou de posição?
    SKShapeNode *lineNode;
    SKNode *area;     //area da máscara
    SKSpriteNode *pararMovimentoCONTROLx;  //nodo para colisão e parada do movimento da gota em x
    SKSpriteNode *pararMovimentoCONTROLy;   //nodo para colisão e parada da gota em y
    BOOL controleXnaTela;   //controle para verificar se nodo de parada da gota x está na tela
    BOOL controleYnaTela;   //controle para verificar se nodo de parada da gota y está na tela
    BOOL pauseDetected;     //jogo pausado?
    JAGChave* chave;        //item chave
    Musica *relampago;
    bool frenetico;
    BOOL GONaTela;
    
    
}

#pragma mark - View Initialization
-(void)didMoveToView:(SKView *)view{
    
    self.physicsWorld.contactDelegate = (id)self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    _message2 =[[SKLabelNode alloc]initWithFontNamed:@"AvenirNext-Bold"];
    _message2.fontSize = self.frame.size.height*0.1;
    _message2.text = @"Game Paused";
    _message2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.6);
    _message2.alpha = 0;
//    _message2.zPosition = 999;
    [self.camadaPersonagens addChild:_message2];
    [self touchesEnded:nil withEvent:nil];


}
-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        pauseDetected =NO;
        atlas = [SKTextureAtlas atlasNamed:@"gotinha"];
        self.physicsWorld.contactDelegate = self;
        
        if (level != nil && world != nil) {
            self.currentLevel = level;
            self.currentWorld = world;
        }
        else {
            NSLog(@"Level and World not set");
            self.currentLevel = @(1);
            self.currentWorld = @(1);
        }
        [JAGCreatorLevels initializeLevel:self.currentLevel ofWorld:self.currentWorld onScene:self];
        
        tocou_gota = false;
       
        width = self.scene.size.width;
        height = self.scene.size.height;
        [self configuraParadaGota];
    }
    [self fadeMask];
    self.cropNode.alpha = 0.9f;
    GONaTela = NO;

    return self;
}

-(void)presentGameOver:(int)withOP{
    /* Configuração e apresentação da popup de game over
     OP é utilizado para definir a situação atual, em cada caso, os botões da popup serão
     mostrados de formas diferentes e serão atribuidos a ações diferentes.
     A situações podem ser:
     -Fim de fase ganhando - 1
     -Fim de fase perdendo com vida restante - 0
     -Fim de fase perdendo sem vida restante - 2*/
    if (withOP == 0) {
        
        
        GObackground = [[SKSpriteNode alloc]initWithImageNamed:@"GOBackground"];
        GObackground.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        button1 = [[SKSpriteNode alloc] initWithImageNamed:@"comprarVidas"];
        button1.size = CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button1.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.4);
        button2 = [[SKSpriteNode alloc] initWithImageNamed:@"menuInicial"];
        button2.size =CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.2);
        button1.name = @"reiniciar fase";
        button2.name = @"menu inicial";
        message =[[SKLabelNode alloc]initWithFontNamed:@"AvenirNext-Bold"];
        message.fontSize = self.frame.size.height*0.1;
        message.text = @"Fim de jogo!";
        message.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.6);
        [self.scene addChild:GObackground];
        [self.scene addChild:message];
        [self.scene addChild:button1];
        [self.scene addChild:button2];
        button1.zPosition = 201;
        button2.zPosition = 201;
        GObackground.zPosition = 200;
        message.zPosition = 201;
    }
    if (withOP == 1) {
        
        GObackground = [[SKSpriteNode alloc]initWithImageNamed:@"GOBackground"];
        GObackground.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        button1 = [[SKSpriteNode alloc] initWithImageNamed:@"proxima_fase"];
        button1.size = CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button1.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.4);
        button2 = [[SKSpriteNode alloc] initWithImageNamed:@"menuInicial"];
        button2.size =CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.2);
        button1.name = @"proxima fase";
        button2.name = @"menu inicial";
        message =[[SKLabelNode alloc]initWithFontNamed:@"AvenirNext-Bold"];
        message.fontSize = self.frame.size.height*0.07;
        message.text = @"Parabéns! Você avançou para a próxima fase!";
        message.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.6);
        [self.scene addChild:GObackground];
        [self.scene addChild:message];
        [self.scene addChild:button1];
        [self.scene addChild:button2];
        button1.zPosition = 201;
        button2.zPosition = 201;
        GObackground.zPosition = 200;
        message.zPosition = 201;
        
        
        
    }
    if (withOP == 2) {
        
        GObackground = [[SKSpriteNode alloc]initWithImageNamed:@"GOBackground"];
        GObackground.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        button1 = [[SKSpriteNode alloc] initWithImageNamed:@"store"];
        button1.size = CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button1.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.4);
        button2 = [[SKSpriteNode alloc] initWithImageNamed:@"menuInicial"];
        button2.size =CGSizeMake(self.frame.size.width * .24, self.frame.size.height * .13);
        button2.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.2);
        button1.name = @"store";
        button2.name = @"menu inicial";
        message =[[SKLabelNode alloc]initWithFontNamed:@"AvenirNext-Bold"];
        message.fontSize = self.frame.size.height*0.07;
        message.text = @"Você não possui mais vidas ):";
        message.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.6);
        [self.scene addChild:GObackground];
        [self.scene addChild:message];
        [self.scene addChild:button1];
        [self.scene addChild:button2];
        button1.zPosition = 201;
        button2.zPosition = 201;
        GObackground.zPosition = 200;
        message.zPosition = 201;
    }

    GONaTela = YES;
    self.paused = YES;
}


//
//-(void)gotaReduzVida{
//    if(!_gota.emContatoFonte){}
//    else _gota.vida ++;
//    
//}


#pragma mark - Máscara
-(void)createMask:(int) radius
        withPoint:(CGPoint) ponto {
//    UIColor *areaColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0.5];
//    area = [[SKSpriteNode alloc] initWithColor:areaColor size:self.frame.size];
    area = [[SKNode alloc]init];
    circleMask = [[SKShapeNode alloc ]init];
    
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, 1, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    circleMask.path = circle;
    circleMask.lineWidth = radius*2.5; // replace 100 with DOUBLE the desired radius of the circle
    circleMask.name = @"circleMask";
    circleMask.userInteractionEnabled = NO;
    circleMask.fillColor = [SKColor clearColor];
    circleMask.position = CGPointMake(ponto.x-_gota.sprite.size.width,ponto.y-_gota.sprite.size.height);
    area.alpha = 0.9;
    circleMask.alpha = 0.5;
    
    

    fadeMask = [[SKSpriteNode alloc]initWithImageNamed:@"fadeMask.png"];
//    fadeMask.size = CGSizeMake(self.frame.size.width/2, self.frame.size.height/2);
    fadeMask.position = CGPointMake(self.frame.size.height/2, self.frame.size.width/2);
    area.zPosition = _cropNode.zPosition+1;
    [_cropNode addChild:fadeMask];
    [area addChild:circleMask];
    //area.position=CGPointMake(ponto.x,ponto.y-_gota.sprite.size.height);
    [_cropNode setMaskNode:area];
    
    

}

-(SKShapeNode *)createCircleToMask:(int) radius
                         {
    
    SKShapeNode *circleNew=[[SKShapeNode alloc ]init];
    
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, 1, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    
    circleNew.path = circle;
    circleNew.lineWidth = radius*2.5; // replace 100 with DOUBLE the desired radius of the circle
    circleNew.name = @"circleMask";
    circleNew.userInteractionEnabled = NO;
    circleNew.fillColor = [SKColor clearColor];
    
    circleNew.position = CGPointMake(_gota.position.x-_gota.sprite.size.width,_gota.position.y-_gota.sprite.size.height);
   
   
    return circleNew;
}


-(void)fadeMask{
    double frequencia = _level.frequenciaRelampago;
    NSTimeInterval tempo = frequencia;
    SKAction *controle = [SKAction sequence:@[[SKAction waitForDuration:tempo],
                                              [SKAction runBlock:^{
        [relampago play];
        //        [self.scene runAction:[SKAction playSoundFileNamed:@"trovao.wav" waitForCompletion:NO]];
        SKAction *retiraMascara=[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                                     [SKAction runBlock:^{
            //        [circleMask runAction:fadeIn];
            //        [circleMask removeFromParent];
            [_cropNode setMaskNode:nil];
            fadeMask.alpha = 0;
            
            SKAction *retornaMascara=[SKAction sequence:@[[SKAction waitForDuration:0.05],
                                                          [SKAction runBlock:^{
                //            [circleMask runAction:fadeOut];
                //            [area addChild:circleMask];
                [_cropNode setMaskNode:area];
                fadeMask.alpha = 1;
                
            }]]];
            
            [self runAction:retornaMascara];
            
        }]]];
        SKAction *repeater2 = [SKAction repeatAction:retiraMascara count:4];
        [self runAction:repeater2];
    }]]];
    SKAction *repeater=[SKAction repeatActionForever:controle];
    [self runAction:repeater];
    
    
}




-(void)expandMask{
    double frequencia = _level.frequenciaRelampago;
    NSTimeInterval tempo = frequencia;
    SKAction *controle = [SKAction sequence:@[[SKAction waitForDuration:tempo],
                                              [SKAction runBlock:^{
        [relampago play];
              //Criar novo campo de visão.
        
        SKAction *scaler=[SKAction sequence:@[[SKAction scaleBy:2 duration:0],[SKAction scaleBy:0.5 duration:1.5]]];
        [circleMask runAction:scaler];
        
        
        }]]] ;
    
    controle=[SKAction repeatActionForever:controle];
    [self runAction:controle];
    
    
}


#pragma mark - Ações
//-(void)divideGota{
//    if (tocou_gota && ! _gota.escondida)
//        [_gota dividir];
//}


-(void) configuraParadaGota {
    
    pararMovimentoCONTROLx = [[SKSpriteNode alloc]initWithColor:([UIColor clearColor]) size:(CGSizeMake(5, height)) ];
    pararMovimentoCONTROLy = [[SKSpriteNode alloc]initWithColor:([UIColor clearColor]) size:(CGSizeMake(width, 5)) ];
    pararMovimentoCONTROLx.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pararMovimentoCONTROLx.size];
    pararMovimentoCONTROLy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pararMovimentoCONTROLy.size];
    pararMovimentoCONTROLx.physicsBody.dynamic = NO;
    pararMovimentoCONTROLy.physicsBody.dynamic = NO;
    pararMovimentoCONTROLx.physicsBody.categoryBitMask = CONTROLE_TOQUE;
    pararMovimentoCONTROLy.physicsBody.categoryBitMask = CONTROLE_TOQUE;
    pararMovimentoCONTROLx.physicsBody.contactTestBitMask = GOTA;
    pararMovimentoCONTROLy.physicsBody.contactTestBitMask = GOTA;
    pararMovimentoCONTROLx.physicsBody.restitution = 0;
    pararMovimentoCONTROLy.physicsBody.restitution = 0;
    pararMovimentoCONTROLx.name = @"controle_toque_x";
    pararMovimentoCONTROLy.name = @"controle_toque_y";
    controleXnaTela = NO;
    controleYnaTela = NO;

    
}

-(int)verificaSentido: (CGPoint)pontoReferencia with:(CGPoint)pontoObjeto {
    //  toqueFinal = pontoReferencia;
    int tipo;

    float difx = pontoObjeto.x - pontoReferencia.x;
    
    //float dify=toqueFinals.y-toqueFinal.y;
    
    float dify = pontoObjeto.y - pontoReferencia.y;
    
    BOOL negx = false;;
    
    bool negy = false;
    
        
    if(difx < 0){
        negx = true;
        difx *= -1;
    }
    if(dify < 0){
        negy = true;
        dify *= -1;
    }
    
    if (difx > dify) {
        if(negx)
            tipo = 4;
        else
            tipo = 3;
    }
    else{
        if(negy)
            tipo = 1;
        else
            tipo = 2;
    }

    return tipo;
}


-(void) followPlayer {
    
    for (int i=0;i<_inimigos.count;i++){
        
        JAGInimigos *fogo=(JAGInimigos *)_inimigos[i];
        [fogo follow:self.gota];
    }
}


#pragma mark - Lógica dos inimigos
-(void)actionsEnemys{
    
    JAGAttack *ata;
    for (int i=0;i<_inimigos.count;i++){
        
        JAGInimigos *fogo=(JAGInimigos *)_inimigos[i];
        ata=[fogo attackRanged:self.gota];
        if (ata!=nil) {
            
            SKAction *attacks=[SKAction sequence:@[[SKAction waitForDuration:1],
                                                   [SKAction runBlock:^{
                //Cria o attack
                [self.camadaPersonagens addChild:ata];
                fogo.andandoIa = false;
                fogo.sentido=0;
                
            }],
                                                   [SKAction waitForDuration:1]]];
            

            [self runAction:attacks];
            
        }else{
            [self followPlayer];
        }
        
        //[fogo follow:self.gota];
    }
    
    
    
}


#pragma mark - Touch treatment

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
                toqueInicio = [touch locationInNode:self];
        
        toqueInicio = CGPointMake(toqueInicio.x+(_gota.position.x)-CGRectGetMidX(self.frame),
                                 toqueInicio.y+(_gota.position.y)-CGRectGetMidY(self.frame));
        tocou_gota  = [_gota verificaToque:toqueInicio];
        
        if(!tocou_gota){
            [self logicaMove:touch];
            SKAction *move=[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction runBlock:^{
                [self logicaMove:touch];
            }]]];
            
            move=[SKAction repeatActionForever:move];
            
            [self runAction:move withKey:@"moveGota"];
            
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint prevLocation = [touch previousLocationInView:self.view];
    
   // location=CGPointMake(location.x-(_gota.position.x)+CGRectGetMidX(self.frame),
    //                     location.y-(_gota.position.y)+CGRectGetMidY(self.frame));
    
    if (location.x - prevLocation.x > 0) {
        //finger touch went right
        toque_moveu = YES;
    } else {
        //finger touch went left
        toque_moveu = YES;
    }
    if (location.y - prevLocation.y > 0) {
        //finger touch went upwards
    } else {
        //finger touch went downwards
    }

    
}
-(void)deallocSound{
    [relampago soltar];
    [self.level.chuva.chuva soltar];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    int valueto=self.gota.sprite.size.width;
    
    for (UITouch *touch in touches) {
        SKNode *nodeAux = [self nodeAtPoint:[touch locationInNode:self]];
        if ([nodeAux.name isEqualToString:@"pauseBT"]) {
            NSLog(@"pause detected");
            if (!GONaTela) {
                
                [self.gota removeActionWithSound];
                
                [self presentGameOver:2];

            }
        }

        toqueFinal = [touch locationInNode:self];
        toqueFinal = CGPointMake(toqueFinal.x+(_gota.position.x)-CGRectGetMidX(self.frame),
                                 toqueFinal.y+(_gota.position.y)-CGRectGetMidY(self.frame));

        
        float difToq=sqrt(pow(toqueInicio.x-toqueFinal.x,2)+pow(toqueInicio.y-toqueFinal.y,2));
        
        pararMovimentoCONTROLx.position = [touch locationInNode:_cropNode];
        pararMovimentoCONTROLy.position = [touch locationInNode:_cropNode];

        //menu gameover
        SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
        
        if ([node.name isEqualToString:@"reiniciar fase"]) {
            NSLog(@"bt1 gameover");
            
            self.scene.view.paused=NO;
            GONaTela = NO;
            //                    self.scene.paused = NO;
            [button1 removeFromParent];
            [button2 removeFromParent];
            [message removeFromParent];
            [GObackground removeFromParent];
            
            self.gota.physicsBody.velocity=CGVectorMake(0, 0);
            
            [self.gota changePosition:self.posicaoInicial];
        }
        else if([node.name isEqualToString:@"menu inicial"]){
            NSLog(@"bt2 gameover");
            [self deallocSound];
            self.scene.view.paused = NO;
            GONaTela = NO;
            JAGMenu *scene = [[JAGMenu alloc] initWithSize:self.scene.frame.size];
            [[NSUserDefaults standardUserDefaults]setInteger:_hud.vidaRestante forKey:@"vidas_restantes"];
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            
            [self.scene.view presentScene:scene transition:trans];
            
        }
        else if([node.name isEqualToString:@"proxima fase"]){
            [self nextLevel];
            
        }
        else if([node.name isEqualToString:@"loja"]){
            NSLog(@"bt2 gameover");
            [self deallocSound];
            self.scene.view.paused = NO;
            GONaTela = NO;
            JAGMenu *scene = [[JAGMenu alloc] initWithSize:self.scene.frame.size];
            [[NSUserDefaults standardUserDefaults]setInteger:_hud.vidaRestante forKey:@"vidas_restantes"];
            SKTransition *trans = [SKTransition fadeWithDuration:1.0];
            
            [self.scene.view presentScene:scene transition:trans];
            
        }

        //Dividir
        if (toque_moveu && tocou_gota && !frenetico && (difToq>valueto ||difToq<valueto)) {
//            [_cropNode addChild:[_gota dividir]];
            JAGGotaDividida* gota2;
            if (!_gota.escondida){
                
                gota2=[_gota dividir];
                
                
                if (self.gota.gotinhas.count>self.gota.qtGotinhas) {
                    JAGGotaDividida *temp=(JAGGotaDividida *)self.gota.gotinhas[0];
                    [self removeGotinha:temp withBotao:true];
                }
                [self.characteres addObject:gota2];
                [self.camadaItens addChild:gota2];}

//            [_cropNode addChild:[_gota dividirwithSentido:[self verificaSentido:toqueFinal with:_gota.position]]];
            int mul=2;
            if(self.gota.sprite.size.width>60){
               mul=8;
            }
            
            
            switch ([self verificaSentido:toqueFinal with:_gota.position]) {
                case 1:
                    
                    [gota2.physicsBody applyImpulse:CGVectorMake(0,mul)];
                    break;
                    
                case 2:
                    
                    [gota2.physicsBody applyImpulse:CGVectorMake(0, - mul)];
                    break;
                    
                case 3:
                    
                    [gota2.physicsBody applyImpulse:CGVectorMake(-mul,0)];
                    break;
                    
                case 4:
                    
                    [gota2.physicsBody applyImpulse:CGVectorMake(mul,0)];
                    break;
                    
                default:
                    break;
            }
            frenetico=true;

            SKAction *liberaDivisao=[SKAction sequence:@[[SKAction waitForDuration:3], [SKAction runBlock:^{
                frenetico=false;
            }]]];
            
            [self runAction:liberaDivisao];
           
            toque_moveu = NO;
            
            
        } else {
//            || ((difToq>1&& difToq>valueto)||(difToq<0 && difToq>valueto))
           
            
            if (([_gota verificaToque:toqueFinal] && [_gota verificaToque:toqueInicio]) ){

                [_gota esconder];
               
                [self removeActionForKey:@"moveGota"];
                            } else {
                
                [self logicaMove:touch];
                
                [self removeActionForKey:@"moveGota"];
                

            
                                //Logica da movimentacao
                //PathFinder
                //
                
                
                //logica da divisao
                //Condicaos de diferenca dos pontos
                
                
                
                //Logica do invisivel
                //Tempo de pressao
                
                
            }
            
        }
    }

}

-(void)logicaMove:(UITouch *) touch{
    if (!_gota.escondida) {

        toqueFinal = [touch locationInNode:self];
        toqueFinal = CGPointMake(toqueFinal.x+(_gota.position.x)-CGRectGetMidX(self.frame),
                                 toqueFinal.y+(_gota.position.y)-CGRectGetMidY(self.frame));
        
        if (pauseDetected) {
            _gota.physicsBody.velocity = CGVectorMake(0,0);
        }
        else if (!pauseDetected) {
            
        int temp=[self verificaSentido:toqueFinal with:_gota.position];
            

            
            if (_gota.sentido != temp) {
            self.gota.sentido=temp;                
            
            switch (self.gota.sentido) {
                case 1:
                    
                    [_gota mover:[touch locationInNode:self] withInterval:1.0 withType:1 ];
                    
                    if (controleXnaTela){
                        [pararMovimentoCONTROLx removeFromParent];
                        controleXnaTela = NO;}
                    if (!controleYnaTela) {
                        [_cropNode addChild:pararMovimentoCONTROLy];
                        controleYnaTela = YES;}
                    
                    break;
                case 2:
                    
                    [_gota mover:[touch locationInNode:self] withInterval:1.0 withType:2 ];
                    
                    if (controleXnaTela){
                        [pararMovimentoCONTROLx removeFromParent];
                        controleXnaTela = NO;}
                    if (!controleYnaTela) {
                        [_cropNode addChild:pararMovimentoCONTROLy];
                        controleYnaTela = YES;}
                    break;
                case 3:
                    [_gota mover:[touch locationInNode:self] withInterval:1.0 withType:3 ];
                    
                    if (controleYnaTela){
                        [pararMovimentoCONTROLy removeFromParent];
                        controleYnaTela = NO;}
                    if (!controleXnaTela) {
                        [_cropNode addChild:pararMovimentoCONTROLx];
                        controleXnaTela = YES;}
                    break;
                case 4:
                    
                    [_gota mover:[touch locationInNode:self] withInterval:1.0 withType:4 ];
                    
                    
                    if (controleYnaTela){
                        [pararMovimentoCONTROLy removeFromParent];
                        controleYnaTela = NO;}
                    if (!controleXnaTela) {
                        [_cropNode addChild:pararMovimentoCONTROLx];
                        controleXnaTela = YES;}
                    break;
            }
                
            }
            
        }
    }
    
}


-(void)update:(NSTimeInterval)currentTime {
  
    if(_gota.physicsBody.velocity.dx == 0 && _gota.physicsBody.velocity.dy == 0 && _gota.sprite.texture != _gota.idleTexture && !_gota.escondida)
    {
        [self.gota removeActionWithSound];
        
        _gota.sprite.texture = _gota.idleTexture;
        
    }
    
    if (pauseDetected) {
        [_gota.physicsBody applyImpulse:CGVectorMake(0,0)];
    }
    
    if (_gota.comChave) {

//        chave.position = CGPointMake(_gota.position.x*0.9, _gota.position.y*0.9);
        SKPhysicsJointPin *jointKey = [SKPhysicsJointPin jointWithBodyA:_gota.physicsBody bodyB:chave.physicsBody anchor:_gota.position];
        [self.scene.physicsWorld addJoint:jointKey];
    }
    
    //[fogo IAcomInfo:_gota];
   
    
   
    //depois de um tempo ou acao
    
    //circleMask.position = CGPointMake(_gota.position.x-height*0.2, _gota.position.y-width*0.29);
    
    ///area.position = CGPointMake(_gota.position.x,_gota.position.y);
    
    


    [self.level.chuva update:self.gota];
    
    [self prepareMove];
    
    
    
    
    if (self.hud.tempoRestante == 0) {
        self.scene.view.paused = YES;
    }
}

-(void)didFinishUpdate{
    [self centerMapOnCharacter];
    [self.hud update];
}
-(void)nextLevel{
   self.paused = NO;
    
    NSNumber *nextlevel=[NSNumber numberWithInt:([self.currentLevel intValue] + 1)];

    if ([[JAGCreatorLevels numberOfLevels:1] intValue]>=[nextlevel intValue]) {
        //Precisa desalocar os objetos tbm?
        
        [self deallocSound];
        _gota = nil;
        
        JAGPlayGameScene *scene = [[JAGPlayGameScene alloc] initWithSize:self.frame.size level:nextlevel andWorld:@1];
        
        scene.paused=YES;

        
        SKTransition *trans = [SKTransition fadeWithDuration:1.0];
        [self.scene.view presentScene:scene transition:trans];
        frenetico=YES;
       
        
            }else{
//        self.paused = YES;
                
                [self deallocSound];
                self.scene.view.paused = NO;
                GONaTela = NO;
                JAGMenu *scene = [[JAGMenu alloc] initWithSize:self.scene.frame.size];
                [[NSUserDefaults standardUserDefaults]setInteger:_hud.vidaRestante forKey:@"vidas_restantes"];
                SKTransition *trans = [SKTransition fadeWithDuration:1.0];
                
                [self.scene.view presentScene:scene transition:trans];
    }
//    [self.gota changePosition:self.posicaoInicial];

}
#pragma mark - PrepareMove
-(void)prepareMove{
    dispatch_queue_t queue;
    
    queue = dispatch_queue_create("actionEnemys",
                                  NULL);

    dispatch_async(queue, ^{
        [self actionsEnemys];
    });
}

#pragma mark - Physics

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
        inimigo.sentido=5;
        [self receberDano:inimigo.dano];
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
        inimigo.sentido=5;
        [self receberDano:inimigo.dano];
    }
    
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == TRAP)){
        JAGTrap *trap=(JAGTrap *)contact.bodyB.node;
        if (trap.tipo!=0)
        [trap capturouAGota:_gota];
        else [self receberDano:5];
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == TRAP)){
         JAGTrap *trap=(JAGTrap *)contact.bodyA.node;
        if (trap.tipo!=0)
        [trap capturouAGota:_gota];
        else [self receberDano:5];
    }
    


    //Colisao com a parede
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"wall"]) ||
       ([contact.bodyA.node.name isEqualToString:@"wall"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {


    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"chave"]) ||
       ([contact.bodyA.node.name isEqualToString:@"chave"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
    }
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"fonte"]) ||
       ([contact.bodyA.node.name isEqualToString:@"fonte"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        _gota.vida+=15;
        if([contact.bodyA.node.name isEqualToString:@"fonte"]){
            [contact.bodyA.node removeFromParent];
        }else{
            [contact.bodyB.node removeFromParent];
        }
    }
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"cronometro"]) ||
       ([contact.bodyA.node.name isEqualToString:@"cronometro"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"cronometro"]){
            JAGObjeto *obj=(JAGObjeto *)contact.bodyA.node.parent;
            [obj habilidade:self];
            self.gota.sentido=0;
            [obj removeFromParent];
        }else{
            JAGObjeto *obj=(JAGObjeto *)contact.bodyB.node.parent;
            [obj habilidade:self];
            self.gota.sentido=0;
            [obj removeFromParent];
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            [pre pressionar:true];
            
            if(pre.tipo==2){
                //Reseta o tempo
            }
            
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
            
           
            //[obj removeFromParent];
        }else{
            JAGPressao *obj=(JAGPressao *)contact.bodyB.node;
            [obj pisar];
            
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
            
            //[obj removeFromParent];
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gotaDividida"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gotaDividida"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            [pre pressionar:true];
            
            if(pre.tipo==2){
                //Reseta o tempo
            }
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                if (porta.tipo!=2) {
                     [porta verificarBotoes];
                }
               
            }
            
            
            //[obj removeFromParent];
        }else{
            JAGPressao *obj=(JAGPressao *)contact.bodyB.node;
            [obj pisar];
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
            //[obj removeFromParent];
        }
    }

    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"porta"]) ||
       ([contact.bodyA.node.name isEqualToString:@"porta"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"porta"]){
            JAGPorta *pre=(JAGPorta *)contact.bodyA.node;
            if (pre.tipo!=1) {
                
                
                if (_gota.comChave) {
                    [pre abrir:YES];
                }
                if(!pre.aberta){
                    _gota.physicsBody.velocity = CGVectorMake(0, 0);
                }
                
                //[obj removeFromParent];
            }
            //[obj removeFromParent];
        }else{
            JAGPorta *pre=(JAGPorta *)contact.bodyB.node;
            if (pre.tipo!=1) {
                [pre abrir:YES];
                if(!pre.aberta){
                    _gota.physicsBody.velocity = CGVectorMake(0, 0);
                    
                }
                
            }
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"chave"]) ||
       ([contact.bodyA.node.name isEqualToString:@"velocidade"] && [contact.bodyB.node.name isEqualToString:@"velocidade"]) ) {
        //
    }
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == CONTROLE_TOQUE)){
        //        NSLog(@"touch control hit");
        [self.gota removeActionWithSound];
        _gota.sprite.texture = _gota.idleTexture;
        _gota.physicsBody.velocity = CGVectorMake(0, 0);
        
        self.gota.sentido=0;
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == CONTROLE_TOQUE)){
        //        NSLog(@"touch control hit");
        [self.gota removeActionWithSound];
        _gota.sprite.texture = _gota.idleTexture;
        _gota.physicsBody.velocity = CGVectorMake(0, 0);
        self.gota.sentido=0;

    }

    //Colissao do Attack
    
    if(( (contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ATTACK)) ||
       ((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ATTACK))){
        JAGAttack *attack;
        if((contact.bodyB.categoryBitMask == GOTA)){
            attack=(JAGAttack *)contact.bodyA.node;
            [self receberDano:attack.dano];
            [attack removeFromParent];
        }
        else{
            attack=(JAGAttack *)contact.bodyB.node;
            [self receberDano:attack.dano];
            [attack removeFromParent];

        }
    }
    if(((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ATTACK))||
       ((contact.bodyB.categoryBitMask == PAREDE) && (contact.bodyA.categoryBitMask == ATTACK))){
        if ((contact.bodyA.categoryBitMask == ATTACK)) {
            JAGAttack *attack=(JAGAttack *)contact.bodyA.node;
            [attack removeFromParent];
        }else{
            JAGAttack *attack=(JAGAttack *)contact.bodyB.node;
            [attack removeFromParent];
        }
    }
    
    //Fim da fase
    if(((contact.bodyA.categoryBitMask == CHUVA) && (contact.bodyB.categoryBitMask == GOTA))||
       ((contact.bodyB.categoryBitMask == CHUVA) && (contact.bodyA.categoryBitMask == GOTA))){
        //Ir para o proximo nivel
        NSNumber *nextlevel=[NSNumber numberWithInt:([self.currentLevel intValue] + 1)];
        
       NSInteger faseAtual = [[NSUserDefaults standardUserDefaults] integerForKey:@"faseAtual"];
        
        [self.gota removeActionWithSound];
        
        if ([[JAGCreatorLevels numberOfLevels:1] intValue]>=[nextlevel intValue]&& [nextlevel intValue]>faseAtual)
            [[NSUserDefaults standardUserDefaults]setInteger:[nextlevel integerValue] forKey:@"faseAtual"];
        
        [self presentGameOver:1];
    
   
    }
    
    if(((contact.bodyA.categoryBitMask==GOTA) && (contact.bodyB.categoryBitMask==DIVIDIDA))||
        ((contact.bodyB.categoryBitMask==GOTA) && (contact.bodyA.categoryBitMask==DIVIDIDA))){
        if(contact.bodyA.categoryBitMask==DIVIDIDA){
            JAGGotaDividida *dividida=(JAGGotaDividida *)contact.bodyA.node;
            if(dividida.pronto){
                [self removeGotinha:dividida withBotao:false];
                
                
            }
                       
        }else{
            JAGGotaDividida *dividida=(JAGGotaDividida *)contact.bodyB.node;
            
            if(dividida.pronto){
                [dividida removeFromParent];
                [self removeGotinha:dividida withBotao:false];
            }
        }
    }
    
    
//    //Melhorar Ia do monstro
//    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ENEMY)){
//        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
//        inimigo.inColisao=true;
//    }
//    
//    if((contact.bodyB.categoryBitMask == PAREDE) && (contact.bodyA.categoryBitMask == ENEMY)){
//        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
//        inimigo.inColisao=true;
//    }
}

-(void)didEndContact:(SKPhysicsContact *)contact{
    //Termino da colisao do botao pressionado;
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            [self validaPressao:pre];
            //[obj removeFromParent];
        }else{
//            JAGPressao *obj = (JAGPressao *)contact.bodyB.node;
            
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
            //[obj removeFromParent];
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gotaDividida"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gotaDividida"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            [self validaPressao:pre];
            //[obj removeFromParent];
        }else{
            //            JAGPressao *obj = (JAGPressao *)contact.bodyB.node;
            
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
            //[obj removeFromParent];
        }
    }

    
    if((contact.bodyA.categoryBitMask == PRESSAO) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
        if(pre.tipo==3){
            //Libera
            if(![pre pisado:_characteres]){
                [pre pisar];
                
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
                
            }
        }
    }
    
    if((contact.bodyB.categoryBitMask == PRESSAO) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGPressao *pre=(JAGPressao *)contact.bodyB.node;
        if(pre.tipo==3){
            //Libera
            if(![pre pisado:_characteres]){
                [pre pisar];
                
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
                
            }

        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"chave"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        chave = (JAGChave *)contact.bodyA.node;
        _gota.comChave = YES;
    }
    if (([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"chave"]) ) {
        chave = (JAGChave *)contact.bodyB.node;
        _gota.comChave = YES;
    }


    
    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
        inimigo.inColisao=false;
    }
    
    if((contact.bodyB.categoryBitMask == PAREDE) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
        inimigo.inColisao=false;
    }
    
    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ATTACK)){
        if ((contact.bodyA.categoryBitMask == ATTACK)) {
            JAGAttack *attack=(JAGAttack *)contact.bodyA.node;
            [attack removeFromParent];
        }else{
            JAGAttack *attack=(JAGAttack *)contact.bodyB.node;
            [attack removeFromParent];
        }
    }
    
}

#pragma mark - Receber Dano
-(void)receberDano:(int) dano{
    if(self.gota.escondida==NO || dano==1){
        self.gota.vida-=dano;
        if( self.gota.vida <1 && self.hud.vidaRestante >1){
            
            self.gota.vida=15;
            self.hud.vidaRestante--;
            [self presentGameOver:0];
        
            self.scene.view.paused=YES;
        }
        else if(self.gota.vida<1 && self.hud.vidaRestante <=1){
            self.hud.vidaRestante--;
            [self presentGameOver:2];
        }
    }
}

#pragma mark - Configuração/Inicialização

-(void)centerMapOnCharacter{
//    if(self.gota.physicsBody.velocity.dx>0){
    
    
    self.cropNode.position = CGPointMake(-(_gota.position.x)+CGRectGetMidX(self.frame),
                                         -(_gota.position.y)+CGRectGetMidY(self.frame));
//    }
    fadeMask.position = CGPointMake(self.gota.position.x, self.gota.position.y);
    
    circleMask.position=CGPointMake(_gota.position.x,_gota.position.y);
}
-(void)configStart:(int) time{
    _posicaoInicial=self.gota.position;
    
    self.cropNode.zPosition=50;
    
    SKAction *diminuirSaude=[SKAction sequence:@[[SKAction waitForDuration:time],
                                                [SKAction runBlock:^{
        [self receberDano:1];
        //Criar uma gotinha
        
      //  self.sprite.texture = [SKTexture textureWithImageNamed:@"poca.png"];

        JAGPerdaGota *gotinha=[[JAGPerdaGota alloc] initWithPosition:self.gota.position withTimeLife:10 withSize:self.level.tileSize];
        gotinha.zPosition = -1;
        _gota.zPosition = 1;
        [area addChild:[gotinha areavisao:50]];
       
        [self.camadaItens addChild:gotinha];
        [self.camadaItens addChild:gotinha.sprite];
//
        //Aumentar a area
        
                                                }]]];
    SKAction *loop=[SKAction repeatActionForever:diminuirSaude];
    
    [self runAction:loop];
    
    for (int i=0;i<_inimigos.count;i++){
        
                JAGInimigos *inimigo = (JAGInimigos *)_inimigos[i];
        
        [inimigo IAcomInfo];
    }
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Raio1" ofType:@"caf"];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    relampago=[[Musica alloc] init];
    
    [relampago carregar:fileUrl withEffects:false];
    
    [relampago changeVolume:1.0];

    self.posicaoInicial=self.gota.position;
}

-(void)configInit:(SKSpriteNode *)background{
    self.cropNode = [[SKCropNode alloc] init];
    [self.cropNode addChild:background];
    
    self.characteres=[[NSMutableArray alloc] init];
    self.inimigos=[[NSMutableArray alloc] init];
}

-(void)configInit{
    self.cropNode = [[SKCropNode alloc] init];
//    [self.cropNode addChild:background];
    
    self.characteres=[[NSMutableArray alloc] init];
    self.inimigos=[[NSMutableArray alloc] init];
    
}

-(void)rastroInimigo: (SKNode*)inimigo{
    JAGPerdaFogo *perda_fogo = [[JAGPerdaFogo alloc] initWithPosition:inimigo.position withTimeLife:10];
    SKAction *diminuirSaude=[SKAction sequence:@[[SKAction waitForDuration:5],
                                                 [SKAction runBlock:^{

    
        [self.cropNode addChild:perda_fogo.emitter];
        
        
    }]]];
    SKAction *loop=[SKAction repeatActionForever:diminuirSaude];
    
    [self runAction:loop];

}
#pragma mark - Arquivos
-(void)loadingWorld{
    //Ler um arquivo
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"level.txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    
    NSError *error;
    // NSDictionary *resultados =[NSJSONSerialization JSONObjectWithData:[level1.exportar dataUsingEncoding:NSUTF8StringEncoding];
    //                                                               options:NSJSONReadingMutableContainers error:&error];
    
    
    NSDictionary *resul=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    
    if(!error){
        //Ponto *ponto = [Ponto comDicionario: resultados];
        //NSLog(@"Ponto: %@", ponto.descricao);
        CGSize tamanho=CGSizeMake(_level.tileSize, _level.tileSize);
        NSDictionary *temp=[resul objectForKey:@"gota"];
        
        _gota=[[JAGGota alloc] initWithPosition:CGPointMake([[temp objectForKey:@"positionX"] floatValue], [[temp objectForKey:@"positionY"] floatValue]) withSize:tamanho];
        
        [_cropNode addChild:_gota];
        
        NSNumber *tempoNum=[resul objectForKey:@"inimigos"];
        //Inimigos
        for (int i=0; i<[tempoNum intValue]; i++) {
            NSDictionary *enemy=[resul objectForKey:[NSString stringWithFormat:@"inimigo%d",i+1]];
            NSNumber *tipo=[enemy objectForKey:@"tipo"];
            
            
            if([tipo intValue]==1){
                JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake([[enemy objectForKey:@"positionX"] floatValue], [[enemy objectForKey:@"positionY"] floatValue]) withSize:tamanho];
                [self rastroInimigo:inimigo];
                [_cropNode addChild:inimigo];

            }
        }
        
        //Paredes
        tempoNum=[resul objectForKey:@"paredes"];
        //Inimigos
        for (int i=0; i<[tempoNum intValue]; i++) {
            NSDictionary *enemy=[resul objectForKey:[NSString stringWithFormat:@"parede%d",i+1]];
            
            
            
            SKSpriteNode *spri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_level.tileSize, _level.tileSize)];
            
            
            JAGWall *wall=[[JAGWall alloc] initWithPosition:CGPointMake([[enemy objectForKey:@"positionX"] floatValue], [[enemy objectForKey:@"positionY"] floatValue]) withSprite:spri];
            
            [_cropNode addChild:wall];
        }
    }
    
    //Tamanho do Mapa b x h
    
    
    
    //Parades obstaculos
    
    //Inimigos
    
    //Posicao inicial da Gota.
    
    //
    
    
}


#pragma mark - Pressao
-(void)validaPressao:(JAGPressao *)pre{
    
    if(pre.tipo==2){
        //Inicia um Action que faz a validacao depois de um tempo
        _despresionar =[SKAction sequence:@[[SKAction waitForDuration:4],
                                            [SKAction runBlock:^{
            if(![pre pisado:_characteres]){
                [pre pisar];
            }
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
        }]]];
        
        //_despresionar =;
        
        [self runAction:_despresionar];
    }
    if(pre.tipo==3){
        //Libera
        if(![pre pisado:_characteres]){
            [pre pisar];
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
        }
    }
    for (int i=0; i<_portas.count; i++) {
        JAGPorta *porta=_portas[i];
        [porta verificarBotoes];
    }
}

-(void)removeGotinha:(JAGGotaDividida *)temp withBotao:(bool) aplicar{
    [temp removeAllActions];
    temp.physicsBody=nil;
    [temp removeFromParent];
    [self.gota.gotinhas removeObject:temp];
    
    
    
    [self.characteres removeObject:temp];
    
    temp=nil;
    
    if (aplicar) {
        for (int i=0; i<self.level.botoes.count; i++) {
            JAGPressao *pre=(JAGPressao *)self.level.botoes[i];
            [self validaPressao:pre];
        }
        
    }

}




@end
