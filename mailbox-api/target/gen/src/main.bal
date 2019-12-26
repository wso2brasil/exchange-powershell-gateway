
public function main() {
    
    string[] Mailbox__1_0_0_service = [ "post_87976dd3_ffda_4350_bf98_199273822543",
                                 "delete_ca610ad7_ee2f_4067_80ed_9a5912c054bb"
                                ];
    gateway:populateAnnotationMaps("Mailbox__1_0_0", Mailbox__1_0_0, Mailbox__1_0_0_service);
    

    initThrottlePolicies();

    map<string> receivedRevokedTokenMap = gateway:getRevokedTokenMap();
    boolean jmsListenerStarted = gateway:initiateTokenRevocationJmsListener();

    boolean useDefault = gateway:getConfigBooleanValue(gateway:PERSISTENT_MESSAGE_INSTANCE_ID,
    gateway:PERSISTENT_USE_DEFAULT, false);

    if (useDefault){
        future<()> initETCDRetriveal = start gateway:etcdRevokedTokenRetrieverTask();
    } else {
        initiatePersistentRevokedTokenRetrieval(receivedRevokedTokenMap);
    }
    startupExtension();
}
