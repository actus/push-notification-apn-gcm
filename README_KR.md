#node_n_push

Google Cloud Messaging service와 Apple Push Notification service를 동시에 가능하도록 한 Node.js로 만들어진 서버입니다. <br />
[node-apn](https://github.com/argon/node-apn)과 
[node-gcm](https://github.com/ToothlessGear/node-gcm)을 사용했습니다.


## Installation

    $ mkdir node_n_push
  $ cd node_n_push 
  $ git clone https://github.com/actus/node_n_push.git
	$ cd push_node
	$ npm install apn
	$ npm install node-gcm


## Usage
 
node_modules에서 pushServer를 load한 후 GCM과 APN의 옵션들을 설정합니다.

	var pushServer = require('pushServer');

###GCM 설정:
GCM에서 알림을 하기 위한 옵션들을 설정합니다.

	var gcmOptions = 
	{
		apiKey : "YOUR API-KEY",							/* Key for server apps */
		messageFile : path.join(process.cwd(), "message")	/* message file path */
	}

apiKey : [Google Apis Console](https://code.google.com/apis/console/)의 API Access 부분에서 Key for server apps 에 있는 API key를 입력합니다.

	$vi message

{"messageKey":"messageFrom", "messageValue":"Caroline"}

와 같은 내용이 나옵니다. Json형식으로 저장되어 있습니다.  <br />
android client에서 intent를 받아 messageFrom = Caroline으로 나오는 것을 확인 할 수 있습니다. <br />
보내고 싶은 메시지는 "Caroline"부분에, key는 "messageFrom" 부분을 변경하시면 됩니다.

	pushServer.setGCMOptions(gcmOptions);

그리고 세팅된 옵션을 setGCMOptions의 인자값으로 넣습니다.

###APN 설정:

자세한 설명은 [node-apn](https://github.com/argon/node-apn)을 참조하십시오.

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

cert와 key에 생성한 .pem 파일의 경로를 입력합니다.
그리고 보낼 메세지 설정을 합니다.

	var noteOptions = {
		expiry : Math.floor(Date.now() / 1000) + 3600, // Expires 1 hour from now.
		badge : 1,
		sound : "ping.aiff",
		alert : "You have a new message",
		payload : {},
		device : undefined
	}

payload부분에서 보낼 key와 message를 입력하게 되는데 
GCM에서 설정했던 message파일 내의 key, value와 동일하게 알림이 전달됩니다.
device부분은 서버에 저장된 ios 기기들 전체에 메시지가 전달되기 때문에 undefined로 설정합니다.


####Feedback

[이 링크](https://groups.google.com/forum/?fromgroups#!topic/easyapns/GbLVI-_RwrM)를 읽어보시고 단말 세팅을 합니다.

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

cert와 key에 생성한 .pem 파일의 경로를 입력합니다. <br />


	pushServer.setAPNS(apnOptions, noteOptions, feedbackOptions);

위에서 세팅된 옵션들을 인자로 넣습니다. <br />
만약 feedback을 사용하지 않는다면 feedbackOptions에 null값을 넣어주시면 됩니다.

	pushServer.listen(pushServerPort, pushServerIP);

serverPort와 serverIP를 설정합니다.

###GCM Client 설정

	CommonUtilities.java
	    static final String SERVER_URL = "YOUR_SERVER_IP:YOUR_SERVER_PORT";
	    static final String SENDER_ID = "YOUR_PROJECT_ID";
server ip와 server port를 설정합니다. 그리고 [Google Apis Console](https://code.google.com/apis/console/)에 있는 project_id를 설정합니다.

###APN Client 설정

	AppDelegate.m 
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 

	[self.viewController requestUrl:@"YOUR_SERVER_IP:YOUR_SERVER_PORT/register"];

server ip와 server port를 설정합니다.

서버에 등록된 단말이 있다면 "YOUR_SERVER_IP:YOUR_SERVER_PORT/sendAll"을 통해서 등록된 모든 android와 ios 단말으로 알림이 발송됩니다.



가장 간단한 방법은 example.js파일을 열어서  <br />
pushServerPort, mCert, mKey, gcmOption의 apiKey 설정 후  <br />
	
	$ node example.js 
	
입니다.


##License

The MIT License

Copyright (c) 2012 Actus (yezune@actus.kr)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


GCMClient is licensed under the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0)