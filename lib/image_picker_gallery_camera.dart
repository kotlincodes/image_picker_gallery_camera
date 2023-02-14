library image_picker_gallery_camera;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerGC {
  static Future pickImage({
    Icon? closeIcon,
    double? maxWidth,
    Icon? cameraIcon,
    int? galleryImageQuality,
    int? cameraImageQuality,
    double? maxHeight,
    Icon? galleryIcon,
    Widget? cameraText,
    Widget? galleryText,
    bool enableCloseButton = false,
    required ImgSource source,
    required BuildContext context,
    bool barrierDismissible = false,
  }) async {
    assert(galleryImageQuality == null ||
        (galleryImageQuality >= 0 && galleryImageQuality <= 100));

    if (maxWidth != null && maxWidth < 0) {
      throw ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }

    switch (source) {
      case ImgSource.Camera:
        return await ImagePicker().pickImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          source: ImageSource.camera,
        );
      case ImgSource.Gallery:
        return await ImagePicker().pickImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          source: ImageSource.gallery,
        );
      case ImgSource.Both:
        return await showDialog<void>(
          context: context,
          barrierDismissible: barrierDismissible, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (enableCloseButton)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: closeIcon ??
                            Icon(
                              Icons.close,
                              size: 14,
                            ),
                      ),
                    ),
                  InkWell(
                    onTap: () async {
                      XFile? image = await ImagePicker().pickImage(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        source: ImageSource.gallery,
                        imageQuality: galleryImageQuality,
                      );
                      Navigator.pop(context, image);
                    },
                    child: Container(
                      child: ListTile(
                        title: galleryText ?? Text("Gallery"),
                        leading: galleryIcon ??
                            Icon(
                              Icons.image,
                              color: Colors.deepPurple,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 1,
                    color: Colors.black12,
                  ),
                  InkWell(
                    onTap: () async {
                      XFile? image = await ImagePicker().pickImage(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        source: ImageSource.camera,
                        imageQuality: cameraImageQuality,
                      );
                      Navigator.pop(context, image);
                    },
                    child: Container(
                      child: ListTile(
                        title: cameraText ?? Text("Camera"),
                        leading: cameraIcon ??
                            Icon(
                              Icons.camera,
                              color: Colors.deepPurple,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }
}

enum ImgSource { Camera, Gallery, Both }
