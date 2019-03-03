package com.example.hackerman.check_in;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;

class DBAccesser {

    private SQLiteDatabase db;


    DBAccesser(SQLiteDatabase db) {
        this.db = db;
    }


    public class SurnameGetAndSetET extends AsyncTask<Void, Void, String> {
        private EditText et;
        private RelativeLayout progressBar;

        private String emptyDBCase;


        SurnameGetAndSetET(EditText et, String s, RelativeLayout progressBar) {
            this.et = et;
            emptyDBCase = s;
            this.progressBar = progressBar;
            progressBar.setVisibility(View.VISIBLE);
        }

        @Override
        protected String doInBackground(Void... voids) {
            Cursor c = db.query("personalDB", null, null, null, null, null, null);
            if (c.moveToFirst()) {
                String s = c.getString(c.getColumnIndex("surname"));
                c.close();
                return s;
            }
            return null;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            if (s != null) {
                et.setText(s);
                et.setEnabled(false);
                progressBar.setVisibility(View.GONE);
            } else {
                et.setHint(emptyDBCase);
                et.setEnabled(true);
                progressBar.setVisibility(View.GONE);
            }
        }
    }

    public class SurnamePutInDB extends AsyncTask<String, Void, Long> {

        @Override
        protected Long doInBackground(String... strings) {
            ContentValues cv = new ContentValues();
            cv.put("surname", strings[0]);
            return db.insert("personalDB", null, cv);
        }
    }

    public class SurnameDBClear extends AsyncTask<Void, Void, Integer> {

        @Override
        protected Integer doInBackground(Void... voids) {
            return db.delete("personalDB", null, null);
        }
    }

    public class GetSurnameStartRequest extends AsyncTask<String, Void, String[]> {

        Context context;

        GetSurnameStartRequest(Context context) {
            this.context = context;
        }

        @Override
        protected String[] doInBackground(String... strings) {
            String[] params = new String[4];
            Cursor c = db.query("personalDB", null, null, null, null, null, null);
            System.arraycopy(strings, 0, params, 1, 3);
            if (c.moveToFirst())
                params[0] = c.getString(c.getColumnIndex("surname"));
            c.close();
            return params;
        }

        @Override
        protected void onPostExecute(String[] s) {
            super.onPostExecute(s);
            new Requester().new RequestSurnameAndNumber(context).execute(s);
        }
    }
}
