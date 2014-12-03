//
//  JAGMusicAction.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 29/10/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMusicAction.h"

@implementation JAGMusicAction
int playing;

-(instancetype)initWithMusic:(Musica *)music{
    self=[super init];
    
    self.musica=music;
    
    [self.musica changeVolume:0.9];
    
    self.paused=YES;
    
    self.Musicas=[[NSMutableArray alloc] init];

    playing=-1;
    
    [self addNewMusica:music];
    
    [self loading];
    
    return self;
}

-(void)addNewMusica:(Musica *)musica{
    [self.Musicas addObject:musica];
}

-(void)loading{
    for (int i=1; i<5; i++) {
        NSString *tem=[NSString stringWithFormat:@"passo%d",i];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:tem ofType:@"caf"];
        NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
        
        Musica *andar;
        andar=[[Musica alloc] init];
        
        [andar inici];
        
        [andar carregar:fileUrl withEffects:false];
        
        [andar changeVolume:0.9];
        [self addNewMusica:andar];
    }
    

}

-(void)dealloc{
    
//    [self.musica stop];
   
}

-(void)play{
    
    
    if (self.paused==YES) {
        //int x = arc4random() % self.Musicas.count;
        int x=arc4random_uniform(self.Musicas.count);
        Musica *temp=self.Musicas[x];
        
//        NSLog(@"%d",x);
        [temp playInLoop];
        playing=x;
        self.paused=NO;
    }
    
}

-(void)stop{
    if (self.paused==NO) {
        Musica *temp=self.Musicas[playing];
        
        [temp stop];
//        playing=x;
//        [self.musica stop];
        self.paused=YES;
    }
}

@end
