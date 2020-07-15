import 'package:flutter/material.dart'; import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class LoadingDelegate {
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor);

  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor);
}

class DefaultLoadingDelegate extends LoadingDelegate {
  @override
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(themeColor),
          strokeWidth: 1,
        ),
      ),
    );
  }

  @override
  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(themeColor),
          strokeWidth: 1,
        ),
      ),
    );
  }
}
