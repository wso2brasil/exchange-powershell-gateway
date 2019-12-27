
public function main() {
    
    string[] Mailbox__1_0_0_service = [ "post_cba68da5_8d65_4632_b0a4_a51d5e45abf1",
                                 "delete_9fc03a50_f640_47ac_9656_f1c6423e9ab2"
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
