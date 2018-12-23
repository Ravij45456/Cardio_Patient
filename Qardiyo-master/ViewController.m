#import "ViewController.h"

// Required for AV Library.
#import <AVFoundation/AVFoundation.h>

#import "PulseDetector.h"
#import "Filter.h"

// Detail View controller comes right after the heartbeat is taken.
#import "DetailViewController.h"
#import "CircleProgressView.h"
#import "Session.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+DBPrivacyHelper.h"
#import "QardiyoHF-Swift.h"


    int flag_cnt;
    typedef NS_ENUM(NSUInteger, CURRENT_STATE) {
        STATE_PAUSED,
        STATE_SAMPLING
    };

#define MIN_FRAMES_FOR_FILTER_TO_SETTLE 10

    @interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, detailViewContollerProtocol>{
        
        // AVAudioPlayer is used to play sounds in Objective C.
        // Sound is always played whenever you see _audioPlayer play
        AVAudioPlayer *_audioPlayer;
        NSMutableArray *arraycounter;
        NSMutableArray *randomarray;
        
        int avg;
        int flash;
        NSString *avg1;
        
    }

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *camera;
@property(nonatomic, strong) PulseDetector *pulseDetector;
@property(nonatomic, strong) Filter *filter;
@property(nonatomic, assign) CURRENT_STATE currentState;
@property(nonatomic, assign) int validFrameCounter;

@property(nonatomic, strong) IBOutlet UILabel *pulseRate;
@property(nonatomic, strong) IBOutlet UILabel *validFrames;

@end

@implementation ViewController


- (IBAction)backButtonTapped:(id)sender {
    [self pause];
    [self stopAnimation_Action];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *tabViewController;
    tabViewController = [storyboard instantiateViewControllerWithIdentifier:@"goToTabBar"];
    [self presentViewController:tabViewController animated:true completion:nil];
  
  
}

@synthesize dataForPlot1;
@synthesize checkPreviousValue;
@synthesize frameCount;
@synthesize avgPulseRateArr;

@synthesize heartBtn;

@synthesize playOnce;
@synthesize bpmLbl,GraphArray;

// Animation
@synthesize circleProgressView, timer, session_animation;
@synthesize scroll;


- (void)viewDidLoad
{
    NSString *modelName = [UIDevice currentDevice].modelName;
    if([modelName isEqualToString:@"iPhone 5s"]){
        self.constraintMiddleCircle.constant = -182;
    }
    
    // Sets navigation bar color to light green
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:142.0/255.0 green:184.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    // Sets the title for the First page. Our heart rate monitor view.
    self.title = @"Take Measurement";
    
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:184.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    NSUserDefaults *d=[NSUserDefaults standardUserDefaults];
    [d setValue:@"yes" forKey:@"yes"];
    [d synchronize];

  
    // For playing the sound while heart beat is being recorded.
    // Turns file name into a path.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"heartbeat" ofType:@"wav"];
    // Gets path to the file.
    NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
    
    // Getting ready to play sound later in the code.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    _audioPlayer.numberOfLoops = 0;
    [_audioPlayer prepareToPlay];
    [super viewDidLoad];

   
  
   // [self hydrateDatasets];
    randomarray=[[NSMutableArray alloc]init];
    GraphArray=[[NSMutableArray alloc]init];
    arraycounter=[[NSMutableArray alloc]init];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    avgPulseRateArr = [[NSMutableArray alloc] init];
    
    self.filter=[[Filter alloc] init];
    self.pulseDetector=[[PulseDetector alloc] init];
    //[self startCameraCapture];

    frameCount = 0;
    checkPreviousValue = NO;
    [self generateGraph];
    [self CircularAnimation];
}

-(void)viewWillAppear:(BOOL)animated
{
  
    flash=0;
    _playOrNot = YES;
    
    self.myGraph.widthLine=1.f;
    self.myGraph.animationGraphEntranceTime = 16.0;
    self.myGraph.enableBezierCurve = YES;
    //[self myrelodata];
    [self hydrateDatasets];

    
    self.myGraph.widthLine=0.9;
    self.myGraph.backgroundColor = [UIColor clearColor];
    self.myGraph.colorTop = [UIColor colorWithRed:25/255.0 green:61/255.0 blue:77/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:25/255.0 green:61/255.0 blue:77/255.0 alpha:1.0];
    
    playOnce = NO;

    [super viewWillAppear:animated];

}

