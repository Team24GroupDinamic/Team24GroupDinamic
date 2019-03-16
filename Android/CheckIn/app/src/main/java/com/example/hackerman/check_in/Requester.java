package com.example.hackerman.check_in;

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.os.AsyncTask;
import android.widget.ArrayAdapter;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;

class Requester {

    class RequestSurnameAndNumber extends AsyncTask<String, Void, String> {

        private Context context;
        private FragmentTransaction ftrans;

        RequestSurnameAndNumber(Context context, FragmentTransaction ftrans) {
            this.context = context;
            this.ftrans = ftrans;
        }

        @Override
        protected String doInBackground(String... strings) {

            Gson gson = new GsonBuilder().create();
            String json = gson.toJson(new JsonClasses().new SurnameNumber(strings[0], strings[1], strings[2]));
            String url = strings[3];
            StringBuilder response = new StringBuilder("no response");

            try {

                URL obj = new URL(url);
                HttpURLConnection con = (HttpURLConnection) obj.openConnection();

                con.setRequestMethod("POST");

                con.setDoOutput(true);
                DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                wr.writeBytes(json);
                wr.flush();
                wr.close();

                response = new StringBuilder();

                BufferedReader in = new BufferedReader(
                        new InputStreamReader(con.getInputStream()));
                String inputLine;

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                return response.toString();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Gson gson = new GsonBuilder().create();
            JsonClasses.Error error = gson.fromJson(s, JsonClasses.Error.class);
            if (s.equals("no response"))
                Toast.makeText(context, "Error occurred. Unknown error!", Toast.LENGTH_LONG).show();
            else if (error != null)
                Toast.makeText(context, "Error occurred. " + error.getError(), Toast.LENGTH_LONG).show();
            else if (s.isEmpty()) {
                ftrans.add(R.id.fragment_container, new SuccessfulRegistrationFragment());
                ftrans.addToBackStack(null);
                ftrans.commit();
            }
        }
    }

    class RequestGetAirlines extends AsyncTask<String, Void, ArrayAdapter<JsonClasses.Aircompany>> {

        private Spinner spinner;
        private RelativeLayout progressBar;

        private Context context;

        RequestGetAirlines(Context context, Spinner spinner, RelativeLayout progressBar) {
            this.spinner = spinner;
            this.context = context;
            this.progressBar = progressBar;
        }

        @Override
        protected ArrayAdapter<JsonClasses.Aircompany> doInBackground(String... strings) {

            Gson gson = new GsonBuilder().create();
            String url = strings[0];

            try {

                URL obj = new URL(url);
                HttpURLConnection connection = (HttpURLConnection) obj.openConnection();

                connection.setRequestMethod("GET");

                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                JsonClasses.AirCompanies airCompanies = gson.fromJson(response.toString(), JsonClasses.AirCompanies.class);

                return new AirlinesAdapter(context, new ArrayList(Arrays.asList(airCompanies.getAircompanies())), progressBar);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(ArrayAdapter<JsonClasses.Aircompany> adapter) {
            super.onPostExecute(adapter);
            if (adapter != null) {
                adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                spinner.setAdapter(adapter);
            }
        }
    }

}
