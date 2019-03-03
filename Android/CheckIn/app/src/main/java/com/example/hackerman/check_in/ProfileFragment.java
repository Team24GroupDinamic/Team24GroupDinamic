package com.example.hackerman.check_in;

import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.Toast;

public class ProfileFragment extends Fragment {

    private SQLiteDatabase db;

    private MainActivity parent;

    private ImageButton edit;
    private EditText etSurname;
    private Button submit;


    public ProfileFragment() {
    }

    public static ProfileFragment newInstance() {
        ProfileFragment fragment = new ProfileFragment();
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
        View view = inflater.inflate(R.layout.fragment_profile, container, false);
        parent = (MainActivity) getActivity();
        db = parent.getDb();
        edit = view.findViewById(R.id.edit_data_button);
        etSurname = view.findViewById(R.id.et_surname);
        getActivity().findViewById(R.id.loadingPanel).setVisibility(View.VISIBLE);

        new DBAccesser(db).new SurnameGetAndSetET(etSurname, getResources().getString(R.string.enter_surname),
                (RelativeLayout) getActivity().findViewById(R.id.loadingPanel)).execute();
        submit = view.findViewById(R.id.submit);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (view.getId()) {
                    case R.id.edit_data_button:
                        etSurname.setEnabled(true);
                        break;
                    case R.id.submit:
                        if (etSurname.getText().toString().isEmpty())
                            Toast.makeText(getActivity().getApplicationContext(), R.string.enter_correct_curname, Toast.LENGTH_LONG).show();
                        else {
                            new DBAccesser(db).new SurnameDBClear().execute();
                            new DBAccesser(db).new SurnamePutInDB().execute(etSurname.getText().toString());
                            etSurname.setEnabled(false);
                        }
                        break;
                    default:
                        break;
                }
            }
        };
        edit.setOnClickListener(onClickListener);
        submit.setOnClickListener(onClickListener);
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
    }


    @Override
    public void onDetach() {
        super.onDetach();
    }
}
