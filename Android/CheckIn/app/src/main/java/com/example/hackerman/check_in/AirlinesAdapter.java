package com.example.hackerman.check_in;

import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;

class AirlinesAdapter extends ArrayAdapter<JsonClasses.Aircompany> {

    private RelativeLayout progressBar;

    AirlinesAdapter(Context context, ArrayList<JsonClasses.Aircompany> countryList, RelativeLayout progressBar) {
        super(context, 0, countryList);
        this.progressBar = progressBar;
    }

    @NonNull
    @Override
    public View getView(int position, View convertView, @NonNull ViewGroup parent) {
        return initView(position, convertView, parent);
    }

    @Override
    public View getDropDownView(int position, View convertView, @NonNull ViewGroup parent) {
        return initView(position, convertView, parent);
    }

    private View initView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(
                    R.layout.spinner_item, parent, false
            );
        }

        ImageView logo = convertView.findViewById(R.id.airline_icon);
        TextView airlineName = convertView.findViewById(R.id.airline_name);

        JsonClasses.Aircompany currentItem = getItem(position);

        if (currentItem != null) {
            new LoadBitmap(logo, progressBar).execute(currentItem.getLogoURL(), currentItem.getName());

            airlineName.setText(currentItem.getName());
        }

        return convertView;
    }

    class LoadBitmap extends AsyncTask<String, Void, Bitmap> {

        private ImageView imageView;
        private RelativeLayout progressBar;

        LoadBitmap(ImageView imageView, RelativeLayout progressBar) {
            this.imageView = imageView;
            this.progressBar = progressBar;
        }

        @Override
        protected Bitmap doInBackground(String... strings) {
            try {
                ContextWrapper cw = new ContextWrapper(getContext());
                File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);
                File f = new File(directory, strings[1] + ".png");
                return BitmapFactory.decodeStream(new FileInputStream(f));
            } catch (FileNotFoundException e) {
                try {

                    URL newurl = new URL(strings[0]);
                    Bitmap mIcon_val = BitmapFactory.decodeStream(newurl.openConnection().getInputStream());
                    ContextWrapper cw = new ContextWrapper(getContext());
                    File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);

                    File mypath = new File(directory, strings[1] + ".png");

                    try (FileOutputStream fos = new FileOutputStream(mypath)) {
                        mIcon_val.compress(Bitmap.CompressFormat.PNG, 100, fos);
                    } catch (Exception e1) {
                        e.printStackTrace();
                    }
                    return mIcon_val;
                } catch (IOException e1) {
                    e.printStackTrace();
                }

            }
            return null;
        }

        @Override
        protected void onPostExecute(Bitmap bitmap) {
            super.onPostExecute(bitmap);
            if (bitmap != null) {
                imageView.setImageBitmap(bitmap);
                if (progressBar != null)
                    progressBar.setVisibility(View.GONE);
            }
        }
    }
}
