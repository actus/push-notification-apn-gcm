var path = require("path");
var pushServer = require('pushServer');

var pushServerPort = "YOUR_SERVER_PORT";
var pushServerIP = null;

var mCert = path.join(process.cwd(), "cert.pem");
var mKey = path.join(process.cwd(), "key.pem");

var gcmOptions = 
{
	apiKey : "YOUR API-KEY",				/* Key for server apps */
	messageFile : path.join(process.cwd(), "message")	/* message file path */
}

var apnOptions = {
	cert: mCert,                  /* Certificate file path */
	certData: null,               /* String or Buffer containing certificate data, if supplied uses this instead of cert file path */
    key:  mKey,                       /* Key file path */
    keyData: null,                    /* String or Buffer containing key data, as certData */
    passphrase: null,                 /* A passphrase for the Key file */
    ca: null,                         /* String or Buffer of CA data to use for the TLS connection */
    gateway: 'gateway.sandbox.push.apple.com',/* gateway address */
    port: 2195,                       /* gateway port */
    enhanced: true,                   /* enable enhanced format */
    errorCallback: undefined,         /* Callback when error occurs function(err,notification) */
    cacheLength: 100                  /* Number of notifications to cache for error purposes */
};

var noteOptions = {
	expiry : Math.floor(Date.now() / 1000) + 3600, // Expires 1 hour from now.
	badge : 1,
	sound : "ping.aiff",
	alert : "You have a new message",
	payload :{},
	device : undefined
}

var feedbackOptions = {
    cert: mCert,                   	/* Certificate file */
    certData: null,                     /* Certificate file contents (String|Buffer) */
    key:  mKey,                   	/* Key file */
    keyData: null,                      /* Key file contents (String|Buffer) */
    passphrase: null,                   /* A passphrase for the Key file */
    ca: null,                           /* Certificate authority data to pass to the TLS connection */
    address: 'feedback.sandbox.push.apple.com', /* feedback address */
    port: 2196,                         /* feedback port */
    feedback: false,                    /* enable feedback service, set to callback */
    interval: 300                    	/* interval in seconds to connect to feedback service */
};

pushServer.setGCMOptions(gcmOptions);
pushServer.setAPNS(apnOptions, noteOptions, feedbackOptions);
pushServer.listen(pushServerPort, pushServerIP);
