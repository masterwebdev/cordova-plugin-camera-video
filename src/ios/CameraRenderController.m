#import "CameraRenderController.h"
#import <CoreVideo/CVOpenGLESTextureCache.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

@implementation CameraRenderController
@synthesize context = _context;
@synthesize delegate;


- (CameraRenderController *)init {
  if (self = [super init]) {
    self.renderLock = [[NSLock alloc] init];
  }
  return self;
}

- (void)loadView {
  GLKView *glkView = [[GLKView alloc] init];
  [glkView setBackgroundColor:[UIColor blackColor]];
  [self setView:glkView];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }

  CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, self.context, NULL, &_videoTextureCache);
  if (err) {
    NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
    return;
  }

  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  view.contentMode = UIViewContentModeScaleToFill;

  glGenRenderbuffers(1, &_renderBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);

  self.ciContext = [CIContext contextWithEAGLContext:self.context];

  if (self.dragEnabled) {
    //add drag action listener
    NSLog(@"Enabling view dragging");
    UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:drag];
  }

  if (self.tapToFocus && self.tapToTakePicture){
    //tap to focus and take picture
    UITapGestureRecognizer *tapToFocusAndTakePicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (handleFocusAndTakePictureTap:)];
    [self.view addGestureRecognizer:tapToFocusAndTakePicture];

  } else if (self.tapToFocus){
    // tap to focus
    UITapGestureRecognizer *tapToFocusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (handleFocusTap:)];
    [self.view addGestureRecognizer:tapToFocusGesture];

  } else if (self.tapToTakePicture) {
    //tap to take picture
    UITapGestureRecognizer *takePictureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTakePictureTap:)];
    [self.view addGestureRecognizer:takePictureTap];
  }

  self.view.userInteractionEnabled = self.dragEnabled || self.tapToTakePicture || self.tapToFocus;
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(appplicationIsActive:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationEnteredForeground:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];

  dispatch_async(self.sessionManager.sessionQueue, ^{
      NSLog(@"Starting session");
      [self.sessionManager.session startRunning];
      });
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidBecomeActiveNotification
                                                object:nil];

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];

  dispatch_async(self.sessionManager.sessionQueue, ^{
      NSLog(@"Stopping session");
      [self.sessionManager.session stopRunning];
      });
}

- (void) handleFocusAndTakePictureTap:(UITapGestureRecognizer*)recognizer {
  NSLog(@"handleFocusAndTakePictureTap");

  // let the delegate take an image, the next time the image is in focus.
  [self.delegate invokeTakePictureOnFocus];

  // let the delegate focus on the tapped point.
  [self handleFocusTap:recognizer];
}

- (void) handleTakePictureTap:(UITapGestureRecognizer*)recognizer {
  NSLog(@"handleTakePictureTap");
  [self.delegate invokeTakePicture];
}

- (void) handleFocusTap:(UITapGestureRecognizer*)recognizer {
  NSLog(@"handleTapFocusTap");

  if (recognizer.state == UIGestureRecognizerStateEnded)    {
    CGPoint point = [recognizer locationInView:self.view];
    [self.delegate invokeTapToFocus:point];
  }
}

- (void) onFocus{
  [self.delegate invokeTakePicture];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void) appplicationIsActive:(NSNotification *)notification {
  dispatch_async(self.sessionManager.sessionQueue, ^{
      NSLog(@"Starting session");
      [self.sessionManager.session startRunning];
      });
}

