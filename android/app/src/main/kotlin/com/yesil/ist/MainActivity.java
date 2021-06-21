package com.yesil.ist;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.google.android.gms.actions.NoteIntents;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private String sharedText;
    private static final String CHANNEL = "app.channel.shared.data";

    public void createNote(String subject, String text) {
        Intent intent = new Intent(NoteIntents.ACTION_CREATE_NOTE)
                .putExtra(NoteIntents.EXTRA_NAME, subject)
                .putExtra(NoteIntents.EXTRA_TEXT, text);
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
            sharedText=text;
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();
        if (NoteIntents.ACTION_CREATE_NOTE.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                handleSendText(intent); // Handle text being sent
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.contentEquals("getSharedText")) {
                                result.success(sharedText);
                                sharedText = null;
                            }
                        }
                );
    }

    void handleSendText(Intent intent) {
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    }
}