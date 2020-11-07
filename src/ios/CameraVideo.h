#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>

#import "VideoSessionManager.h"
#import "VideoRenderController.h"

@interface CameraVideo : CDVPlugin <TakePictureDelegate, FocusDelegate>

- (void) startCamera:(CDVInvokedUrlCommand*)command;
- (void) stopCamera:(CDVInvokedUrlCommand*)command;
- (void) showCamera:(CDVInvokedUrlCommand*)command;
- (void) hideCamera:(CDVInvokedUrlCommand*)command;
- (void) getFocusMode:(CDVInvokedUrlCommand*)command;
- (void) setFocusMode:(CDVInvokedUrlCommand*)command;
- (void) getFlashMode:(CDVInvokedUrlCommand*)command;
- (void) setFlashMode:(CDVInvokedUrlCommand*)command;
- (void) setZoom:(CDVInvokedUrlCommand*)command;
- (void) getZoom:(CDVInvokedUrlCommand*)command;
- (void) getHorizontalFOV:(CDVInvokedUrlCommand*)command;
- (void) getMaxZoom:(CDVInvokedUrlCommand*)command;
- (void) getExposureModes:(CDVInvokedUrlCommand*)command;
- (void) getExposureMode:(CDVInvokedUrlCommand*)command;
- (void) setExposureMode:(CDVInvokedUrlCommand*)command;
- (void) getExposureCompensation:(CDVInvokedUrlCommand*)command;
- (void) setExposureCompensation:(CDVInvokedUrlCommand*)command;
- (void) getExposureCompensationRange:(CDVInvokedUrlCommand*)command;
- (void) setPreviewSize: (CDVInvokedUrlCommand*)command;
- (void) switchCamera:(CDVInvokedUrlCommand*)command;
- (void) takePicture:(CDVInvokedUrlCommand*)command;
- (void) takeSnapshot:(CDVInvokedUrlCommand*)command;
- (void) setColorEffect:(CDVInvokedUrlCommand*)command;
- (void) getSupportedPictureSizes:(CDVInvokedUrlCommand*)command;
- (void) getSupportedFlashModes:(CDVInvokedUrlCommand*)command;
- (void) getSupportedFocusModes:(CDVInvokedUrlCommand*)command;
- (void) tapToFocus:(CDVInvokedUrlCommand*)command;
- (void) getSupportedWhiteBalanceModes:(CDVInvokedUrlCommand*)command;
- (void) getWhiteBalanceMode:(CDVInvokedUrlCommand*)command;
- (void) setWhiteBalanceMode:(CDVInvokedUrlCommand*)command;

- (void) invokeTakePicture:(CGFloat) width withHeight:(CGFloat) height withQuality:(CGFloat) quality;
- (void) invokeTakePicture;

- (void) invokeTapToFocus:(CGPoint) point;

//video alex
- (void) startRecord:(CDVInvokedUrlCommand*)command;
- (void) stopRecord:(CDVInvokedUrlCommand*)command;
- (void) stopRecordFinished;

@property (nonatomic) VideoSessionManager *sessionManager;
@property (nonatomic) VideoRenderController *cameraRenderController;
@property (nonatomic) NSString *onPictureTakenHandlerId;
@property (nonatomic) BOOL storeToFile;

//video alex
@property (nonatomic) NSString *onRecordStartHandlerId;
@property (nonatomic) NSString *onRecordStopHandlerId;

@end
