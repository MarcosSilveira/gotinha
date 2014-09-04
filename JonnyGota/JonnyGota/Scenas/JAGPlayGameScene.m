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


@implementation JAGPlayGameScene {
    
    float width;
    float height;
    CGPoint toqueInicio;
    SKShapeNode *circleMask;
    CGPoint toqueFinal;
    BOOL tocou_gota;
    BOOL toque_moveu;
    SKShapeNode *lineNode;
    SKNode *area;
    SKNode *worldNode;
    SKSpriteNode *pararMovimentoCONTROLx;
    SKSpriteNode *pararMovimentoCONTROLy;
    BOOL controleXnaTela;
    BOOL controleYnaTela;
    JAGChave* chave;
    UILongPressGestureRecognizer *longPress;
}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{
    
    self.physicsWorld.contactDelegate = (id)self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    [self touchesEnded:nil withEvent:nil];
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOK)];
    longPress.delegate = self;
    
}
-(void)longPressOK{
    NSLog(@"long press recognized");
}
-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
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
       

//        _cropNode = [[SKCropNode alloc] init];
//
//        [_cropNode addChild:[self createCharacter]];
//        [self createMask:100 withPoint:(_gota.position)];
//        //[_cropNode addChild:[self createFireEnemy]];
////        [worldNode addChild:_cropNode];
////        [self addChild: worldNode];
//        [self addChild:_cropNode];
//        [self createLevel];
        width = self.scene.size.width;
        height = self.scene.size.height;
        [self configuraParadaGota];
    }
//    [self presentGameOver:0];

    return self;
}

#pragma mark - Métodos de inicialização
-(JAGGota *)createCharacter{
    _gota = [[JAGGota alloc] initWithPosition:CGPointMake(width*0.3, height*0.3) withSize:[_level sizeTile]];
    _gota.name = @"gota";
    
    return _gota;
}

-(void)gotaReduzVida{
    if(!_gota.emContatoFonte){}
    else _gota.vida ++;
    
}


#pragma mark - Máscara
-(void)createMask:(int) radius
        withPoint:(CGPoint) ponto {
    
    area = [[SKNode alloc] init];
    circleMask = [[SKShapeNode alloc ]init];
    
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, 1, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    
    circleMask.path = circle;
    circleMask.lineWidth = radius*2; // replace 100 with DOUBLE the desired radius of the circle
    circleMask.name = @"circleMask";
    circleMask.userInteractionEnabled = NO;
    circleMask.fillColor = [SKColor clearColor];
    
    circleMask.position = CGPointMake(ponto.x-_gota.sprite.size.width,ponto.y-_gota.sprite.size.height);
    
    [area addChild:circleMask];
    //area.position=CGPointMake(ponto.x,ponto.y-_gota.sprite.size.height);
    //[_cropNode setMaskNode:area];
}

#pragma mark - Mundo/Fases


