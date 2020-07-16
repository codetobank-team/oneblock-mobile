// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.oneblock;

import com.crazecoder.openfile.OpenFilePlugin;
// import com.jeffg.emoji_picker.EmojiPickerPlugin;
// import com.mr.flutter.plugin.filepicker.FilePickerPlugin;


//import net.touchcapture.qr.flutterqr.FlutterQrPlugin;

//import net.touchcapture.qr.flutterqr.FlutterQrPlugin;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
// import io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import io.flutter.plugins.localauth.LocalAuthPlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
//import io.flutter.url_launcher_web.UrlLauncherWebPlugin;
import vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin;

public class MainActivity extends FlutterFragmentActivity {
  // TODO(bparrishMines): Remove this once v2 of GeneratedPluginRegistrant rolls to stable. https://github.com/flutter/flutter/issues/42694
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new LocalAuthPlugin());
    flutterEngine.getPlugins().add(new SharedPreferencesPlugin());
    // flutterEngine.getPlugins().add(new EmojiPickerPlugin());
    // flutterEngine.getPlugins().add(new FirebaseAnalyticsPlugin());
    flutterEngine.getPlugins().add(new ConnectivityPlugin());
    flutterEngine.getPlugins().add(new PathProviderPlugin());
    flutterEngine.getPlugins().add(new OpenFilePlugin());
    flutterEngine.getPlugins().add(new PathProviderPlugin());
    flutterEngine.getPlugins().add(new OpenFilePlugin());
    // flutterEngine.getPlugins().add(new FilePickerPlugin());
    flutterEngine.getPlugins().add(new ImagePickerPlugin());
    flutterEngine.getPlugins().add(new ImageCropperPlugin());
    flutterEngine.getPlugins().add(new UrlLauncherPlugin());
    flutterEngine.getPlugins().add(new SharePlugin());
//    flutterEngine.getPlugins().add(new FlutterQrPlugin());
//    flutterEngine.getPlugins().add(new UrlLauncherWebPlugin());
    flutterEngine.getPlugins().add(new PackageInfoPlugin());

  }
}
