//
//  ViewController.h
//  SampleHeartRateApp
//
//  Created by chris on 08/03/2015.
//  Copyright (c) 2015 CMG Research Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CorePlot/CorePlot.h>
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
#import "BEMSimpleLineGraphView.h"
#import <AudioToolbox/AudioServices.h>
#import "ViewController.h"
//#import <GoogleMobileAds/GADInAppPurchaseDelegate.h>
//#import <GoogleMobileAds/GADInterstitialDelegate.h>
//#import <GoogleMobileAds/GADRequest.h>
//#import <GoogleMobileAds/GADRequestError.h>

@class AppDelegate;
@class CircleProgressView;
@class Session;
@class DatabaseManager;
@class AdMobViewController;

@interface ViewController : UIViewController<CPTPlotDataSource,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,AVAudioPlayerDelegate>{
    AppDelegate *appDelegate;
    CPTXYGraph                  *graph;
    CPTScatterPlot              *dataSourceLinePlot;
    NSMutableArray              *dataForPlot1;
    NSTimer                     *timer1;
    int                         j1;
    int                         r1;
    int totalNumber;
    int previousStepperValue;
     AVAudioPlayer __strong *audioPlayer;

    NSTimer *timerUpdateFrame;
    
    DatabaseManager *DBManager;
    IBOutlet UIView *admobView;
    AdMobViewController *adMobViewController;
}
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMiddleCircle;

@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property(nonatomic,retain)NSMutableArray *GraphArray;
@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@property (nonatomic, assign) BOOL checkPreviousValue;
@property (nonatomic, assign) int frameCount;

//Animation
@property (strong, nonatomic) IBOutlet CircleProgressView *circleProgressView;
- (IBAction)startButton:(UIButton *)sender;

//Animation
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, retain) Session *session_animation;

@property (nonatomic, retain) NSMutableArray *avgPulseRateArr;
-(void) startCameraCapture;
-(void) stopCameraCapture;
-(void) pause;
-(void) resume;
@property (nonatomic, retain) IBOutlet UIButton *heartBtn;
- (IBAction)dismiss:(UIBarButtonItem *)sender;

- (IBAction)backButtonTapped:(id)sender;


@property (nonatomic, assign) BOOL playOnce;
@property (nonatomic, assign) BOOL playOrNot;
@property (nonatomic, retain) IBOutlet UILabel *bpmLbl;

@end

