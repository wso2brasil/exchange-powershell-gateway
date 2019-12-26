import wso2/gateway;
import ballerina/http;
import ballerina/log;

import ballerinax/docker;


//Throttle tier data initiation


    json ClientCerts=null;




//Get mutualSSL filter
gateway: MutualSSLFilter  mtslFilter= new;
// Get authentication filter
gateway:AuthnFilter authnFilter = getAuthenticationFilter();
// Subscription validation filter
// Authorization filter
gateway:OAuthzFilter authorizationFilter = gateway:getDefaultAuthorizationFilter();
gateway:SubscriptionFilter subscriptionFilter = new;
// Get deployed policies
map<boolean> deployedPolicies = getDeployedPolicies();
// Throttling filter
gateway:ThrottleFilter throttleFilter = new(deployedPolicies);
//get open API definition map
map<json> openAPIs = getOpenAPIs();
// Validation filter
gateway:ValidationFilter validationFilter = new(openAPIs);
// Analytics filter
gateway:AnalyticsRequestFilter analyticsFilter = new;
// Extension filter
ExtensionFilter extensionFilter = new;

http:ServiceEndpointConfiguration secureServiceEndpointConfiguration = { 
    httpVersion: gateway:getHttpVersion(),
                                                                           secureSocket: {
keyStore: {
path:  config:getAsString("listenerConfig.keyStore.path"),
password: config:getAsString("listenerConfig.keyStore.password")
},
trustStore: {
path:  config:getAsString("listenerConfig.trustStore.path"),
password: config:getAsString("listenerConfig.trustStore.password")
},
protocol: {
name: config:getAsString("mutualSSLConfig.ProtocolName"),
versions: ["TLSv1.2", "TLSv1.1"]
},


sslVerifyClient: config:getAsString("mutualSSLConfig.sslVerifyClient")
},

                                                                           filters:[mtslFilter, authnFilter, authorizationFilter, subscriptionFilter, throttleFilter, validationFilter, analyticsFilter,
                                                                           extensionFilter]
                                                                       };


@docker:Config {
    name:"mailbox-api",
    tag:"1.0.0"
}




listener gateway:APIGatewaySecureListener apiSecureListener = new(9095, secureServiceEndpointConfiguration);

http:ServiceEndpointConfiguration serviceEndpointConfiguration = { 
    httpVersion: gateway:getHttpVersion(),
                                                                     filters:[authnFilter, authorizationFilter, subscriptionFilter, throttleFilter, validationFilter, analyticsFilter,
                                                                     extensionFilter]
                                                                 };



listener gateway:APIGatewayListener apiListener = new(9090, serviceEndpointConfiguration);




listener http:Listener tokenListenerEndpoint = new (
    
        gateway:getConfigIntValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TOKEN_LISTENER_PORT, 9096), config = {
        host: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:LISTENER_CONF_HOST, "localhost"),
        secureSocket: {
            keyStore: {
                path: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:LISTENER_CONF_KEY_STORE_PATH,
                    "${ballerina.home}/bre/security/ballerinaKeystore.p12"),
                password: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID,
                    gateway:LISTENER_CONF_KEY_STORE_PASSWORD, "ballerina")
            }
        }
    
    }
);


function getAuthenticationFilter() returns gateway:AuthnFilter {
    http:AuthHandlerRegistry registry = new;
    // Getting basic and JWT authentication providers
    http:AuthProvider[] authProviders = gateway:getAuthProviders();
    int i = 1;
    foreach var provider in authProviders {
        if ( provider.id.length() > 0) {
            registry.add(provider.id, gateway:createAuthHandler(provider));
        } else {
            registry.add(provider.scheme + "-" + i, gateway:createAuthHandler(provider));
        }
        i= i +1;
    }
    // Adding basic and JWT authentication providers to a the handler chain
    http:AuthnHandlerChain authnHandlerChain = new(registry);
    // OAuth authentication handler
    gateway:OAuthnAuthenticator oauthAuthenticator = new;
    // Register OAuth authentication handler,basic and JWT authentication providers to the authentication filter
    return new gateway:AuthnFilter(oauthAuthenticator, authnHandlerChain);
}

