#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

#import "VideoSessionManager.h"

@protocol TakePictureDelegate
- (void) invokeTakePicture;
- (void) invokeTakePictureOnFocus;
//video alex
- (void) stopRecordFinished;
@end;

@protocol FocusDelegate
- (void) invokeTapToFocus:(CGPoint)point;
@end;

@interface VideoRenderController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, OnFocusDelegate> {
  GLuint _renderBuffer;
  CVOpenGLESTextureCacheRef _videoTextureCache;
  CVOpenGLESTextureRef _lumaTexture;
}

//video alex
- (void) makeWriter;
- (void) stopWriter;
- (void) startWriter;
- (void) clearWriter;
- (void) resetWriter;
- (void) resetWriter2;
- (void) newAudioSample:(CMSampleBufferRef)sampleBuffer;
- (void) newVideoSample:(CMSampleBufferRef)sampleBuffer;
- (CMSampleBufferRef)offsetTimmingWithSampleBufferForVideo:(CMSampleBufferRef)sampleBuffer;

@property (nonatomic) VideoSessionManager *sessionManager;
@property (nonatomic) CIContext *ciContext;
@property (nonatomic) CIImage *latestFrame;
@property (nonatomic) EAGLContext *context;
@property (nonatomic) NSLock *renderLock;
@property BOOL dragEnabled;
@property BOOL tapToTakePicture;
@property BOOL tapToFocus;
@property (nonatomic, assign) id delegate;

@end
