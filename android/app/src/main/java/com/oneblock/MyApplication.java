package com.oneblock;
import android.Manifest;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Criteria;
import android.location.LocationManager;

import android.media.Ringtone;
import android.net.Uri;
import android.os.Build;
import android.preference.PreferenceManager;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentManager;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
// import io.flutter.plugins.androidalarmmanager.AlarmService;
// import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;

/**
 * Created by John Ebere on 6/6/2018.
 */
public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
    }

}