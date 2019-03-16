package com.example.hackerman.check_in;

import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class SuccessfulRegistrationFragment extends Fragment {

    public SuccessfulRegistrationFragment() {
    }

    public static SuccessfulRegistrationFragment newInstance(String param1, String param2) {
        SuccessfulRegistrationFragment fragment = new SuccessfulRegistrationFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_successfull_registration, container, false);
    }


    @Override
    public void onDetach() {
        super.onDetach();
    }


}
