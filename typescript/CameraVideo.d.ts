declare module 'cordova-plugin-camera-video' {
  type CameraVideoErrorHandler = (err: any) => any;
  type CameraVideoSuccessHandler = (data: any) => any;

  type CameraVideoCameraDirection = 'back'|'front';
  type CameraVideoColorEffect = 'aqua'|'blackboard'|'mono'|'negative'|'none'|'posterize'|'sepia'|'solarize'|'whiteboard';
  type CameraVideoExposureMode = 'lock'|'auto'|'continuous'|'custom';
  type CameraVideoFlashMode = 'off'|'on'|'auto'|'red-eye'|'torch';
  type CameraVideoFocusMode = 'fixed'|'auto'|'continuous'|'continuous-picture'|'continuous-video'|'edof'|'infinity'|'macro';
  type CameraVideoWhiteBalanceMode = 'lock'|'auto'|'continuous'|'incandescent'|'cloudy-daylight'|'daylight'|'fluorescent'|'shade'|'twilight'|'warm-fluorescent';

  interface CameraVideoStartCameraOptions {
    alpha?: number;
    camera?: CameraVideoCameraDirection|string;
    height?: number;
    previewDrag?: boolean;
    tapFocus?: boolean;
    tapPhoto?: boolean;
    toBack?: boolean;
    width?: number;
    x?: number;
    y?: number;
    disableExifHeaderStripping?: boolean;
    storeToFile?: boolean;
  }

  interface CameraVideoTakePictureOptions {
    height?: number;
    quality?: number;
    width?: number;
  }

  interface CameraVideoTakeSnapshotOptions {
    quality?: number;
  }

  interface CameraVideoPreviewSizeDimension {
    height?: number;
    width?: number;
  }

  interface CameraVideo {
    startCamera(options?: CameraVideoStartCameraOptions, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    stopCamera(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    switchCamera(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    hide(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    show(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    takePicture(options?: CameraVideoTakePictureOptions|CameraVideoSuccessHandler, onSuccess?: CameraVideoSuccessHandler|CameraVideoErrorHandler, onError?: CameraVideoErrorHandler): void;
    takeSnapshot(options?: CameraVideoTakeSnapshotOptions|CameraVideoSuccessHandler, onSuccess?: CameraVideoSuccessHandler|CameraVideoErrorHandler, onError?: CameraVideoErrorHandler): void;
    setColorEffect(effect: CameraVideoColorEffect|string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setZoom(zoom?: number, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    startRecordVideo(options?:any|CameraVideoSuccessHandler, onSuccess?:CameraVideoSuccessHandler|CameraVideoErrorHandler, onError?:CameraVideoErrorHandler):void;
    stopRecordVideo(CameraVideoSuccessHandler, onSuccess?:CameraVideoSuccessHandler|CameraVideoErrorHandler, onError?:CameraVideoErrorHandler):void;
    getMaxZoom(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedFocusMode(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getZoom(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getHorizontalFOV(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setPreviewSize(dimensions?: CameraVideoPreviewSizeDimension|string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedPictureSizes(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedFlashModes(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedColorEffects(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setFlashMode(flashMode: CameraVideoFlashMode|string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedFocusModes(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getFocusMode(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setFocusMode(focusMode?: CameraVideoFocusMode|string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    tapToFocus(xPoint?: number, yPoint?: number, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getExposureModes(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getExposureMode(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setExposureMode(exposureMode?: CameraVideoExposureMode, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getExposureCompensation(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setExposureCompensation(exposureCompensation?: number, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getExposureCompensationRange(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedWhiteBalanceModes(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getSupportedWhiteBalanceMode(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    setWhiteBalanceMode(whiteBalanceMode?: CameraVideoWhiteBalanceMode|string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    onBackButton(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getBlob(path: string, onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
    getCameraCharacteristics(onSuccess?: CameraVideoSuccessHandler, onError?: CameraVideoErrorHandler): void;
  }
}
