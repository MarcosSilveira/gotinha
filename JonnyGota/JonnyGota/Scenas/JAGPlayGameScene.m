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


@implementation JAGPlayGameScene {
    
    int width;
    int height;
    CGPoint toqueInicio;
    SKShapeNode *circleMask;
    CGPoint toqueFinal;
    BOOL tocou_gota;
    BOOL toque_moveu;
    SKShapeNode *lineNode;
    SKNode *area;
    SKNode *worldNode;

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
            [_fogo mover:(_gota.position) withInterval:2 withType:[self verificaSentido:_gota.position with:_fogo.position]and:100];
        }
        else _fogo.physicsBody.velocity = CGVectorMake(0, 0);
    }
    else _fogo.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void) moveInimigo {
    
    int randEixo = arc4random()%3+1;
    
    CGPoint posX, posY, posX2, posY2;
    posY  = CGPointMake(self.fogo.position.x, self.fogo.position.y + 3);
    posY2 = CGPointMake(self.fogo.position.x, self.fogo.position.y - 3);
    posX  = CGPointMake(self.fogo.position.x + 3, self.fogo.position.y);
    posX2 = CGPointMake(self.fogo.position.x - 3, self.fogo.position.y);

    switch (randEixo) {
        case 1:
            [self.fogo mover:posY withInterval:1.0 withType:1 and:200]; //cima
            break;
            
        case 2:
            [self.fogo mover:posY2 withInterval:1.0 withType:2 and:200]; //baixo
            break;
            
        case 3:
            [self.fogo mover:posX withInterval:1.0 withType:3 and:200]; //esq
            break;
            
        case 4:
            [self.fogo mover:posX2 withInterval:1.0 withType:4 and:200]; //dir
            break;
            
        default:
            break;
    }
}

-(void) configuraParadaGota {
    
    SKSpriteNode *pararMovimentoCONTROLx = [[SKSpriteNode alloc]initWithColor:([UIColor clearColor]) size:(CGSizeMake(width, 5)) ];
    SKSpriteNode *pararMovimentoCONTROLy = [[SKSpriteNode alloc]initWithColor:([UIColor clearColor]) size:(CGSizeMake(5, height)) ];
    pararMovimentoCONTROLx.physicsBody.dynamic = NO;
    pararMovimentoCONTROLy.physicsBody.dynamic = NO;
    pararMovimentoCONTROLx.physicsBody.categoryBitMask = CONTROLE_TOQUE;
    pararMovimentoCONTROLy.physicsBody.categoryBitMask = CONTROLE_TOQUE;
    pararMovimentoCONTROLx.physicsBody.contactTestBitMask = GOTA;
    pararMovimentoCONTROLy.physicsBody.contactTestBitMask = GOTA;
    pararMovimentoCONTROLx.physicsBody.restitution=0;
    pararMovimentoCONTROLy.physicsBody.restitution=0;
    pararMovimentoCONTROLy.name = @"controle_toque_x";
    pararMovimentoCONTROLy.name = @"controle_toque_y";
    [_cropNode addChild:pararMovimentoCONTROLy];
    [_cropNode addChild:pararMovimentoCONTROLx];
        
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
        tocou_gota = [_gota verificaToque:[touch locationInNode:self]];
        
        
        
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    CGPoint prevLocation = [touch previousLocationInView:self.view];
    
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
    if (toque_moveu && tocou_gota) {
        [_gota dividir];
        toque_moveu = NO;
    }
    for (UITouch *touch in touches) {
        
        toqueFinal = [touch locationInNode:self];
        if ([_gota verificaToque:[touch locationInNode:self]])
            [_gota esconder];
        if (!_gota.escondida) {
            
        
        switch ([self verificaSentido:toqueFinal with:_gota.position]) {
            case 1:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueFinal withInterval:1.0 withType:1 and:300];
                
                break;
            case 2:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueFinal withInterval:1.0 withType:2 and:300];
                
                break;
            case 3:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueFinal withInterval:1.0 withType:3 and:300];
                
                break;
            case 4:
                if (!_gota.escondida && !tocou_gota)
                    
                    
                    [_gota mover:toqueFinal withInterval:1.0 withType:4 and:300];
                
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
-(void)centerMapOnCharacter{
    self.cropNode.position=CGPointMake(-(_gota.position.x)+CGRectGetMidX(self.frame),
                                    -(_gota.position.y)+CGRectGetMidY(self.frame));
    

}
-(void)update:(NSTimeInterval)currentTime {
    [self centerMapOnCharacter];
    //depois de um tempo ou acao
    
    //circleMask.position = CGPointMake(_gota.position.x-height*0.2, _gota.position.y-width*0.29);
    
    area.position = CGPointMake(_gota.position.x,_gota.position.y);
    
    if ((self.fogo.physicsBody.velocity.dx <= 0) && (self.fogo.physicsBody.velocity.dy <= 0)) {
       // [self moveInimigo];
    }
    
    [self followPlayer];
    [self.hud update];
}

#pragma mark - Physics

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        //NSLog(@"hit");
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        //NSLog(@"hit");
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
        
        NSDictionary *temp = [resul objectForKey:@"gota"];
        
        _gota = [[JAGGota alloc] initWithPosition:CGPointMake([[temp objectForKey:@"positionX"] floatValue], [[temp objectForKey:@"positionY"] floatValue])];
        
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

-(void)createLevel {
    _level = [[JAGLevel alloc] initWithHeight:20 withWidth:20];
    
    _level.gota = [[JAGGota alloc] initWithPosition:CGPointMake(_level.tileSize*2, _level.tileSize*2)];
    
    
    SKSpriteNode *wallSpri = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(_level.tileSize, _level.tileSize)];
    
    wallSpri.name = @"brownColor";
    
    JAGWall *parede = [[JAGWall alloc] initWithSprite:wallSpri];
    
    parede.position = CGPointMake(_level.tileSize*5, _level.tileSize*5);
    
    [_level.paredes setValue:parede forKey:@"parede1"];
    
    
    JAGFogoEnemy *inimigo = [[JAGFogoEnemy alloc] initWithPosition:CGPointMake(_level.tileSize*4, _level.tileSize*4)];
    
    inimigo.sprite.name = @"grenColor";
    
    inimigo.tipo = 1;
    
    [_level.inimigos setValue:inimigo forKey:@"inimigo1"];
    
    _level.mundo = @1;
    
    _level.level = @1;
    
    //NSLog(@" Export: %@", [level1 exportar]);
}

@end