#pragma mark - Ações
-(void)divideGota{
    if (tocou_gota && ! _gota.escondida)
        [_gota dividir];
}


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
                [self.cropNode addChild:ata];
                fogo.andandoIa = false;
                
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *walkFrames = [NSMutableArray array];
    int numImages = atlas.textureNames.count;
    for (int i=1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"gota_walk_%d", i];
        SKTexture *temp = [atlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (UITouch *touch in touches) {

        pararMovimentoCONTROLx.position = [touch locationInNode:_cropNode];
        pararMovimentoCONTROLy.position = [touch locationInNode:_cropNode];

        if (toque_moveu && tocou_gota) {
            [_cropNode addChild:[_gota dividir]];
            NSLog(@"Dividiu");
            toque_moveu = NO;
        } else {
            
            toqueFinal = [touch locationInNode:self];
            toqueFinal = CGPointMake(toqueFinal.x+(_gota.position.x)-CGRectGetMidX(self.frame),
                                   toqueFinal.y+(_gota.position.y)-CGRectGetMidY(self.frame));
            if ([_gota verificaToque:toqueFinal]){
                [_gota esconder];
            } else {
                if (!_gota.escondida) {
                    
                    switch ([self verificaSentido:toqueFinal with:_gota.position]) {
                        case 1:
                                
                            [_gota mover:toqueFinal withInterval:1.0 withType:1 ];
                            [_gota runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
                            if (controleXnaTela){
                                [pararMovimentoCONTROLx removeFromParent];
                                controleXnaTela = NO;}
                                if (!controleYnaTela) {
                            [_cropNode addChild:pararMovimentoCONTROLy];
                                    controleYnaTela = YES;}
                            
                            break;
                        case 2:
                           
                                [_gota mover:toqueFinal withInterval:1.0 withType:2 ];
                            [_gota runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
                            if (controleXnaTela){
                                [pararMovimentoCONTROLx removeFromParent];
                                controleXnaTela = NO;}
                                if (!controleYnaTela) {
                                    [_cropNode addChild:pararMovimentoCONTROLy];
                                    controleYnaTela = YES;}
                            break;
                        case 3:
                                [_gota mover:toqueFinal withInterval:1.0 withType:3 ];
                            [_gota runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
                            if (controleYnaTela){
                                [pararMovimentoCONTROLy removeFromParent];
                                controleYnaTela = NO;}
                                if (!controleXnaTela) {
                                    [_cropNode addChild:pararMovimentoCONTROLx];
                                    controleXnaTela = YES;}
                            break;
                        case 4:
        
                            [_gota mover:toqueFinal withInterval:1.0 withType:4 ];
                            [_gota runAction:[SKAction repeatActionForever:[SKAction animateWithTextures: walkFrames timePerFrame:0.1f]]withKey:@"WalkLAction2"];
                            
                            if (controleYnaTela){
                                [pararMovimentoCONTROLy removeFromParent];
                                controleYnaTela = NO;}
                                if (!controleXnaTela) {
                                    [_cropNode addChild:pararMovimentoCONTROLx];
                                    controleXnaTela = YES;}
                            break;
                    }
                    
                }
                
                //menu gameover
                SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];

                if ([node.name isEqualToString:@"button1"]) {
                    NSLog(@"bt1 gameover");
                    self.scene.paused = NO;
                    [button1 removeFromParent];
                    [button2 removeFromParent];
                    [GObackground removeFromParent];
                }
                else if([node.name isEqualToString:@"button2"]){
                    NSLog(@"bt2 gameover");
                }
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
-(void)centerMapOnCharacter{
    self.cropNode.position = CGPointMake(-(_gota.position.x)+CGRectGetMidX(self.frame),
                                    -(_gota.position.y)+CGRectGetMidY(self.frame));
    
    
    //circleMask.position=CGPointMake(-(_gota.position.x)+CGRectGetMidX(self.frame),
     //                               -(_gota.position.y)+CGRectGetMidY(self.frame));

}
-(void)update:(NSTimeInterval)currentTime {
    if (longPress.state == UIGestureRecognizerStateBegan ) {
        NSLog(@"Long Press Recognized");
    }
    if (_gota.comChave) {

//        chave.position = CGPointMake(_gota.position.x*0.9, _gota.position.y*0.9);
        SKPhysicsJointPin *jointKey = [SKPhysicsJointPin jointWithBodyA:_gota.physicsBody bodyB:chave.physicsBody anchor:_gota.position];
        [self.scene.physicsWorld addJoint:jointKey];
    }
    
    //[fogo IAcomInfo:_gota];
    
    [self centerMapOnCharacter];
    //depois de um tempo ou acao
    
    //circleMask.position = CGPointMake(_gota.position.x-height*0.2, _gota.position.y-width*0.29);
    
    //area.position = CGPointMake(_gota.position.x,_gota.position.y);
    
    circleMask.position=CGPointMake(_gota.position.x,_gota.position.y);

    //NSLog(@"gota x:%f y:%f",_gota.position.x,_gota.position.y);
    
    [self actionsEnemys];
        [self.hud update];
    
    if (self.hud.tempoRestante == 0) {
        self.scene.view.paused = YES;
    }
}

#pragma mark - Physics

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
        [self receberDano:inimigo.dano];
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
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
            [obj removeFromParent];
        }else{
            JAGObjeto *obj=(JAGObjeto *)contact.bodyB.node.parent;
            [obj habilidade:self];
            [obj removeFromParent];
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            [pre pisar];
            
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
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"porta"]) ||
       ([contact.bodyA.node.name isEqualToString:@"porta"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"porta"]){
            JAGPorta *pre=(JAGPorta *)contact.bodyA.node;
            if (_gota.comChave) {
                [pre abrir:YES];
            }
            if(!pre.aberta){
                 _gota.physicsBody.velocity = CGVectorMake(0, 0);
            }
            
            //[obj removeFromParent];
        }else{
            JAGPorta *pre=(JAGPorta *)contact.bodyB.node;
            [pre abrir:YES];
            if(!pre.aberta){
                _gota.physicsBody.velocity = CGVectorMake(0, 0);
                
            }
            //[obj removeFromParent];
        }
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"chave"]) ||
       ([contact.bodyA.node.name isEqualToString:@"velocidade"] && [contact.bodyB.node.name isEqualToString:@"velocidade"]) ) {
        //
    }
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == CONTROLE_TOQUE)){
        NSLog(@"hit");
    

        _gota.physicsBody.velocity = CGVectorMake(0, 0);
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == CONTROLE_TOQUE)){
        NSLog(@"hit");
    _gota.physicsBody.velocity = CGVectorMake(0, 0);
    }

    //Colissao do Attack
    
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ATTACK)){
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
    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ATTACK)){
        if ((contact.bodyA.categoryBitMask == ATTACK)) {
            JAGAttack *attack=(JAGAttack *)contact.bodyA.node;
            [attack removeFromParent];
        }else{
            JAGAttack *attack=(JAGAttack *)contact.bodyB.node;
            [attack removeFromParent];
        }
    }
    
    //Melhorar Ia do monstro
    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
        inimigo.inColissao=true;
    }
    
    if((contact.bodyB.categoryBitMask == PAREDE) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
        inimigo.inColissao=true;
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact{
    //Termino da colisao do botao pressionado;
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
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
                [pre pisar];
                
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
            }
                for (int i=0; i<_portas.count; i++) {
                    JAGPorta *porta=_portas[i];
                    [porta verificarBotoes];
                }
            
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
            [pre pressionar:false];
        }
    }
    
    if((contact.bodyB.categoryBitMask == PRESSAO) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGPressao *pre=(JAGPressao *)contact.bodyB.node;
        if(pre.tipo==3){
            //Libera
            [pre pressionar:false];
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

/*
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"pressao"]) ||
       ([contact.bodyA.node.name isEqualToString:@"pressao"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
        if([contact.bodyA.node.name isEqualToString:@"pressao"]){
            JAGPressao *pre=(JAGPressao *)contact.bodyA.node;
            
            
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
            
            //[obj removeFromParent];
        }else{
            JAGPressao *obj=(JAGPressao *)contact.bodyB.node;
            
            
            for (int i=0; i<_portas.count; i++) {
                JAGPorta *porta=_portas[i];
                [porta verificarBotoes];
            }
            
            //[obj removeFromParent];
        }
    }
*/
    
    if((contact.bodyA.categoryBitMask == PAREDE) && (contact.bodyB.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyB.node;
        inimigo.inColissao=false;
    }
    
    if((contact.bodyB.categoryBitMask == PAREDE) && (contact.bodyA.categoryBitMask == ENEMY)){
        JAGInimigos *inimigo=(JAGInimigos *)contact.bodyA.node;
        inimigo.inColissao=false;
    }
}

#pragma mark - Receber Dano
-(void)receberDano:(int) dano{
    self.gota.vida-=dano;
    if(self.gota.vida<=0){
        
        self.gota.vida=15;
        self.hud.vidaRestante--;
        [self presentGameOver:0];
        [self.gota changePosition:_posicaoInicial];
//        [self presentGameOver:1];
        self.paused=YES;
        _gota.physicsBody.velocity = CGVectorMake(0, 0);
    }
}

#pragma mark - Configuração de Start
-(void)configStart:(int) time{
    _posicaoInicial=self.gota.position;
    
    self.cropNode.zPosition=50;
    
    
    SKAction *diminuirSaude=[SKAction sequence:@[[SKAction waitForDuration:time],
                                                [SKAction runBlock:^{
        [self receberDano:1];
        //Criar uma gotinha
        JAGPerdaGota *gotinha=[[JAGPerdaGota alloc] initWithPosition:self.gota.position withTimeLife:10];
        
        [area addChild:[gotinha areavisao:50]];

        [self.cropNode addChild:gotinha];
        [self.cropNode addChild:gotinha.emitter];
        //Aumentar a area
        
        
                                                }]]];
    SKAction *loop=[SKAction repeatActionForever:diminuirSaude];
    
    [self runAction:loop];
    
    for (int i=0;i<_inimigos.count;i++){
        
                JAGInimigos *fogo=(JAGInimigos *)_inimigos[i];
        
        [fogo IAcomInfo];
    }

    
    
}

-(void)configInit:(SKSpriteNode *)background{
    self.cropNode = [[SKCropNode alloc] init];
    [self.cropNode addChild:background];
    
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


-(void)createLevel{
    _level=[[JAGLevel alloc] initWithHeight:20 withWidth:20];
    
    CGSize tamanho=CGSizeMake(_level.tileSize, _level.tileSize);
    
    _level.gota=[[JAGGota alloc] initWithPosition:CGPointMake(_level.tileSize*2, _level.tileSize*2) withSize:tamanho];
    
    
    SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_level.tileSize, _level.tileSize)];
    
    wallSpri.name=@"brownColor";
    
    JAGWall *parede=[[JAGWall alloc] initWithSprite:wallSpri];
    
    parede.position=CGPointMake(_level.tileSize*5, _level.tileSize*5);
    
    [_level.paredes setValue:parede forKey:@"parede1"];
    
    
    JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake(_level.tileSize*4, _level.tileSize*4) withSize:tamanho];
    
    inimigo.sprite.name=@"grenColor";
    
    inimigo.tipo=1;
    
    [_level.inimigos setValue:inimigo forKey:@"inimigo1"];
    
    _level.mundo=@1;
    
    _level.level=@1;
    
    //NSLog(@" Export: %@", [level1 exportar]);    
}

-(void)presentGameOver:(int)withOP{
    
    GObackground = [[SKSpriteNode alloc]initWithColor:[UIColor redColor] size:CGSizeMake( self.frame.size.height/2, self.frame.size.width/2)];
    GObackground.position = CGPointMake(self.frame.size.height*0.35, self.frame.size.width*0.7);
    button1 = [[SKSpriteNode alloc] initWithImageNamed:@"play.png"];
    button1.size = CGSizeMake(GObackground.size.width/4, GObackground.size.height/4.5);
    button1.position = CGPointMake(self.frame.size.height*0.2, self.frame.size.width*0.45);
    button2 = [[SKSpriteNode alloc] initWithImageNamed:@"list.png"];
    button2.size =CGSizeMake(GObackground.size.width/4, GObackground.size.height/4.5);
    button2.position = CGPointMake(self.frame.size.height*0.5, self.frame.size.width*0.45);
    button1.name = @"button1";
    button2.name = @"button2";

    [self.scene addChild:GObackground];
    [self.scene addChild:button1];
    [self.scene addChild:button2];
    button1.zPosition = 201;
    button2.zPosition = 201;
    GObackground.zPosition = 200;
}

@end
