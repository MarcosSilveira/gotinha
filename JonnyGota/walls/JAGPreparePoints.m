//
//  JAGPreparePoints.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 16/09/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGPreparePoints.h"

@implementation JAGPreparePoints

-(BOOL)procurarProximo:(NSMutableArray *)nodes
          withTileSize:(int) tilesize{
    
    if (nodes.count>1) {
        
    }
    
    for(int i=0;i<nodes.count;i++){
        JAGPreparePoints *ponto=(JAGPreparePoints *)nodes[i];
        
//        NSLog(@"ponto.x: %f  ponto.y: %f meuPonto.x: %f meuPonto.y: %f",ponto.ponto.x,ponto.ponto.y, self.ponto.x, self.ponto.y);
        
        if(ponto.ponto.x+tilesize==self.ponto.x && ponto.ponto.y==self.ponto.y){
            self.proximo=ponto;
            self.proximo.usado=false;
            self.proximo.antes=true;
        }
        if(ponto.ponto.y-tilesize==self.ponto.y && ponto.ponto.x==self.ponto.x){
            self.proximoAlto=ponto;
             self.proximoAlto.usadoAlto=false;
            
//            NSLog(@"Aqui  y");

//            return true;
        }
    }
    return false;
}

@end