-(void)myrelodata
{
    float data;
    float low_bound = 10;
    float high_bound = 100;
    for (int i=0; i<20;i++)
    {
         data = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        [randomarray insertObject:[NSNumber numberWithFloat:data] atIndex:i];
    }
    
    self.avgPulseRateArr=randomarray;
    [self.myGraph reloadGraph];
    
}


-(void)myrelodataset
{
   
    flash=0;
    self.avgPulseRateArr=nil;
    [self.myGraph reloadGraph];
    // Starts the graph again
}

-(void)viewDidAppear:(BOOL)animated {
  
    flash=0;
    _playOrNot = YES;
    [self.myGraph reloadGraph];
    [super viewDidAppear:animated];
    [avgPulseRateArr removeAllObjects];
    [dataForPlot1 removeAllObjects];
    [self startCameraCapture];

}

-(void) viewWillDisappear:(BOOL)animated
{
    //[self.myGraph reloadGraph];
    [super viewWillDisappear:animated];
  
    [self pause];
    //[audioPlayer stop];

}

-(void) viewDidDisappear:(BOOL)animated{
  //[self.audioPlayer stop];
  _playOrNot = NO;
  [self stopCameraCapture];
  
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    NSLog(@"alertView inside ViewController.m");
}


#pragma mark - Circular Animation
-(void)CircularAnimation
{
    
    // MARK: Background's color.
    self.view.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:184.0/255.0 blue:72.0/255.0 alpha:1.0];

    self.session_animation = [[Session alloc] init];
    self.session_animation.state = kSessionStateStop;
    
    self.circleProgressView.status = @"";
    
    self.circleProgressView.timeLimit = 15;
    self.circleProgressView.elapsedTime = 0;
    
    // This controls the flashing heart when pulse is taken.
    [heartBtn setBackgroundImage:[UIImage imageNamed:@"Heart.png"] forState:UIControlStateNormal];
    [heartBtn setBackgroundImage:[UIImage imageNamed:@"heart45.png"] forState:UIControlStateHighlighted];
    
    [heartBtn setHighlighted:NO];
    
    [self startTimer];
}

#pragma mark - Timer
- (void)startTimer
{
    if ((!self.timer) || (![self.timer isValid])) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(poolTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


- (void)poolTimer
{
    //[audioPlayer play];
    if (self.session_animation.progressTime < 15) {
        
        if ((self.session_animation) && (self.session_animation.state == kSessionStateStart)){
            if(heartBtn.highlighted){
                
                [_audioPlayer pause];
                [heartBtn setHighlighted:NO];
            }else{
                [heartBtn setHighlighted:YES];
                
                // Plays heartbeat sound
                if (_playOrNot){
                   [_audioPlayer play];
                }
              
                
            }
            self.circleProgressView.elapsedTime = self.session_animation.progressTime;
            
            if (self.session_animation.progressTime > 10 && playOnce == NO) {
                playOnce = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                   // [_audioPlayer play];
                });
            }
        }
    }
    else{
        if (self.session_animation.progressTime > 15) {
          
            [audioPlayer pause];
            _playOrNot = NO;
            int totalPulseRate = 0;
            
            for (int i = 0; i <avgPulseRateArr.count; i++) {
              
                totalPulseRate = totalPulseRate + (int)[[avgPulseRateArr objectAtIndex:i] integerValue];
                
            }
            
            int avgPulseCount = totalPulseRate/avgPulseRateArr.count;
            NSLog(@"avg %d",avgPulseCount);
            [self stopAnimation_Action];
          
          
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailViewController *detailViewController;
            detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            detailViewController.avgPulse = avg; //avgPulseCount;
            detailViewController.delegate = self;
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:detailViewController];
            [self presentViewController:n animated:YES completion:nil];
        }
    }
}

-(void)saveDetailCalled : (DetailViewController *)detailViewController
{
    
    [detailViewController dismissViewControllerAnimated:YES completion:^{
        
        [self.tabBarController setSelectedIndex:1];

    }];
}

#pragma mark - User Interaction

- (void)startAnimation_Action

{
    if (self.session_animation.state == kSessionStateStop) {
        
        self.session_animation.startDate = [NSDate date];
        self.session_animation.finishDate = nil;
        self.session_animation.state = kSessionStateStart;
        
        
        [heartBtn setHighlighted:YES];
        //[_audioPlayer play];
        
        UIColor *tintColor = [UIColor colorWithRed:24.0/255.0 green:60.0/255.0 blue:76.0/255.0 alpha:1];
        self.circleProgressView.status = @"";
        
        self.circleProgressView.tintColor = tintColor;
        self.circleProgressView.elapsedTime = 0;
    }
}

