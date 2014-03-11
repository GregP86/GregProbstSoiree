//
//  GGPAppDelegate.m
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPAppDelegate.h"
#import <Parse/Parse.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation GGPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryAmbient error: &setCategoryError];
    
    [Parse setApplicationId:@"KgCQPAoFvl80eCkuT76jIz80MzcB5biM31kX38EG"
                  clientKey:@"IMTjQhVsnezo69e1VuJ7huwpYmkdPjOpljIPeUXr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    //[PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
    
    
    //if([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        UIViewController *viewController;
        if(currentUser){
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainStart"];
        }else{
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInStart"];
        }
        self.window.rootViewController = viewController;
    //}else{
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        
     //   UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ipadStart"];
      //  self.window.rootViewController = viewController;
   // }
    
    
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}





-(void)fetchHashtag{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
