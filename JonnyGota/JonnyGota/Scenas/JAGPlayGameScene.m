//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"
#import "JAGLevel.h"


@implementation JAGPlayGameScene {
    
    int width;
    int height;
    CGPoint toqueInicio;
    SKShapeNode *circleMask;
    CGPoint toqueFinal;
    bool tocou;
    JAGLevel *level1;
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
        [JAGLevel initializeLevel:self.currentLevel ofWorld:self.currentWorld onScene:self];
        
               
        
        //_parar=NO;
        //_boing = [SKAction playSoundFileNamed:@"boing.mp3" waitForCompletion:NO];
    }

    return self;
}

#pragma mark - Métodos de inicialização
-(JAGGota *)createCharacter{
    
    _gota = [[JAGGota alloc] initWithPosition:CGPointMake(width*0.3, height*0.3)];
    _gota.name = @"gota";
    
    return _gota;
}

-(JAGFogoEnemy *)createFireEnemy{
      _fogo = [[JAGFogoEnemy alloc] initWithPosition:CGPointMake(width*0.9, height*0.3)];
    
    return _fogo;
}

#pragma mark - Máscara
-(void)createMask:(int) radius
        withPoint:(CGPoint) ponto {
    
    SKNode *area = [[SKNode alloc] init];
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
-(void)loadingWorld{
    //Ler um arquivo
    
    //Tamanho do Mapa b x h
    
    
    JAGLevel *level1 = [[JAGLevel alloc] initWithHeight:20 withWidth:20];
    level1.gota = [[JAGGota alloc] initWithPosition:CGPointMake(level1.tileSize*2, level1.tileSize*2)];
    
    
    SKSpriteNode *wallSpri = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(level1.tileSize, level1.tileSize)];
    wallSpri.name = @"brownColor";
    
    
    [level1.paredes setValue:parede forKey:@"parede1"];
    
    JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake(level1.tileSize*4, level1.tileSize*4)];
    
    inimigo.sprite.name = @"grenColor";
    inimigo.tipo = 1;
    
    [_cropNode setMaskNode:area];
    
}

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

    _gota.sprite.name=@"gota";
    
    int randEixo = arc4random()%3+1;
    
    /* NSArray *pos = [NSArray arrayWithObjects:
     [NSValue valueWithCGPoint:CGPointMake(self.fogo.position.x + 3, 0) ],
     [NSValue valueWithCGPoint:CGPointMake(self.fogo.position.x - 3, 0)],
     [NSValue valueWithCGPoint:CGPointMake(0,self.fogo.position.y + 3)],
     [NSValue valueWithCGPoint:CGPointMake(0,self.fogo.position.y - 3)], nil];*/
    
    switch (randEixo) {
        case 1:
            [self.fogo mover:(self.fogo.position) withInterval:1.0 withType:1 and:100]; //cima
            break;
            
        case 2:
            [self.fogo mover:(self.fogo.position) withInterval:1.0 withType:2 and:100]; //baixo
            break;
            
        case 3:
            [self.fogo mover:(self.fogo.position) withInterval:1.0 withType:2 and:100]; //esq
            break;
            
        case 4:
            [self.fogo mover:(self.fogo.position) withInterval:1.0 withType:2 and:100]; //dir
            break;
            
        default:
            break;
    }
}

-(void) pararMove {
    
    float pararMovimentoCONTROL = hypotf(toqueFinal.x - _gota.position.x, toqueFinal.y - _gota.position.y);
    
    if (pararMovimentoCONTROL < 50)
        _gota.physicsBody.velocity = CGVectorMake(0, 0);
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
        
        switch ([self verificaSentido:toqueInicio with:_gota.position]) {
            case 1:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueInicio withInterval:1.0 withType:1 and:300];
                
                break;
            case 2:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueInicio withInterval:1.0 withType:2 and:300];
                
                break;
            case 3:
                if (!_gota.escondida && !tocou_gota)
                    
                    [_gota mover:toqueInicio withInterval:1.0 withType:3 and:300];
                
                break;
            case 4:
                if (!_gota.escondida && !tocou_gota)
                    
                    
                    [_gota mover:toqueInicio withInterval:1.0 withType:4 and:300];
                
                break;
    }
        
        
        
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

            
        
        
        
        //Logica da movimentacao
        //PathFinder
        //
        
        
        //logica da divisao
        //Condicaos de diferenca dos pontos
        
        
        
        //Logica do invisivel
        //Tempo de pressao
        
        
        }
    
}

