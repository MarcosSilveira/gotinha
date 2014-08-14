//
//  JAGPlayGameScene.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPlayGameScene.h"
#import "JAGLevel.h"


//extern CGPoint CGPointScale(CGPoint A, double b);
//extern CGPoint CGPointNormalize(CGPoint pt);
//extern double CGPointDot(CGPoint a, CGPoint b);
//extern double CGPointMagnitude(CGPoint pt);

@implementation JAGPlayGameScene {
    
    int width;
    int height;
    float timeTouch;
    float diferenca;
    CGPoint toqueInicio;
    SKShapeNode *circleMask;
    CGPoint toqueFinal;
    bool tocou_gota;
    CGMutablePathRef pathToDraw;
    SKShapeNode *lineNode;
    UIGestureRecognizer *separacao;

}

#pragma mark - Move to View
-(void)didMoveToView:(SKView *)view{
    diferenca = 80;
    width = self.scene.size.width;
    height = self.scene.size.height;
    
    //  [myWorld addChild:[self createCharacter]];
    self.physicsWorld.contactDelegate = (id)self;
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    [self touchesEnded:nil withEvent:nil];
    separacao = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(divideGota)];
    [self.view addGestureRecognizer:separacao];
    

}

-(id)initWithSize:(CGSize)size level:(NSNumber *)level andWorld:(NSNumber *)world {
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        
        _fogo = [[JAGFogoEnemy alloc] initWithPosition:CGPointMake(200, 100)];
        SKSpriteNode *obstaculo = [[SKSpriteNode alloc]initWithColor:([UIColor redColor]) size:(CGSizeMake(self.scene.size.width, 10)) ];
        obstaculo.position = CGPointMake(self.scene.size.width/2, 120);
        obstaculo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstaculo.size];
        obstaculo.physicsBody.dynamic = NO;
        obstaculo.physicsBody.categoryBitMask = ENEMY;
        obstaculo.physicsBody.collisionBitMask = GOTA;
        obstaculo.physicsBody.contactTestBitMask = GOTA;
        
        obstaculo.zPosition=10;
        
        obstaculo.physicsBody.restitution=0;
        obstaculo.name = @"wall";
        
        diferenca = 80.0f;
        tocou_gota = false;

        _cropNode = [[SKCropNode alloc] init];

        
        cropNode = [[SKCropNode alloc] init];
        
        [_cropNode addChild:[self createCharacter]];
        [self createMask:100 withPoint:(_gota.position)];
        [_cropNode addChild:_fogo];

        [self addChild: _cropNode];
        
        [self addChild: cropNode];
        [self createLevel];
    }
    return self;
}

#pragma mark - Métodos de inicialização
-(JAGGota *)createCharacter{
    
    _gota = [[JAGGota alloc] initWithPosition:CGPointMake(100, 100)];
    _gota.name = @"gota";
    
    return _gota;
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
    
    //Parades obstaculos
    
    //Inimigos
    
    //Posicao inicial da Gota.
    
    //
}

-(void)createLevel {
    
    JAGLevel *level1 = [[JAGLevel alloc] initWithHeight:20 withWidth:20];
    level1.gota = [[JAGGota alloc] initWithPosition:CGPointMake(level1.tileSize*2, level1.tileSize*2)];
    
    
    SKSpriteNode *wallSpri = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(level1.tileSize, level1.tileSize)];
    wallSpri.name = @"brownColor";
    
    JAGWall *parede = [[JAGWall alloc] initWithSprite:wallSpri];
    parede.position = CGPointMake(level1.tileSize*1, level1.tileSize*1);
    
    [level1.paredes setValue:parede forKey:@"parede1"];
    
    JAGFogoEnemy *inimigo=[[JAGFogoEnemy alloc] initWithPosition:CGPointMake(level1.tileSize*4, level1.tileSize*4)];
    
    inimigo.sprite.name = @"grenColor";
    inimigo.tipo = 1;
    
    [level1.inimigos setValue:inimigo forKey:@"inimigo1"];
    
    level1.mundo = @1;
    level1.level = @1;
    
    //[level1 exportar];
}

#pragma mark - Touch treatment

-(void)divideGota{
    if (tocou_gota && ! _gota.escondida)
        [_gota dividir];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    for (UITouch *touch in touches) {
        toqueInicio = [touch locationInNode:self];
        
        if ([_gota verificaToque:[touch locationInNode:self]]) {
            tocou_gota = true;
            toqueInicio = [touch locationInNode:self];
            [_gota esconder];
            
        } else {
            tocou_gota = false;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    for (UITouch *touch in touches) {
        
        toqueFinal = [touch locationInNode:self];

            
            switch ([self verificaSentido:toqueFinal with:_gota.position]) {
                case 1:
                    //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withType:1 and:300];
                    
                    break;
                case 2:
                    //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withType:2 and:300];
                    break;
                case 3:
                    //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withType:3 and:300];
                    break;
                case 4:
                    //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withType:4 and:300];
                    break;
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

-(void)update:(NSTimeInterval)currentTime {
    //depois de um tempo ou acao
    
    circleMask.position = CGPointMake(_gota.position.x - 100, _gota.position.y - 50);
    
    if ((self.fogo.physicsBody.velocity.dx <= 0) && (self.fogo.physicsBody.velocity.dy <= 0)) {
        [self moveInimigo];
    }
    
    [self followPlayer];
    [self pararMove];
    [self.hud update];
}

#pragma mark - Physics

- (void)didSimulatePhysics{
    //   [self centerOnNode: [self childNodeWithName: @"//"]];
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
        
        //        _gota.physicsBody.velocity=CGVectorMake(0, 0);
    }
    //   return detected;
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
#pragma mark - Tratamento de vetores

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

@end
