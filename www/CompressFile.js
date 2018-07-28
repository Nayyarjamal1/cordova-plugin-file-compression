var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'CompressFile', 'coolMethod', [arg0]);
};

exports.compressImage = function (filePath, folderPath, compressionSize, success, error) {
    exec(success, error, 'CompressFile', 'compressImage', [filePath, folderPath, compressionSize]);
};
