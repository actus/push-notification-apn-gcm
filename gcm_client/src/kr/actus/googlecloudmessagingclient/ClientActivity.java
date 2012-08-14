package kr.actus.googlecloudmessagingclient;

import static kr.actus.googlecloudmessagingclient.CommonUtilities.DISPLAY_MESSAGE_ACTION;
import static kr.actus.googlecloudmessagingclient.CommonUtilities.EXTRA_MESSAGE;
import static kr.actus.googlecloudmessagingclient.CommonUtilities.SENDER_ID;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.google.android.gcm.GCMRegistrar;

public class ClientActivity extends Activity {

	private final String TAG = this.getClass().getName();
	private TextView stateDisplay;
	private AsyncTask<Void, Void, Void> mRegisterTask;
	private Context context = this;
	
    private final BroadcastReceiver mHandleMessageReceiver =
            new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String newMessage = intent.getExtras().getString(EXTRA_MESSAGE);
            stateDisplay.append(newMessage + "\n");
        }
    };
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
                                
        setContentView(R.layout.activity_client);
        GCMRegistrar.checkDevice(this);
        GCMRegistrar.checkManifest(this);
        stateDisplay = (TextView) findViewById(R.id.mDisplay);
        registerReceiver(mHandleMessageReceiver, new IntentFilter(DISPLAY_MESSAGE_ACTION));
       
        final String regId = GCMRegistrar.getRegistrationId(this);
        if (regId.equals("")) 
        {
          GCMRegistrar.register(this, SENDER_ID);
          Log.w(TAG, "REGISTER!!");
        } 
        else 
        {
        	if(GCMRegistrar.isRegisteredOnServer(this))
        	{
                stateDisplay.append(getString(R.string.already_registered) + "\n");
        	}
        	else
        	{
        		final Context context = this;
                mRegisterTask = new AsyncTask<Void, Void, Void>() {

                    @Override
                    protected Void doInBackground(Void... params) {
                        boolean registered =
                                ServerUtilities.register(context, regId);
                        // At this point all attempts to register with the app
                        // server failed, so we need to unregister the device
                        // from GCM - the app will try to register again when
                        // it is restarted. Note that GCM will send an
                        // unregistered callback upon completion, but
                        // GCMIntentService.onUnregistered() will ignore it.
                        if (!registered) {
                            GCMRegistrar.unregister(context);
                        }
                        return null;
                    }

                    @Override
                    protected void onPostExecute(Void result) {
                        mRegisterTask = null;
                    }

                };
                mRegisterTask.execute(null, null, null);
        	}
        	
          Log.w(TAG, "Already registered");
          Log.w(TAG, "GET ID: "+GCMRegistrar.getRegistrationId(this).toString());
        }
        
        findViewById(R.id.unregester).setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				boolean registered = GCMRegistrar.isRegistered(context);
				if(registered)
				{
					GCMRegistrar.unregister(context);
				}
			}
		});
        
        
    }
    

//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        MenuInflater inflater = getMenuInflater();
//        inflater.inflate(R.menu.options_menu, menu);
//        return true;
//    }
    
    @Override
    protected void onDestroy() 
    {
        if (mRegisterTask != null) 
        {
            mRegisterTask.cancel(true);
        }
        unregisterReceiver(mHandleMessageReceiver);
        GCMRegistrar.onDestroy(this);
        super.onDestroy();
    }
}