// Function that gets called when heartbeat is finished.
-(void)stopAnimation_Action
{
    
    if (self.session_animation.state == kSessionStateStart) {
        self.session_animation.finishDate = [NSDate date];
        self.session_animation.state = kSessionStateStop;
        
        self.circleProgressView.status = @"";
        
        self.circleProgressView.tintColor = [UIColor redColor];
        self.circleProgressView.elapsedTime = self.session_animation.progressTime;
        
        [heartBtn setHighlighted:NO];
        
        [_audioPlayer stop];
        playOnce = NO;
        
        self.timer = nil;
        [self.timer invalidate];
        [self stopCameraCapture];
    
        
    }
    
}
-(void)resetAnimation_Action {
    self.session_animation = [[Session alloc] init];
    
    self.circleProgressView.status = @"";
    self.circleProgressView.tintColor = [UIColor colorWithRed:24.0/255.0 green:60.0/255.0 blue:76.0/255.0 alpha:1];
    self.session_animation.state = kSessionStateStop;
    self.circleProgressView.elapsedTime = self.session_animation.progressTime;
            [heartBtn setHighlighted:NO];
        [avgPulseRateArr removeAllObjects];
        [_audioPlayer stop];
        playOnce = NO;
    self.timer = nil;
    [self.timer invalidate];
}

#pragma mark - Generate Graph
-(void)generateGraph
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    }else{
        graph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 768, 300)];
    }
    
    CPTGraphHostingView *hostingView;
    
    hostingView.hostedGraph = graph;
    
    [self.view addSubview:hostingView];
    //[hostingView release];
    
    // Leave blank
    graph.paddingLeft = -1.0;
    graph.paddingTop = -1.0;
    graph.paddingRight = -1.0;
    graph.paddingBottom = -1.0;
    
    graph.plotAreaFrame.paddingLeft = 0.0 ;
    graph.plotAreaFrame.paddingTop = 0.0 ;
    graph.plotAreaFrame.paddingRight = 0.0 ;
    graph.plotAreaFrame.paddingBottom = 0.0 ;
    
    // Sets the coordinate range
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(322.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
    
    // Sets the coordinate scale size - 设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
    CPTXYAxis *x = axisSet.xAxis ;
    x. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    x. majorIntervalLength = CPTDecimalFromString (@"50");
    // 坐标原点： 0
    x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
    
    CPTXYAxis *y = axisSet.yAxis ;
    //y 轴：不显示小刻度线
    y. minorTickLineStyle = nil ;
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( @"50" );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
    
    //创建绿色区域
    //dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Green Plot";
    
    //设置绿色区域边框的样式
    //CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth = 1.f;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:215/255.0f green:39/255.0f blue:0/255.0f alpha:1.0];

    dataSourceLinePlot.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot.opacity = 0.0f;
    
    //设置数据元代理
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor clearColor] endingColor :[CPTColor clearColor]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    dataSourceLinePlot. areaFill = areaGradientFill;
    dataSourceLinePlot. areaBaseValue = CPTDecimalFromString ( @"0.9" );
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
    dataForPlot1 = [[NSMutableArray alloc] init];
    j1 = 320;
    r1 = 0;
    
    /*timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
     [timer1 fire];*/
    
}
-(void) startCameraCapture {
 
    // Create the AVCapture Session
    self.session = [[AVCaptureSession alloc] init];
    
    // Get the default camera device
    
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // switch on torch mode - can't detect the pulse without it
    
    // Create a AVCaptureInput with the camera device
    NSError *error=nil;
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:&error];
    if (cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
        
        return;
    }

    
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        
        NSLog(@"Torch mode on in start camera capture");
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        self.camera.torchMode = AVCaptureFlashModeOn;
        [self.camera unlockForConfiguration];

    }
  
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOff]){
      [self.camera lockForConfiguration:nil];
      self.camera.torchMode = AVCaptureTorchModeOn;
      [self.camera unlockForConfiguration];

    }


    // Set the output
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // create a queue to run the capture on
    dispatch_queue_t captureQueue=dispatch_queue_create("captureQueue", NULL);
    
    // setup ourself up as the capture delegate
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    // configure the pixel format
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];
    
    // set the minimum acceptable frame rate to 10 fps
    videoOutput.minFrameDuration = CMTimeMake(1, 10);
    
    // and the size of the frames we want - we'll use the smallest frame size available
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
   //  Add the input and output
    [self.session addInput:cameraInput];
    [self.session addOutput:videoOutput];
