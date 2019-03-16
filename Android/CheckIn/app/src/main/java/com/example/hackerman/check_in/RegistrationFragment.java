package com.example.hackerman.check_in;

import android.animation.ValueAnimator;
import android.app.FragmentTransaction;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Rect;
import android.os.Bundle;
import android.app.Fragment;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateInterpolator;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.Toast;

import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class RegistrationFragment extends Fragment {

    private static final int ANIM_DURATION = 5000;
    private static final int ANIM_PERIOD = 500;
    private static final int MAX_ANIM_OBJS = 10;

    private static final String URL_POST_SUR_NUM = "http://185.43.5.36:8080/request/";
    private static final String URL_GET_AIR_COM = "http://185.43.5.36:8080/getcompanies/";

    private static final ImageView[] images = new ImageView[MAX_ANIM_OBJS];
    private Rect mDisplaySize = new Rect();

    private RelativeLayout mRootLayout;
    private Spinner companyList;
    private EditText reservationNumber;
    private Button registerButton;

    private MainActivity parent;

    private SQLiteDatabase db;

    private float mScale;

    public RegistrationFragment() {
    }

    public static RegistrationFragment newInstance() {
        RegistrationFragment fragment = new RegistrationFragment();
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
        parent = (MainActivity) getActivity();
        db = parent.getDb();
        mRootLayout = (RelativeLayout) inflater.inflate(R.layout.fragment_registration, container, false);
        reservationNumber = mRootLayout.findViewById(R.id.reservation_number);
        registerButton = mRootLayout.findViewById(R.id.registration);
        companyList = mRootLayout.findViewById(R.id.company_list);
        getActivity().findViewById(R.id.loadingPanel).setVisibility(View.VISIBLE);
        new Requester().new RequestGetAirlines(getActivity().getApplicationContext(), companyList,
                (RelativeLayout)getActivity().findViewById(R.id.loadingPanel)).execute(URL_GET_AIR_COM);
        registerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (reservationNumber.getText().toString().isEmpty())
                    Toast.makeText(getActivity().getApplicationContext(), R.string.enter_correct_number, Toast.LENGTH_LONG).show();
                else {
                    new DBAccesser(db).new GetSurnameStartRequest(getActivity().getApplicationContext(), getFragmentManager().beginTransaction())
                            .execute(reservationNumber.getText().toString(), ((JsonClasses.Aircompany)companyList.getSelectedItem()).getId(), URL_POST_SUR_NUM);
                }
            }
        });
        return mRootLayout;
    }

    @Override
    public void onStart() {
        super.onStart();

        Display display = getActivity().getWindowManager().getDefaultDisplay();
        display.getRectSize(mDisplaySize);

        DisplayMetrics metrics = new DisplayMetrics();
        display.getMetrics(metrics);
        mScale = metrics.density;

        LayoutInflater inflate = LayoutInflater.from(getActivity().getApplicationContext());
        for (int i = 0; i < MAX_ANIM_OBJS; i++) {
            images[i] = (ImageView) inflate.inflate(R.layout.image, null);
            images[i].setImageDrawable(getResources().getDrawable(R.mipmap.airplane));
        }

        mRootLayout.post(new Runnable() {
            @Override
            public void run() {
                new Timer().schedule(new ExeTimerTask(), 0, ANIM_PERIOD);
            }
        });
    }

    public void startAnimation(final ImageView aniView) {

        aniView.setPivotX((float) aniView.getWidth() / 2);
        aniView.setPivotY((float) aniView.getHeight() / 2);


        final ValueAnimator animator = ValueAnimator.ofFloat(0, 1);
        animator.setDuration(ANIM_DURATION);
        animator.setInterpolator(new AccelerateInterpolator());

        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {

            int coef = new Random().nextBoolean() ? 1 : -1;
            int angle = coef * (20 + (int) (Math.random() * 30));
            int movex = coef * (new Random().nextInt(mRootLayout.getWidth() / 2) + mRootLayout.getWidth() / 2);

            @Override
            public void onAnimationUpdate(ValueAnimator animation) {

                float value = (Float) (animation.getAnimatedValue());

                aniView.setRotation(angle * value);
                aniView.setTranslationX(movex * value);
                aniView.setTranslationY(-(mDisplaySize.bottom + (300 * mScale)) * value);
            }
        });

        animator.start();
    }

    private Handler mHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            if (getActivity() != null && isAdded()) {
                long num = System.currentTimeMillis() % ANIM_DURATION / ANIM_PERIOD;
                ImageView imageView = images[(int) num];
                try {
                    mRootLayout.addView(imageView);
                } catch (IllegalStateException e) {
                    e.printStackTrace();
                }
                RelativeLayout.LayoutParams animationLayout = (RelativeLayout.LayoutParams) imageView.getLayoutParams();
                animationLayout.setMargins((int) (new Random().nextFloat() * (2 * mRootLayout.getWidth() / 4) + mRootLayout.getWidth() / 4),
                        mRootLayout.getHeight() + (int) (mScale), 0, 0);
                animationLayout.width = (int) (60 * mScale);
                animationLayout.height = (int) (60 * mScale);

                startAnimation(imageView);

                return true;
            }
            return false;
        }
    });

    private class ExeTimerTask extends TimerTask {
        @Override
        public void run() {
            mHandler.sendEmptyMessage(42);
        }
    }
}
