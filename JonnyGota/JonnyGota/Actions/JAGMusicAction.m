//
//  JAGMusicAction.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 29/10/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGMusicAction.h"

@implementation JAGMusicAction

-(instancetype)initWithMusic:(Musica *)music{
    self=[super init];
    
    self.musica=music;
    
    [self.musica changeVolume:1.0];
    
    self.paused=YES;
    

    
    return self;
}


-(void)dealloc{
    
//    [self.musica stop];
   
}

-(void)play{
    if (self.paused==YES) {
        [self.musica playInLoop];
        self.paused=NO;
    }
    
}

-(void)stop{
    if (self.paused==NO) {
        [self.musica stop];
        self.paused=YES;
    }
}

@end