- (void) applicationEnteredForeground:(NSNotification *)notification {
  dispatch_async(self.sessionManager.sessionQueue, ^{
      NSLog(@"Stopping session");
      [self.sessionManager.session stopRunning];
      });
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

dispatch_sync(dispatch_get_main_queue(), ^{

    //CMTime  presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    //video alex
    if (self.sessionManager.isRecording == YES) {
        
        //NSLog(self.sessionManager.firstFrame ? @"firstFrame Yes" : @"firstFrame No");
        //captureOutput == self.sessionManager.audioDataOutput &&
        
        if (writer.status == AVAssetWriterStatusFailed) {
            return;
        }
        
        /*if (writer.status == 0) {
            return;
        }*/
        
        //if (captureOutput == self.sessionManager.dataOutput && writer.status != AVAssetWriterStatusWriting ) {
        if (captureOutput == self.sessionManager.dataOutput && writer.status == AVAssetWriterStatusUnknown ) {
            
            //NSLog(@"CAPTURE STATUS %tu", writer.status);
            
            @try {
                //[videoWriterInput appendSampleBuffer:sampleBuffer];
            
            if ([writer startWriting]) {
                    
                    //timeVideoWriteStart = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    CMTime presentationStartTime = CMTimeMakeWithSeconds(CACurrentMediaTime(), 240);
                    
                    //lastpresentationTimeStamp
                    
                    lastpresentationTimeStamp=kCMTimeZero;
                    
                    [writer startSessionAtSourceTime:presentationStartTime];
                }
            }
            @catch (NSException *exception) {
            NSLog(@"START WRITING FAIL");
                [self resetWriter2];
            }
        }
        
        
        if (captureOutput == self.sessionManager.dataOutput) {
            
            if( [videoWriterInput isReadyForMoreMediaData] )
            {
                
                [self newVideoSample:sampleBuffer];
                self.sessionManager.firstFrame=YES;
            }else{
                
                [self resetWriter];
            }
        }else if( captureOutput == self.sessionManager.audioDataOutput && self.sessionManager.firstFrame == YES)
        {
            
            if( [audioWriterInput isReadyForMoreMediaData] )
            {
                [self newAudioSample:sampleBuffer];
            }
        }
    }
    
  //video alex
  //if ([self.renderLock tryLock]) {
  if (captureOutput != self.sessionManager.audioDataOutput && [self.renderLock tryLock]) {

    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];


    CGFloat scaleHeight = self.view.frame.size.height/image.extent.size.height;
    CGFloat scaleWidth = self.view.frame.size.width/image.extent.size.width;

    CGFloat scale, x, y;
    if (scaleHeight < scaleWidth) {
      scale = scaleWidth;
      x = 0;
      y = ((scale * image.extent.size.height) - self.view.frame.size.height ) / 2;
    } else {
      scale = scaleHeight;
      x = ((scale * image.extent.size.width) - self.view.frame.size.width )/ 2;
      y = 0;
    }

    // scale - translate
    CGAffineTransform xscale = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform xlate = CGAffineTransformMakeTranslation(-x, -y);
    CGAffineTransform xform =  CGAffineTransformConcat(xscale, xlate);

    CIFilter *centerFilter = [CIFilter filterWithName:@"CIAffineTransform"  keysAndValues:
      kCIInputImageKey, image,
      kCIInputTransformKey, [NSValue valueWithBytes:&xform objCType:@encode(CGAffineTransform)],
      nil];

    CIImage *transformedImage = [centerFilter outputImage];

    // crop
    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
    CIVector *cropRect = [CIVector vectorWithX:0 Y:0 Z:self.view.frame.size.width W:self.view.frame.size.height];
    [cropFilter setValue:transformedImage forKey:kCIInputImageKey];
    [cropFilter setValue:cropRect forKey:@"inputRectangle"];
    CIImage *croppedImage = [cropFilter outputImage];

    //fix front mirroring
    if (self.sessionManager.defaultCamera == AVCaptureDevicePositionFront) {
      CGAffineTransform matrix = CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), 0, croppedImage.extent.size.height);
      croppedImage = [croppedImage imageByApplyingTransform:matrix];
    }

    self.latestFrame = croppedImage;

    CGFloat pointScale;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)]) {
      pointScale = [[UIScreen mainScreen] nativeScale];
    } else {
      pointScale = [[UIScreen mainScreen] scale];
    }
    CGRect dest = CGRectMake(0, 0, self.view.frame.size.width*pointScale, self.view.frame.size.height*pointScale);

    [self.ciContext drawImage:croppedImage inRect:dest fromRect:[croppedImage extent]];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    [(GLKView *)(self.view)display];
    [self.renderLock unlock];
  }

   });
}

