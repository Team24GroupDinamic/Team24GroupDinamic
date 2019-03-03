package com.example.hackerman.check_in;

import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Toast;

import com.github.paolorotolo.appintro.AppIntro2;

public class CustomIntro extends AppIntro2 {

    @Override
    public void init(Bundle savedInstanceState) {

        addSlide(SampleSlide.newInstance(R.layout.intro_1));
        //TODO добавить слайд о просмотре истории регистраций на рейс
        //addSlide(SampleSlide.newInstance(R.layout.intro_2));
        addSlide(SampleSlide.newInstance(R.layout.intro_3));

    }

    private void loadMainActivity() {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }


    @Override
    public void onNextPressed() {
    }

    @Override
    public void onDonePressed() {
        EditText editText = findViewById(R.id.intro_3_et);
        String surname;
        if ((surname = editText.getText().toString()).isEmpty())
            Toast.makeText(this, getResources().getString(R.string.enter_correct_curname), Toast.LENGTH_LONG).show();
        else {
            DBHelper dbhelper = new DBHelper(this);
            SQLiteDatabase db = dbhelper.getWritableDatabase();
            new DBAccesser(db).new SurnamePutInDB().execute(surname);
            finish();
            loadMainActivity();
        }
    }

    @Override
    public void onSlideChanged() {
    }

}
