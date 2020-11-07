var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

var PLUGIN_NAME = "CameraVideo";

var CameraVideo = function() {};

function isFunction(obj) {
  return !!(obj && obj.constructor && obj.call && obj.apply);
};

CameraVideo.startCamera = function(options, onSuccess, onError) {
  if (!options) {
    options = {};
  } else if (isFunction(options)) {
    onSuccess = options;
    options = {};
  }

  options.x = options.x || 0;
  options.y = options.y || 0;

  options.width = options.width || window.screen.width;
  options.height = options.height || window.screen.height;

  options.camera = options.camera || CameraVideo.CAMERA_DIRECTION.FRONT;

  if (typeof(options.tapPhoto) === 'undefined') {
    options.tapPhoto = true;
  }

  if (typeof (options.tapFocus) == 'undefined') {
    options.tapFocus = false;
  }

  options.previewDrag = options.previewDrag || false;

  options.toBack = options.toBack || false;

  if (typeof(options.alpha) === 'undefined') {
    options.alpha = 1;
  }

  options.disableExifHeaderStripping = options.disableExifHeaderStripping || false;

  options.storeToFile = options.storeToFile || false;

  exec(onSuccess, onError, PLUGIN_NAME, "startCamera", [
    options.x, 
    options.y, 
    options.width, 
    options.height, 
    options.camera, 
    options.tapPhoto, 
    options.previewDrag, 
    options.toBack, 
    options.alpha, 
    options.tapFocus, 
    options.disableExifHeaderStripping, 
    options.storeToFile
  ]);
};

CameraVideo.stopCamera = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "stopCamera", []);
};

CameraVideo.switchCamera = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "switchCamera", []);
};

CameraVideo.hide = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "hideCamera", []);
};

CameraVideo.show = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "showCamera", []);
};

CameraVideo.takeSnapshot = function(opts, onSuccess, onError) {
  if (!opts) {
    opts = {};
  } else if (isFunction(opts)) {
    onSuccess = opts;
    opts = {};
  }

  if (!isFunction(onSuccess)) {
    return false;
  }

  if (!opts.quality || opts.quality > 100 || opts.quality < 0) {
    opts.quality = 85;
  }

  exec(onSuccess, onError, PLUGIN_NAME, "takeSnapshot", [opts.quality]);
};

CameraVideo.takePicture = function(opts, onSuccess, onError) {
  if (!opts) {
    opts = {};
  } else if (isFunction(opts)) {
    onSuccess = opts;
    opts = {};
  }

  if (!isFunction(onSuccess)) {
    return false;
  }

  opts.width = opts.width || 0;
  opts.height = opts.height || 0;

  if (!opts.quality || opts.quality > 100 || opts.quality < 0) {
    opts.quality = 85;
  }

  exec(onSuccess, onError, PLUGIN_NAME, "takePicture", [opts.width, opts.height, opts.quality]);
};

CameraVideo.setColorEffect = function(effect, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setColorEffect", [effect]);
};

CameraVideo.setZoom = function(zoom, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setZoom", [zoom]);
};

CameraVideo.getMaxZoom = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getMaxZoom", []);
};

CameraVideo.getZoom = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getZoom", []);
};

CameraVideo.getHorizontalFOV = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getHorizontalFOV", []);
};

CameraVideo.setPreviewSize = function(dimensions, onSuccess, onError) {
  dimensions = dimensions || {};
  dimensions.width = dimensions.width || window.screen.width;
  dimensions.height = dimensions.height || window.screen.height;

  exec(onSuccess, onError, PLUGIN_NAME, "setPreviewSize", [dimensions.width, dimensions.height]);
};

CameraVideo.getSupportedPictureSizes = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getSupportedPictureSizes", []);
};

CameraVideo.getSupportedFlashModes = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getSupportedFlashModes", []);
};

CameraVideo.getSupportedColorEffects = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getSupportedColorEffects", []);
};

CameraVideo.setFlashMode = function(flashMode, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setFlashMode", [flashMode]);
};

CameraVideo.getFlashMode = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getFlashMode", []);
};

CameraVideo.getSupportedFocusModes = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getSupportedFocusModes", []);
};

CameraVideo.getFocusMode = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getFocusMode", []);
};

CameraVideo.setFocusMode = function(focusMode, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setFocusMode", [focusMode]);
};

CameraVideo.tapToFocus = function(xPoint, yPoint, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "tapToFocus", [xPoint, yPoint]);
};

CameraVideo.getExposureModes = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getExposureModes", []);
};

CameraVideo.getExposureMode = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getExposureMode", []);
};

CameraVideo.setExposureMode = function(exposureMode, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setExposureMode", [exposureMode]);
};

CameraVideo.getExposureCompensation = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getExposureCompensation", []);
};

CameraVideo.setExposureCompensation = function(exposureCompensation, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setExposureCompensation", [exposureCompensation]);
};

CameraVideo.getExposureCompensationRange = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getExposureCompensationRange", []);
};

CameraVideo.getSupportedWhiteBalanceModes = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getSupportedWhiteBalanceModes", []);
};

