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



@implementation JAGPlayGameScene{
    int width;
    int height;
    float timeTouch;
    float diferenca;
    CGPoint toqueInicio;
    SKShapeNode *circleMask;
    CGPoint toqueFinal;
    bool tocou;
    JAGLevel *level1;
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
    
    myWorld = [SKNode node];
    
    [self addChild:myWorld];
    
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    myWorld.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-width/2, -height/2) toPoint:CGPointMake(width/2, -height/2)];
    
    camera = [SKNode node];
    camera.name = @"camera";
    
    [myWorld addChild:camera];

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

#pragma mark - Máscara
-(void)createMask:(int) radius
       withPoint:(CGPoint) ponto{
    SKNode *area=[[SKNode alloc] init];
    
   
    
    circleMask = [[SKShapeNode alloc ]init];
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, 0, 0, 1, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    circleMask.path = circle;
    circleMask.lineWidth = radius*2; // replace 100 with DOUBLE the desired radius of the circle
    //circleMask.strokeColor = [SKColor redColor];
    circleMask.name=@"circleMask";

    
    
    circleMask.userInteractionEnabled = NO;
    //circleMask.zPosition=92;
    
    circleMask.fillColor = [SKColor clearColor];
    
    [area addChild:circleMask];
    
    
    area.position=CGPointMake(ponto.x,ponto.y-_gota.sprite.size.height);
    
    [_cropNode setMaskNode:area];
    
}


-(JAGGota *)createCharacter{
    _gota = [[JAGGota alloc] init];
    _gota.position = CGPointMake(0, -height/2.15+(platform.size.height));
    _gota.name = @"gota";

    _gota.sprite.name=@"gota";
    
    return _gota;
}

#pragma mark - Touch treatment
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        toqueInicio = [touch locationInNode:self];
        timeTouch = touch.timestamp;
        
        if ([_gota tocou:[touch locationInNode:self]]) {
            tocou = true;
        }else{
            tocou = false;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        toqueFinal = [touch locationInNode:self];
        //toqueFinal = [self CGPointNormalize:toqueFinal];
       
        
        //Se tocou na gota antes
        //Se tocou na gota antes
        if (tocou) {
            
        }else{
            
            switch ([self verificaSentido:toqueFinal with:_gota.position]) {
                case 1:
                     //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withTipe:1];
                    
                    break;
                case 2:
                     //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withTipe:2];
                    break;
                case 3:
                     //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withTipe:3];
                    break;
                case 4:
                     //toqueFinal = [self CGPointNormalize:toqueFinal];
                    [_gota mover:toqueFinal withInterval:1.0 withTipe:4];
                    
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

-(void)update:(NSTimeInterval)currentTime{
    //depois de um tempo ou acao
    float distance = hypotf(_fogo.position.x-_gota.position.x, _fogo.position.y-_gota.position.y);
    float pararMovimentoCONTROL = hypotf(toqueFinal.x-_gota.position.x, toqueFinal.y-_gota.position.y);

    circleMask.position = CGPointMake(_gota.position.x-100, _gota.position.y-50);
    if (distance <100) {
        
        [_fogo mover:(_gota.position) withInterval:2 withTipe:[self verificaSentido:_gota.position with:_fogo.position]];
    }
    else _fogo.physicsBody.velocity = CGVectorMake(0, 0);

    [_hud update];
    //NSLog(@"%f",pararMovimentoCONTROL);
    if (pararMovimentoCONTROL < 50)
        _gota.physicsBody.velocity = CGVectorMake(0, 0);
    
}

#pragma mark - Physics

- (void)didSimulatePhysics{
 //   [self centerOnNode: [self childNodeWithName: @"//"]];
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == GOTA) && (contact.bodyB.categoryBitMask == ENEMY)){
        NSLog(@"hit");
    }
    
    if((contact.bodyB.categoryBitMask == GOTA) && (contact.bodyA.categoryBitMask == ENEMY)){
        NSLog(@"hit");}
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
    float difx=pontoObjeto.x-pontoReferencia.x;
    
    //float dify=toqueFinals.y-toqueFinal.y;
    
    float dify=pontoObjeto.y-pontoReferencia.y;
    
    
    BOOL negx=false;;
    
    bool negy=false;
    
    if(difx<0){
        negx=true;
        difx*=-1;
    }
    if(dify<0){
        negy=true;
        dify*=-1;
    }
    
    if (difx>dify) {
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
