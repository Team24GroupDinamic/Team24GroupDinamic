package com.example.hackerman.check_in;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import java.util.Objects;

public class MainActivity extends AppCompatActivity {

    private FragmentTransaction ftrans;

    private DBHelper dbhelper;
    private SQLiteDatabase db;

    public SQLiteDatabase getDb() {
        return db;
    }

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            ftrans = getFragmentManager().beginTransaction();
            switch (item.getItemId()) {
                case R.id.nav_register:
                    Fragment registrationFragment = new RegistrationFragment();
                    ftrans.replace(R.id.fragment_container, registrationFragment);
                    ftrans.commit();
                    return true;
                case R.id.nav_profile:
                    Fragment personalDataFragment = new ProfileFragment();
                    ftrans.replace(R.id.fragment_container, personalDataFragment);
                    ftrans.commit();
                    return true;
                case R.id.navigation_register_history:
                    return true;
            }
            return false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                SharedPreferences getPrefs = PreferenceManager
                        .getDefaultSharedPreferences(getBaseContext());

                boolean isFirstStart = getPrefs.getBoolean("FIRST_START", true);

                if (isFirstStart) {
                    Intent i = new Intent(MainActivity.this, CustomIntro.class);
                    startActivity(i);

                    SharedPreferences.Editor e = getPrefs.edit();
                    e.putBoolean("FIRST_START", false);
                    e.apply();
                }
            }
        });

        t.start();

        setContentView(R.layout.activity_main);

        BottomNavigationView navigation = findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
        dbhelper = new DBHelper(this);
        db = dbhelper.getWritableDatabase();
        Cursor c = db.query("personalDB", null, null, null, null, null, null);
        if (c.moveToFirst())
            navigation.setSelectedItemId(R.id.nav_register);
        else
            navigation.setSelectedItemId(R.id.nav_profile);
        c.close();
    }


    @Override
    public boolean dispatchTouchEvent(@NonNull MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            View v = getCurrentFocus();
            if (v instanceof EditText) {
                v.clearFocus();
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                Objects.requireNonNull(imm).hideSoftInputFromWindow(v.getWindowToken(), 0);

            }
        }

        return super.dispatchTouchEvent(event);
    }

}
