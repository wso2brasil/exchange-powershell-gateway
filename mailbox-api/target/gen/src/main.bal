
public function main() {
    
    string[] Mailbox__1_0_0_service = [ "post_50c58192_5dc1_49f0_8421_4064b455df63",
                                 "delete_4bc074a4_3f19_4950_a138_d9953a7bd92e"
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
