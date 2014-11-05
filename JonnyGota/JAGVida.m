//
//  JAGVida.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/11/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//




#import "JAGVida.h"

#define MAXLife 5
#define TIMEMinutos 30

@implementation JAGVida

-(void)consultar{
    
    
    if (self.vidas<MAXLife) {
        //Pegar a ultima salva e conferir a diferença
        
        //Carregar Ultima Date do NSUserDefaults
        
        NSDate *savedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDate"];
        
        
        //Date Time de agora
        NSDate *now = [NSDate date];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSString *after_string = [dateFormatter stringFromDate:after];
////        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR_POSIX"]];
//        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
       
        
        if (savedDate!=nil) {
            //Calcular a diferenca
            NSTimeInterval timeDifference = [savedDate timeIntervalSinceDate:now];
            
            
            
            //Calula minutos
            
            int minutes = floor(timeDifference/60);
            //        NSLog(@"diferenca: %f",timeDifference);
            
            //Se for maior salva
            if (minutes>TIMEMinutos) {
                self.vidas++;
                [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"savedDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }

        }else{
            self.vidas=MAXLife;
            [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"savedDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }

}

-(void)fazerConsultas:(int)time{
    //CRIAR NSTIMER QUE FAZ CONSULTAS DE TEMPOS
    
    //In progress?
    if (!self.inprogress) {
        [self consultar];
        
        int times=TIMEMinutos*60;
        
        [NSTimer scheduledTimerWithTimeInterval:times
                                         target:self
                                       selector:@selector(consultar)
                                       userInfo:nil
                                        repeats:NO];
        
        self.inprogress=YES;
    }
    
}

+ (id)sharedManager {
    static JAGVida *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.vida = [[JAGVida alloc] init];
        self.inprogress=NO;
    }
    return self;
}


@end
