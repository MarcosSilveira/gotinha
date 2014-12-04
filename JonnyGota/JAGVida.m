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

static JAGVida *sharedMyManager;


-(void)consultar{
    
    
    if (self.vidas<MAXLife) {
        //Pegar a ultima salva e conferir a diferença
        
        //Carregar Ultima Date do NSUserDefaults
        
        NSDate *savedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDate"];
        
        
        //Date Time de agora
        NSDate *now = [NSDate date];
        
        
        
        if (savedDate!=nil) {
            //Calcular a diferenca
            NSTimeInterval timeDifference = [now timeIntervalSinceDate:savedDate];
            
            
            
            //Calula minutos
            
            int minutes = floor(timeDifference/60);
            //        NSLog(@"diferenca: %f",timeDifference);
            
            //Se for maior salva
            if (minutes>=TIMEMinutos) {
                if (minutes<TIMEMinutos*5 &&self.vidas+minutes/TIMEMinutos<=MAXLife) {
                    self.vidas=self.vidas+(1*(minutes/TIMEMinutos));
                    
                }else{
                    self.vidas=MAXLife;
                }
                
                 NSLog(@"Salvando as Life tudo vidas:%d",self.vidas);
                
                
                [[NSUserDefaults standardUserDefaults] setInteger:self.vidas forKey:@"Vida"];
                [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"savedDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }

        }else{
            
            self.vidas=MAXLife;
            
            //Salve
            
            NSLog(@"Iniciando as Lifes tudo");
            [[NSUserDefaults standardUserDefaults] setInteger:self.vidas forKey:@"Vida"];
            [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"savedDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }else{
        
        NSDate *now = [NSDate date];
        
        [[NSUserDefaults standardUserDefaults]setObject:now forKey:@"savedDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
                                        repeats:YES];
        self.inprogress=YES;
    }
    
}


-(int)consultarTempoParaVida{
    NSDate *savedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedDate"];
    
    
    //Date Time de agora
    NSDate *now = [NSDate date];
    
    
    
    if (savedDate!=nil) {
        //Calcular a diferenca
        NSTimeInterval timeDifference = [now timeIntervalSinceDate:savedDate];
        
        
        
        //Calula minutos
        
        int minutes = floor(timeDifference/60);
        //        NSLog(@"diferenca: %f",timeDifference);
        
        //Se for maior salva
        if (minutes<30 && minutes>0) {
            return 30-minutes;
        }
    }
    
    
    return 0;
}


-(void)changeGamepad{
    self.gamePad=!self.gamePad;
    
    //Salvar no User defaults
    
    [[NSUserDefaults standardUserDefaults] setBool:self.gamePad forKey:@"gamePad"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)sharedManager {
    if (sharedMyManager==nil) {
        sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
//      self.vida = [[JAGVida alloc] init];
//        if ([NSUS]) {[[NSUserDefaults standardUserDefaults]setInteger:[nextlevel integerValue] forKey:@"faseAtual"];
//        }
        
        
        self.vidas = [[NSUserDefaults standardUserDefaults] integerForKey:@"Vida"];
        
        self.gamePad=[[NSUserDefaults standardUserDefaults] boolForKey:@"gamePad"]; 
        self.inprogress=NO;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"savedDate"]==nil) {
            self.vidas=5;
            
            self.gamePad=YES;
            
            [[NSUserDefaults standardUserDefaults] setBool:self.gamePad forKey:@"gamePad"];
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.vidas forKey:@"Vida"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
//        self.vidas=1;

    }
    return self;
}


@end