CameraVideo.getWhiteBalanceMode = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getWhiteBalanceMode", []);
};

CameraVideo.setWhiteBalanceMode = function(whiteBalanceMode, onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "setWhiteBalanceMode", [whiteBalanceMode]);
};

CameraVideo.getCameraCharacteristics = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "getCameraCharacteristics", []);
};

CameraVideo.onBackButton = function(onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "onBackButton");
};

CameraVideo.getBlob = function (url, onSuccess, onError) {
  var xhr = new XMLHttpRequest
  xhr.onload = function() {
    if (xhr.status != 0 && (xhr.status < 200 || xhr.status >= 300)) {
      if (isFunction(onError)) {
        onError('Local request failed');
      }
      return;
    }
    var blob = new Blob([xhr.response], {type: "image/jpeg"});
    if (isFunction(onSuccess)) {
      onSuccess(blob);
    }
  };
  xhr.onerror = function() {
    if (isFunction(onError)) {
      onError('Local request failed');
    }
  };
  xhr.open('GET', url);
  xhr.responseType = 'arraybuffer';
  xhr.send(null);
};

CameraVideo.startRecordVideo = function (opts, onSuccess, onError) {
  if (!opts) {
    opts = {};
  } else if (isFunction(opts)) {
    onSuccess = opts;
    opts = {};
  }

  if (!isFunction(onSuccess)) {
    return false;
  }

  opts.width = opts.width || 0;
  opts.height = opts.height || 0;

  if (!opts.quality || opts.quality > 100 || opts.quality < 0) {
    opts.quality = 85;
  }

  exec(onSuccess, onError, PLUGIN_NAME, "startRecordVideo", [opts.cameraDirection, opts.width, opts.height, opts.quality, opts.withFlash]);
};

CameraVideo.stopRecordVideo = function (onSuccess, onError) {
  exec(onSuccess, onError, PLUGIN_NAME, "stopRecordVideo");
};

CameraVideo.FOCUS_MODE = {
  FIXED: 'fixed',
  AUTO: 'auto',
  CONTINUOUS: 'continuous', // IOS Only
  CONTINUOUS_PICTURE: 'continuous-picture', // Android Only
  CONTINUOUS_VIDEO: 'continuous-video', // Android Only
  EDOF: 'edof', // Android Only
  INFINITY: 'infinity', // Android Only
  MACRO: 'macro' // Android Only
};

CameraVideo.EXPOSURE_MODE = {
  LOCK: 'lock',
  AUTO: 'auto', // IOS Only
  CONTINUOUS: 'continuous', // IOS Only
  CUSTOM: 'custom' // IOS Only
};

CameraVideo.WHITE_BALANCE_MODE = {
  LOCK: 'lock',
  AUTO: 'auto',
  CONTINUOUS: 'continuous',
  INCANDESCENT: 'incandescent',
  CLOUDY_DAYLIGHT: 'cloudy-daylight',
  DAYLIGHT: 'daylight',
  FLUORESCENT: 'fluorescent',
  SHADE: 'shade',
  TWILIGHT: 'twilight',
  WARM_FLUORESCENT: 'warm-fluorescent'
};

CameraVideo.FLASH_MODE = {
  OFF: 'off',
  ON: 'on',
  AUTO: 'auto',
  RED_EYE: 'red-eye', // Android Only
  TORCH: 'torch'
};

CameraVideo.COLOR_EFFECT = {
  AQUA: 'aqua', // Android Only
  BLACKBOARD: 'blackboard', // Android Only
  MONO: 'mono',
  NEGATIVE: 'negative',
  NONE: 'none',
  POSTERIZE: 'posterize',
  SEPIA: 'sepia',
  SOLARIZE: 'solarize', // Android Only
  WHITEBOARD: 'whiteboard' // Android Only
};

CameraVideo.CAMERA_DIRECTION = {
  BACK: 'back',
  FRONT: 'front'
};

//video alex
CameraVideo.startRecord = function(opts, onSuccess, onError) {
    if (!opts) {
        opts = {};
    } else if (isFunction(opts)) {
        onSuccess = opts;
        opts = {};
    }

    if (!isFunction(onSuccess)) {
        return false;
    }

    opts.width = opts.width || 0;
    opts.height = opts.height || 0;

    if (!opts.quality || opts.quality > 100 || opts.quality < 0) {
        opts.quality = 85;
    }

    exec(onSuccess, onError, PLUGIN_NAME, "startRecord", [opts.width, opts.height, opts.quality]);
};

CameraVideo.stopRecord = function(onSuccess, onError) {
    
    if (!isFunction(onSuccess)) {
        return false;
    }

    exec(onSuccess, onError, PLUGIN_NAME, "stopRecord");
};

CameraVideo.requestPermissions = function(onSuccess, onError) {
    
    if (!isFunction(onSuccess)) {
        return false;
    }

    exec(onSuccess, onError, PLUGIN_NAME, "requestPermissions");
};

CameraVideo.refreshPreview = function() {

    exec(function(){}, function(){}, PLUGIN_NAME, "refreshPreview");
};

module.exports = CameraVideo;
