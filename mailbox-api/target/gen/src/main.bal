
public function main() {
    
    string[] Mailbox__1_0_0_service = [ "post_40a6380c_e2d5_4b81_980f_14d154514d99",
                                 "delete_b4618e6b_9260_454c_b5f1_d561eb9ae884"
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
