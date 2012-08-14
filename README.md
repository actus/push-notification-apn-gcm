#node_n_push

This is a server which is based on Node.js for using Google Cloud Messaging service& Apple Push Notification service concurrently.<br />
It requires [node-apn](https://github.com/argon/node-apn)
and [node-gcm](https://github.com/ToothlessGear/node-gcm) module.


## Installation

    $ mkdir node_n_push
	$ cd node_n_push 
	$ git clone https://github.com/actus/node_n_push.git
	$ cd push_node
	$ npm install apn
	$ npm install node-gcm


## Usage
 
Load pushServer in the module and set GCM & APN options.

	var pushServer = require('pushServer');

###GCM Setting:
Set options for GCM notification.

	var gcmOptions = 
	{
		apiKey : "YOUR API-KEY",							/* Key for server apps */
		messageFile : path.join(process.cwd(), "message")	/* message file path */
	}

apiKey : API key in Key for server apps in [Google Apis Console](https://code.google.com/apis/console/) - API Access.

	$vi message

{"messageKey":"messageFrom", "messageValue":"Caroline"}

Which is saved as Json type.   <br />
You can check 'messageFrom = Caroline' after getting intent from android client. <br />
Change "Caroline" for your message and "messageFrom" for your key.

	pushServer.setGCMOptions(gcmOptions);

Put the set gcmOptions into pushServer.setGCMOptions parameter.

###APN Setting:

Refer to [node-apn](https://github.com/argon/node-apn) for detailed explanation.

####Connecting

	var apnOptions = {
		cert: mCert,                      /* Certificate file path */
		certData: null,                   /* String or Buffer containing certificate data, if supplied uses this instead of cert file path */
    	key:  mKey,                       /* Key file path */
    	keyData: null,                    /* String or Buffer containing key data, as certData */
    	passphrase: null,                 /* A passphrase for the Key file */
    	ca: null,                          /* String or Buffer of CA data to use for the TLS connection */
    	gateway: 'gateway.sandbox.push.apple.com', /* gateway address */
    	port: 2195,                       /* gateway port */
    	enhanced: true,                   /* enable enhanced format */
    	errorCallback: undefined,         /* Callback when error occurs function(err,notification) */
    	cacheLength: 100                  /* Number of notifications to cache for error purposes */
	};

Put '.pem' file path in cert & key.
And set your message.

	var noteOptions = {
		expiry : Math.floor(Date.now() / 1000) + 3600, // Expires 1 hour from now.
		badge : 1,
		sound : "ping.aiff",
		alert : "You have a new message",
		payload : {},
		device : undefined
	}

You were set message for GCM, the message for iOS is delivered in the same way of GCM.
So you don't need to set payload.
device is undefinded because send notificaton to all of your ios devices.

####Feedback

[Read this](https://groups.google.com/forum/?fromgroups#!topic/easyapns/GbLVI-_RwrM) and set iOS device.

	var feedbackOptions = {
	    cert: mCert,                   		/* Certificate file */
	    certData: null,                     /* Certificate file contents (String|Buffer) */
	    key:  mKey,                   		/* Key file */
	    keyData: null,                      /* Key file contents (String|Buffer) */
	    passphrase: null,                   /* A passphrase for the Key file */
	    ca: null,                           /* Certificate authority data to pass to the TLS connection */
	    address: 'feedback.sandbox.push.apple.com', /* feedback address */
	    port: 2196,                         /* feedback port */
	    feedback: false,                    /* enable feedback service, set to callback */
	    interval: 3600                      /* interval in seconds to connect to feedback service */
	};

Set '.pem' file path on cert & key. and configure your message. <br />


	pushServer.setAPNS(apnOptions, noteOptions, feedbackOptions);

If you don't use feedback, put null into feedackOptions.


	pushServer.listen(pushServerPort, pushServerIP);

Set your serverPort and serverIp.

###GCM Client Setting

	CommonUtilities.java
	    static final String SERVER_URL = "YOUR_SERVER_IP:YOUR_SERVER_PORT";
	    static final String SENDER_ID = "YOUR_PROJECT_ID";

Set your serverPort and serverIp. And set your project_id in [Google Apis Console](https://code.google.com/apis/console/).

###APN Client Setting

	AppDelegate.m 
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 

	[self.viewController requestUrl:@"YOUR_SERVER_IP:YOUR_SERVER_PORT/register"];

Set your serverPort and serverIp.

If you have the registered devices on server, you will send notification in all your registered android and ios device through "YOUR_SERVER_IP:YOUR_SERVER_PORT/sendAll".


Easy way to test, open example.js file and set your ServerPort, mCert, mKey and apiKey in gcmOption.
	
	$ node example.js 
	
Then run example.js.


##License

The MIT License

Copyright (c) 2012 Actus (yezune@actus.kr)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


GCMClient is licensed under the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0)