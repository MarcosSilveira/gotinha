//
//  JAGLevel.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 12/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGLevel.h"

@implementation JAGLevel



-(instancetype)initWithHeight:(int)height withWidth:(int)width{
    self=[super init];
    
    
    _width=width;
    
    _height=height;
    
    _tileSize=32;
    
    _inimigos=[[NSMutableDictionary alloc] init];
    
    _paredes=[[NSMutableDictionary alloc] init];
    
    _itens=[[NSMutableDictionary alloc] init];
    
    return self;
}


-(void)exportar{
    
    NSMutableDictionary *jsonFinal=[[NSMutableDictionary alloc] init];
    
    NSNumber *temp=[[NSNumber alloc] initWithFloat:self.width];
    
    [jsonFinal setObject:temp forKey:@"width"];
    
    temp=[[NSNumber alloc] initWithFloat:self.height];
    
    [jsonFinal setObject:temp forKey:@"height"];
    
    [jsonFinal setObject:_mundo forKey:@"mundo"];
    
    [jsonFinal setObject:_level forKey:@"level"];
    
    //Salvar tileSize?
    
    /*
    temp=[[NSNumber alloc] initWithFloat:self.tileSize];
    
    [jsonFinal setObject:temp forKey:@"tileSize"];
     */
    
    
    [jsonFinal setObject:[_gota createJson] forKey:@"gota"];


    
    NSArray *chaves=[_paredes allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGWall *temps=[_paredes objectForKey:chaves[i]];
        //NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
        //NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        [jsonFinal setObject:[temps createJson] forKey:chaves[i]];
        
    }
    
    /*
    chaves=[_itens allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGWall *temps=[_itens objectForKey:chaves[i]];
        NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
        NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        [jsonFinal setObject:json2 forKey:chaves[i]];
    }
    
    */
    
    
    chaves=[_inimigos allKeys];
    
    for (int i=0; i<_paredes.count; i++) {
        
        JAGInimigos *temps=[_inimigos objectForKey:chaves[i]];
        //NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:[temps createJson] options:kNilOptions error:nil];
       // NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];
        //[jsonFinal setObject:json2 forKey:chaves[i]];
        
        [jsonFinal setObject:[temps createJson] forKey:chaves[i]];
    }
    

    
    NSData *dataJson2 = [NSJSONSerialization dataWithJSONObject:jsonFinal options:kNilOptions error:nil];
    NSString* json2 = [[NSString alloc] initWithData:dataJson2 encoding:NSUTF8StringEncoding];

    
    NSLog(@"\n\n%@",json2);
}

@end