- (void)viewDidUnload {
  [super viewDidUnload];

  if ([EAGLContext currentContext] == self.context) {
    [EAGLContext setCurrentContext:nil];
  }
  self.context = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotate {
  return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self.sessionManager updateOrientation:[self.sessionManager getCurrentOrientation:toInterfaceOrientation]];
}

//video alex
CMTime timeVideoWriteStart;
CMTime lastpresentationTimeStamp;
NSString *pathString;
NSURL *exportURL;
AVAssetWriter *writer;
AVAssetWriterInput *videoWriterInput;
AVAssetWriterInput *audioWriterInput;
AVAssetWriterInputPixelBufferAdaptor *avAdaptor;

//video alex
- (void)makeWriter{
    
    //NSLog(@"MAKE WRITER");
    
    
    /*NSString *guid = [[NSUUID new] UUIDString];
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@/%@.mov", @"Documents", guid];
    self.sessionManager.videoPath = [NSHomeDirectory()stringByAppendingPathComponent:uniqueFileName];
	
	if (self.sessionManager.videoPath == (id)[NSNull null] || self.sessionManager.videoPath.length == 0 ){
		self.sessionManager.videoPath=[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"sftemp.mov"];
	}*/

  	NSString* tmpPath = [NSTemporaryDirectory()stringByStandardizingPath];

    NSFileManager* fileMgr = [[NSFileManager alloc] init]; // recommended by Apple (vs [NSFileManager defaultManager]) to be threadsafe
    NSString* filePath;

    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/%@%04d.%@", tmpPath, @"cpcp_video_", i++, @"mov"];
    } while ([fileMgr fileExistsAtPath:filePath]);

    self.sessionManager.videoPath=filePath;
    
    exportURL = [NSURL fileURLWithPath:self.sessionManager.videoPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportURL.path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportURL.path error:nil];
    }
    NSError* error;
    writer = [[AVAssetWriter alloc] initWithURL:exportURL
                                       fileType:AVFileTypeMPEG4
                                          //fileType:AVFileTypeQuickTimeMovie
                                          error:&error];
    
    if (error) {
        //return;
    }
    
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithDouble:4*1024.0*1024.0], AVVideoAverageBitRateKey,
                                           nil ];
    
    NSDictionary *videoSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  AVVideoCodecH264, AVVideoCodecKey,
                                  [NSNumber numberWithInt:1024], AVVideoWidthKey,
                                  [NSNumber numberWithInt:768], AVVideoHeightKey,
                                  videoCompressionProps, AVVideoCompressionPropertiesKey,
                                  nil];
    
    videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:videoSetting];
    
    
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    /*NSDictionary* bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey,
                                      [NSNumber numberWithInt:1024], kCVPixelBufferWidthKey,
                                      [NSNumber numberWithInt:768], kCVPixelBufferHeightKey,
                                      nil];
    avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput sourcePixelBufferAttributes:bufferAttributes];*/
    
    // Add the audio input
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    NSDictionary* audioOutputSettings = nil;
    
    audioOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                           [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                           [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
                           [ NSData dataWithBytes: &acl length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                           [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
                           nil];
    
    audioWriterInput = [AVAssetWriterInput
                        assetWriterInputWithMediaType: AVMediaTypeAudio
                        outputSettings: audioOutputSettings ];
    
    
    audioWriterInput.expectsMediaDataInRealTime = YES;
    // add input
    @try {
        if ([writer canAddInput:videoWriterInput]) {
            [writer addInput:videoWriterInput];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error while add video input: %@", [exception reason]);
        self.sessionManager.isRecording=NO;
    }
    
    @try {
        if ([writer canAddInput:audioWriterInput]) {
            [writer addInput:audioWriterInput];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error while add audio input: %@", [exception reason]);
        self.sessionManager.isRecording=NO;
    }

    //[writer addInput:videoWriterInput];
    //[writer addInput:audioWriterInput];
    
}

- (void) cleanupWriter {
    writer = nil;
    avAdaptor = nil;
    videoWriterInput = nil;
    audioWriterInput = nil;
}

- (void)startWriter{
    
    [writer startWriting];
    
}

- (void)stopWriter{
    
    //[videoWriterInput markAsFinished];
    //[audioWriterInput markAsFinished];
    
    //[writer endSessionAtSourceTime:sourceTime];
    
    @try{
    
    [writer finishWritingWithCompletionHandler:^(){
        [self cleanupWriter];
        writer = nil;
        [self.delegate stopRecordFinished];
    }];
        
        }@catch(NSException *exception) {
            NSLog(@"stopWriter FAIL");
        }
}

- (void)resetWriter{
    
    
    //[videoWriterInput markAsFinished];
    //[audioWriterInput markAsFinished];
    
    //[writer endSessionAtSourceTime:sourceTime];
    
    @try {
    
        [writer finishWritingWithCompletionHandler:^(){
            [self cleanupWriter];
            writer = nil;
            
            self.sessionManager.writeFrames=0;
            self.sessionManager.firstFrame=NO;
            
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.3];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
            
            [self makeWriter];
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"RESET WRITER FAIL FAIL!!!!!!!!!");
        [self resetWriter2];
        //NSLog(@"Gosh!!! %@", [exception callStackSymbols]);
    }
}

- (void)resetWriter2{
    
    //NSLog(@"STOOOOOOOOOOOOOP1");
    
        [self cleanupWriter];
        writer = nil;
        
        self.sessionManager.writeFrames=0;
        self.sessionManager.firstFrame=NO;

        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self makeWriter];
        });
        
    
}

CMTime sourceTime;

- (CMSampleBufferRef)offsetTimmingWithSampleBufferForVideo:(CMSampleBufferRef)sampleBuffer
{
    CMSampleBufferRef newSampleBuffer;
    CMSampleTimingInfo sampleTimingInfo;
    sampleTimingInfo.duration = CMTimeMake(1, 30);
    sampleTimingInfo.presentationTimeStamp = CMTimeMake(self.sessionManager.writeFrames, 30);
    sourceTime=sampleTimingInfo.presentationTimeStamp;
    sampleTimingInfo.decodeTimeStamp = kCMTimeInvalid;
    
    CMSampleBufferCreateCopyWithNewTiming(kCFAllocatorDefault,
                                          sampleBuffer,
                                          1,
                                          &sampleTimingInfo,
                                          &newSampleBuffer);
    
    
    return newSampleBuffer;
}

-(void) newAudioSample:(CMSampleBufferRef)sampleBuffer
{
    
    if( writer.status > AVAssetWriterStatusWriting )
    {
        //NSLog(@"AUDIO SAMPLE RETURN!!!!!!!!!");
        return;
    }
    
    @try {
    [audioWriterInput appendSampleBuffer:sampleBuffer];
    }
    @catch (NSException *exception) {
        NSLog(@"AUDIO SAMPLE FAIL!!!!!!!!!");
    }
    
    
}

-(void) newVideoSample:(CMSampleBufferRef)sampleBuffer
{
    if( writer.status > AVAssetWriterStatusWriting )
    {
        NSLog(@"VIDEO SAMPLE RETURN!!!!!!!!!");
        return;
    }
    
    CMTime  presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if(CMTIME_COMPARE_INLINE(presentationTimeStamp, <=, lastpresentationTimeStamp))
    {
        //NSLog(@"presentationTimeStamp is less than last frame timestamp, So rejecting frame");
        return;
    }
    lastpresentationTimeStamp = presentationTimeStamp;
    
    @try {
    [videoWriterInput appendSampleBuffer:sampleBuffer];
    }
    @catch (NSException *exception) {
        NSLog(@"VIDEO SAMPLE FAIL!!!!!!!!!");
     //NSLog(@"Gosh!!! %@", [exception callStackSymbols]);
    }
    
    
}

@end
