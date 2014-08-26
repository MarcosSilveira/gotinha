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
}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{
    
    self.physicsWorld.contactDelegate = (id)self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    [self touchesEnded:nil withEvent:nil];
    
}

-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        atlas = [SKTextureAtlas atlasNamed:@"gotinha"];
        self.physicsWorld.contactDelegate = self;
        worldNode = [[SKNode alloc]init];
        [worldNode setName:@"worldNode"];
        //self.initSize = size;
        
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

    return self;
}

#pragma mark - Métodos de inicialização
-(JAGGota *)createCharacter{
    _gota = [[JAGGota alloc] initWithPosition:CGPointMake(width*0.3, height*0.3) withSize:[_level sizeTile]];
    _gota.name = @"gota";
    
    return _gota;
}

-(JAGFogoEnemy *)createFireEnemy{
    
      _fogo = [[JAGFogoEnemy alloc] initWithPosition:CGPointMake(width*0.9, height*0.3) withSize:[_level sizeTile]];

    return _fogo;
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
    
    [area addChild:circleMask];
    area.position=CGPointMake(ponto.x,ponto.y-_gota.sprite.size.height);
    [_cropNode setMaskNode:area];
    
}

#pragma mark - Mundo/Fases


#pragma mark - Ações
-(void)divideGota{
    if (tocou_gota && ! _gota.escondida)
        [_gota dividir];
}

-(void) followPlayer {
    
    float distance = hypotf(_fogo.position.x - _gota.position.x, _fogo.position.y - _gota.position.y);
    
    if (distance < 100) {
        if (_gota.escondida == NO) {
            [_fogo mover:(_gota.position) withInterval:2 withType:[self verificaSentido:_gota.position with:_fogo.position]];
        }
        else _fogo.physicsBody.velocity = CGVectorMake(0, 0);
    }
    else _fogo.physicsBody.velocity = CGVectorMake(0, 0);
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
//    [_cropNode addChild:pararMovimentoCONTROLy];
//    [_cropNode addChild:pararMovimentoCONTROLx];
    
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
    

}
-(void)update:(NSTimeInterval)currentTime {
    
    
    [self centerMapOnCharacter];
    //depois de um tempo ou acao
    
    //circleMask.position = CGPointMake(_gota.position.x-height*0.2, _gota.position.y-width*0.29);
    
    area.position = CGPointMake(_gota.position.x,_gota.position.y);

    //NSLog(@"gota x:%f y:%f",_gota.position.x,_gota.position.y);
    [self followPlayer];
    [self.hud update];
    
    if (self.hud.tempoRestante == 0) {
        self.scene.view.paused = YES;
    }
}

#pragma mark - Physics

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        self.hud.vidaRestante--;
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        self.hud.vidaRestante--;
    }
    //Colisao com a parede
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"wall"]) ||
       ([contact.bodyA.node.name isEqualToString:@"wall"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
    
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"chave"]) ||
       ([contact.bodyA.node.name isEqualToString:@"chave"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ) {
        //
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
            
            if(!pre.aberta){
                 _gota.physicsBody.velocity = CGVectorMake(0, 0);
            }
            
            //[obj removeFromParent];
        }else{
            JAGPorta *pre=(JAGPorta *)contact.bodyA.node;
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
            JAGPressao *obj = (JAGPressao *)contact.bodyB.node;
            
           
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
}


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


@end