//
//    // Start the session
    [self.session startRunning];
    
    // we're now sampling from the camera
    self.currentState=STATE_SAMPLING;
    
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // update our UI on a timer every 0.1 seconds
    timerUpdateFrame = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    //Added By RAvi
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        
        NSLog(@"Torch mode on in start camera capture");
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        self.camera.torchMode = AVCaptureFlashModeOn;
        [self.camera unlockForConfiguration];
        
    }
    
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOff]){
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode = AVCaptureTorchModeOn;
        [self.camera unlockForConfiguration];
        
    }
    //**************//
    // Plays heartbeat sound
    [_audioPlayer play];
 }

// start capturing frames
-(void)stopCameraCapture {
    [self.session stopRunning];
    [audioPlayer stop];
    self.session=nil;
    [timerUpdateFrame invalidate];
}

#pragma mark - Pause and Resume of pulse detection

// Pausing turns the flash off.
-(void)pause
{
    [timerUpdateFrame invalidate];
    
    // If it is already paused, don't need to pause again. So just return.
    if(self.currentState == STATE_PAUSED)
        return;
    
    // switch off the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSLog(@"Torch mode Off in Pause");
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOff;
        [self.camera unlockForConfiguration];
    }
    self.currentState = STATE_PAUSED;
    
    // let the application go to sleep if the phone is idle
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) resume
{
    if(self.currentState!=STATE_PAUSED) return;
      // Create the AVCapture Session
    self.session = [[AVCaptureSession alloc] init];
    
    // Get the default camera device
    
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error=nil;
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:&error];
    if (cameraInput == nil) {
    
        NSLog(@"Error to create camera capture:%@",error);
        
        return;
    }
  
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSLog(@"Torch mode on in start camera capture");
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        self.camera.torchMode = AVCaptureFlashModeOn;
        [self.camera unlockForConfiguration];
    }
  
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOff]){
      [self.camera lockForConfiguration:nil];
      self.camera.torchMode = AVCaptureTorchModeOn;
      [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_SAMPLING;
    
    // update our UI on a timer every 0.1 seconds
    timerUpdateFrame = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(update) userInfo:nil repeats:YES];

    // stop the app from sleeping while rate is being taken.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

    // r,g,b values are from 0 to 1 // h = [0,360], s = [0,1], v = [0,1]
    //	if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
        float min, max, delta;
        min = MIN( r, MIN(g, b ));
        max = MAX( r, MAX(g, b ));
        *v = max;
        delta = max - min;
        if( max != 0 )
            *s = delta / max;
        else {
            // r = g = b = 0
            *s = 0;
            *h = -1;
            return;
        }
        if( r == max )
            *h = ( g - b ) / delta;
        else if( g == max )
            *h=2+(b-r)/delta;
        else
            *h=4+(r-g)/delta;
        *h *= 60;
        if( *h < 0 )
            *h += 360;
    }


// process the frame of video
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    //NSLog(@"captureOutput");
    // if we're paused don't do anything
    if(self.currentState == STATE_PAUSED)
    {
        // reset our frame counter
        self.validFrameCounter=0;
        return;
    }
    
    // this is the image buffer
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the image buffer
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    // access the data
    size_t width=CVPixelBufferGetWidth(cvimgRef);
    size_t height=CVPixelBufferGetHeight(cvimgRef);
    // get the raw image bytes
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    // and pull out the average rgb value of the frame
    float r=0,g=0,b=0;
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bprow;
    }
    r/=255*(float) (width*height);
    g/=255*(float) (width*height);
    b/=255*(float) (width*height);
    
    // convert from rgb to hsv colourspace
    float h,s,v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    // do a sanity check to see if a finger is placed over the camera
    if(s>0.5 && v>0.5)
    {
        // increment the valid frame count
        self.validFrameCounter++;
        
//        NSLog(@" couter %d",self.validFrameCounter);
       
        // filter the hue value - the filter is a simple band pass filter that removes any DC component and any high frequency noise
        float filtered=[self.filter processValue:h];
        // have we collected enough frames for the filter to settle?
        if(self.validFrameCounter > MIN_FRAMES_FOR_FILTER_TO_SETTLE) {
            // add the new value to the pulse detector

//       NSLog(@"Add value filtered:- %f",filtered);
            NSNumber *float1 = [NSNumber numberWithFloat:filtered];
            [arraycounter addObject:float1];
//           NSLog(@"my array value%@",arraycounter);
            [self.pulseDetector addNewValue:filtered atTime:CACurrentMediaTime()];
        }
        
    }
    else
    {
        self.validFrameCounter = 0;
        
        // clear the pulse detector - we only really need to do this once, just before we start adding valid samples
        [self.pulseDetector reset];
    }
}
    

