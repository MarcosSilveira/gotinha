//
//  JAGViewController.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 05/08/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGViewController.h"
#import "JAGPlayGameScene.h"
#import "JAGLevel.h"
#import "JAGCreatorLevels.h"
#import "JAGMenu.h"
#import "JAGVida.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@implementation JAGViewController

- (void)viewWillLayoutSubviews
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // Configure the view.
    SKView *skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.

    SKScene *sceneMenu = [[JAGMenu alloc] initWithSize:skView.bounds.size];
    sceneMenu.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene \\
    
    JAGVida *vida=[JAGVida sharedManager];
    
    [vida fazerConsultas:0];
    
    [skView presentScene:sceneMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callAd)
                                                 name:@"showAd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(hideAd)
                                                name:@"hideAd"
                                              object:nil];

//    [self configAd];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
-(void)configAd{
    //    GADBannerView *teste = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(self.view.frame.size.height*0.2,self.view.frame.size.width*0.65);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    _teste = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait
                                                          origin:origin];
    // Replace this ad unit ID with your own ad unit ID.
    _teste.adUnitID = @"ca-app-pub-8973901634750853/3056548120";
    _teste.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ GAD_SIMULATOR_ID, @"MY_TEST_DEVICE_ID" ];
    [_teste loadRequest:request];
    //    teste.frame.origin = CGPointMake(0, 0);
   
    _teste.hidden = YES;
    [self.view addSubview:_teste];

}
-(void)callAd{
    _teste.hidden = NO;
    
}
-(void)hideAd{
    self.teste.hidden = YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
