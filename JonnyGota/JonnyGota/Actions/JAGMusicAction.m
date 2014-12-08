//
//  JAGMusicAction.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 29/10/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#define Pass 4
#import "JAGMusicAction.h"

@implementation JAGMusicAction


int playing;

NSTimer *ti;


-(instancetype)init{
    self=[super init];
    
    self.paused=YES;

    playing=-1;
    
    self.managerSound=[JAGManagerSound sharedManager];
    
    [self loading];
    
    
    return self;
}

//-(void)addNewMusica:(Musica *)musica{
//    [self.Musicas addObject:musica];
//}

-(void)loading{
    for (int i=1; i<Pass+1; i++) {
        NSString *tem=[NSString stringWithFormat:@"passo%d",i];
        
        [self.managerSound addSound:tem withEffects:false withKey:tem];
        
        [self.managerSound changeVolume:tem withSound:0.8];
        
//        [andar changeVolume:0.9];
//        [self addNewMusica:andar];
    }
}

-(void)dealloc{
    
//    [self.musica stop];
   
}

-(void)soltar{
    
    for (int i=1; i<Pass+1;i++) {
        NSString *tem=[NSString stringWithFormat:@"passo%d",i];
        [self.managerSound stopSound:tem];
    }

}

-(void)play{

    if (self.paused==YES) {
        //int x = arc4random() % self.Musicas.count;
        int x=arc4random_uniform(Pass)+1;
        
        NSString *tem=[NSString stringWithFormat:@"passo%d",x];

        
//        Musica *temp=self.Musicas[x];
        
//        NSLog(@"%d",x);
//        [temp playInLoop];
        [self.managerSound playSound:tem];
//        [temp play];
        playing=x;
        self.paused=NO;
        
        ti=[NSTimer timerWithTimeInterval:[self.managerSound duration:tem] target:self selector:@selector(plays:) userInfo:nil repeats:NO];
        
//        NSRunLoop *runner = [NSRunLoop currentRunLoop];
//        [runner addTimer:ti forMode: NSDefaultRunLoopMode];
        
        [[NSRunLoop mainRunLoop] addTimer:ti forMode:NSRunLoopCommonModes];

        
//        SKAction *next=[SKAction sequence:@[[SKAction waitForDuration:temp.duration],
//                                            [SKAction runBlock:^{
//             NSLog(@"Funcionou?");
//            [self play];
//        }]
//                                            ]];
//        
//        [_nodo runAction:next];
    }
    
}

//Play with timet
-(void)plays:(NSTimer*)timer{
//    if (self.paused==YES) {
        //int x = arc4random() % self.Musicas.count;
        [timer invalidate];
        int x=arc4random_uniform(Pass);
        
    
        
        
//        Musica *temp=self.Musicas[x];
    
//        [temp play];
    
    NSString *tem=[NSString stringWithFormat:@"passo%d",x];
    [self.managerSound playSound:tem];

        playing=x;
        self.paused=NO;
        
        ti=[NSTimer timerWithTimeInterval:[self.managerSound duration:tem] target:self selector:@selector(plays:) userInfo:nil repeats:NO];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:ti forMode: NSDefaultRunLoopMode];
//    }

}

-(void)stop{
    if (self.paused==NO) {
        
        NSString *tem=[NSString stringWithFormat:@"passo%d",playing];

        
        [self.managerSound stopSound:tem];
        
//        Musica *temp=self.Musicas[playing];
        
        [ti invalidate];
        
//        [temp stop];
//        playing=x;
//        [self.musica stop];
        self.paused=YES;
        
        playing=-1;
//        [_nodo removeAllActions];
    }
}

@end