-(void) update
{
    //NSLog(@"update");
    
    self.validFrames.text = [NSString stringWithFormat:@"Valid Frames: %d%%", MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE)];
    frameCount = MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE);

    NSLog(@"count frame %d",frameCount);
  
    
    if (frameCount  == 100)
    {
//        NSLog(@"start");
        [self startAnimation_Action];
        if (flash==0)
        {
             [self myrelodata];
            flash=1;
        }
        
    }
    else
    {
        
        [self resetAnimation_Action];
        [self myrelodataset];
        
    }
    
    // if we're paused then there's nothing to do
    if(self.currentState==STATE_PAUSED) return;
    
    // get the average period of the pulse rate from the pulse detector
    float avePeriod=[self.pulseDetector getAverage];

    
    if(avePeriod==INVALID_PULSE_PERIOD)
    {
        // no value available
        self.pulseRate.text=@"0";
        [self dataOpt:@"0"];
    }
    else
    {
        // got a value so show it
        float pulse= 60.0/avePeriod;
        
        //
        if (pulse < 10) {
            self.pulseRate.text = [NSString stringWithFormat:@"%0.0f", pulse];
        }
        else if (pulse < 100) {
            self.pulseRate.text = [NSString stringWithFormat:@"%0.0f", pulse];
        }
        else{
            self.pulseRate.text = [NSString stringWithFormat:@"%0.0f", pulse];
        }
        //
        
        self.pulseRate.text=[NSString stringWithFormat:@"%0.0f", pulse];
        avg=[self.pulseRate.text intValue];
       // appDelegate.heartBeatValue = pulse;
        
        [avgPulseRateArr addObject:self.pulseRate.text];
        [self dataOpt:self.pulseRate.text];
        
    }
}
    
- (void)dataOpt:(NSString *)tempStr{
    if (([tempStr isEqualToString:@"0"] && frameCount == 100) && ([tempStr isEqualToString:@"0"] && frameCount > 0)) {
        tempStr = [NSString stringWithFormat:@"%d",(rand()%15)];
    }
    //tempStr = @"100";
//   NSLog(@"tempStr- %@",tempStr);
    //添加随机数F
    if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"]) {
        NSString *xp = [NSString stringWithFormat:@"%d",j1];
        NSString *yp = [NSString stringWithFormat:@"%@",tempStr];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        [dataForPlot1 insertObject:point1 atIndex:0];
    }
    //刷新画板
    [graph reloadData];
   
    j1 = j1 + 10;
    r1 = r1 + 10;
}

#pragma mark - dataSourceOpt
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
   // NSLog(@"my %@",dataForPlot1);
    return [dataForPlot1 count];
   
}
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return (int)[self.avgPulseRateArr count];
    //return (float);
   
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
//   NSLog(@" final array %@",avgPulseRateArr);
    return [[self.avgPulseRateArr objectAtIndex:index] doubleValue];
    
}

- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.avgPulseRateArr) self.avgPulseRateArr = [[NSMutableArray alloc] init];
    // if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.avgPulseRateArr removeAllObjects];
    //  [self.arrayOfDates removeAllObjects];
    
    totalNumber = 0;
    BOOL showNullValue = true;
    
    // Add objects to the array based on the stepper value
    for (int i = 0; i < 10; i++)
    {
        [self.avgPulseRateArr addObject:@([self getRandomFloat])]; // Random values for the graph

        if (i == 0)
        {
            // [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else if (showNullValue && i == 0)
            
        {
            //[self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
            self.avgPulseRateArr[i] = @(BEMNullGraphValue);
        }
        
        totalNumber = totalNumber + [[self.avgPulseRateArr objectAtIndex:i] intValue]; // All of the values added together
    }
}

- (float)getRandomFloat{
    
    float i1 = (float)(arc4random() % 100) / 100 ;
    return i1;
}
    
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num;
    //让视图偏移
    if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
        num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
        if ( fieldEnum == CPTScatterPlotFieldX ) {
            num = [NSNumber numberWithDouble:[num doubleValue] - r1];
        }
    }
    return num;
}

@end