-(void)update:(NSTimeInterval)currentTime {
    //depois de um tempo ou acao
    
    circleMask.position = CGPointMake(_gota.position.x-height*0.2, _gota.position.y-width*0.29);
    
    if ((self.fogo.physicsBody.velocity.dx <= 0) && (self.fogo.physicsBody.velocity.dy <= 0)) {
       // [self moveInimigo];
    }
    
    [self followPlayer];
    [self pararMove];
    [self.hud update];
}

#pragma mark - Physics

- (void)didSimulatePhysics{
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        //NSLog(@"hit");
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        //NSLog(@"hit");
    }
    //Colisao com a parede
    if(([contact.bodyA.node.name isEqualToString:@"gota"] && [contact.bodyB.node.name isEqualToString:@"wall"]) ||
       ([contact.bodyA.node.name isEqualToString:@"wall"] && [contact.bodyB.node.name isEqualToString:@"gota"]) ){
        
    
    }

}


/**
 * Calculate the dot-product of two 2D vectors a dot b
 */
-(double) CGPointDot:(CGPoint) a and: (CGPoint) b {
	return a.x*b.x + a.y*b.y;
}
/**
 * Calculate the magnitude of a 2D vector
 */
-(double) CGPointMagnitude:(CGPoint) pt {
	return sqrt([self CGPointDot:pt and:pt]);
}

/**
 * Calculate the vector-scalar product A*b
 */
-(CGPoint) CGPointScale:(CGPoint) A and:(double) b {
	return CGPointMake(A.x*b, A.y*b);
}
/**
 * Normalize a 2D vector
 */
-(CGPoint) CGPointNormalize:(CGPoint)pt {
	return [self CGPointScale:pt and:1.0/[self CGPointMagnitude:pt]];
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
        
        NSDictionary *temp=[resul objectForKey:@"gota"];
        
        _gota=[[JAGGota alloc] initWithPosition:CGPointMake([[temp objectForKey:@"positionX"] floatValue], [[temp objectForKey:@"positionY"] floatValue])];
        
        [_cropNode addChild:_gota];
        
        NSNumber *tempoNum=[resul objectForKey:@"inimigos"];
        //Inimigos
        for (int i=0; i<[tempoNum intValue]; i++) {
            NSDictionary *enemy=[resul objectForKey:[NSString stringWithFormat:@"inimigo%d",i+1]];
            NSNumber *tipo=[enemy objectForKey:@"tipo"];
                     
              
            if([tipo intValue]==1){
                JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake([[enemy objectForKey:@"positionX"] floatValue], [[enemy objectForKey:@"positionY"] floatValue])];
                
                [_cropNode addChild:inimigo];
            }
        }
        
        //Paredes
        tempoNum=[resul objectForKey:@"paredes"];
        //Inimigos
        for (int i=0; i<[tempoNum intValue]; i++) {
            NSDictionary *enemy=[resul objectForKey:[NSString stringWithFormat:@"parede%d",i+1]];
            
            
            
            SKSpriteNode *spri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(level1.tileSize, level1.tileSize)];
            
            
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
    level1=[[JAGLevel alloc] initWithHeight:20 withWidth:20];
    
    level1.gota=[[JAGGota alloc] initWithPosition:CGPointMake(level1.tileSize*2, level1.tileSize*2)];
    
    
    SKSpriteNode *wallSpri=[[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(level1.tileSize, level1.tileSize)];
    
    wallSpri.name=@"brownColor";
    
    JAGWall *parede=[[JAGWall alloc] initWithSprite:wallSpri];
    
    parede.position=CGPointMake(level1.tileSize*5, level1.tileSize*5);
    
    [level1.paredes setValue:parede forKey:@"parede1"];
    
    
    JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake(level1.tileSize*4, level1.tileSize*4)];
    
    inimigo.sprite.name=@"grenColor";
    
    inimigo.tipo=1;
    
    [level1.inimigos setValue:inimigo forKey:@"inimigo1"];
    
    level1.mundo=@1;
    
    level1.level=@1;
    
    //NSLog(@" Export: %@", [level1 exportar]);
    
    

}


@end
