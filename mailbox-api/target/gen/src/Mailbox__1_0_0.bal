import ballerina/log;
import ballerina/http;
import ballerina/config;
import ballerina/time;

import wso2/gateway;

    http:Client Mailbox__1_0_0_prod = new (
gateway:retrieveConfig("api_fd1ba85a0c78d69ab5affe1ceed9165c97e56f64cb6f6dd189ac16bb906fd0ee_prod_endpoint_0","http://localhost:19090"),
config = { 
    httpVersion: gateway:getHttpVersion(),
secureSocket:{
    trustStore: {
           path: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PATH,
               "${ballerina.home}/bre/security/ballerinaTruststore.p12"),
           password: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PASSWORD, "ballerina")
     },
     verifyHostname:gateway:getConfigBooleanValue(gateway:HTTP_CLIENTS_INSTANCE_ID, gateway:ENABLE_HOSTNAME_VERIFICATION, true)
}
});


    http:Client Mailbox__1_0_0_sand = new (
gateway:retrieveConfig("api_fd1ba85a0c78d69ab5affe1ceed9165c97e56f64cb6f6dd189ac16bb906fd0ee_sand_endpoint_0","http://localhost:19090"),
config = { 
    httpVersion: gateway:getHttpVersion(),
secureSocket:{
    trustStore: {
           path: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PATH,
               "${ballerina.home}/bre/security/ballerinaTruststore.p12"),
           password: gateway:getConfigValue(gateway:LISTENER_CONF_INSTANCE_ID, gateway:TRUST_STORE_PASSWORD, "ballerina")
     },
     verifyHostname:gateway:getConfigBooleanValue(gateway:HTTP_CLIENTS_INSTANCE_ID, gateway:ENABLE_HOSTNAME_VERIFICATION, true)
}
});







    
    
    
    
    
    

    
    
    
    
    
    










@http:ServiceConfig {
    basePath: "/mailbox/1.0.0",
    authConfig:{
    
        authProviders:["jwt","oauth2"]
    
    },
    cors: {
         allowOrigins: ["*"],
         allowCredentials: false,
         allowHeaders: ["authorization","Access-Control-Allow-Origin","Content-Type","SOAPAction"],
         allowMethods: ["GET","PUT","POST","DELETE","PATCH","OPTIONS"]
    }
    
}

@gateway:API {
    publisher:"",
    name:"Mailbox",
    apiVersion: "1.0.0" ,
    authorizationHeader : "Authorization" 
}
service Mailbox__1_0_0 on apiListener,
apiSecureListener {


    @http:ResourceConfig {
        methods:["POST"],
        path:"/mailbox",
        authConfig:{
    
        authProviders:["jwt","oauth2"]
     ,
            authentication:{enabled:false}  

        }
    }
    @gateway:RateLimit{policy : ""}
    resource function post_40a6380c_e2d5_4b81_980f_14d154514d99 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForMailbox__1_0_0(outboundEp, req);
    
    
    string urlPostfix = untaint req.rawPath.replaceFirst("/mailbox/1.0.0", "");
    if (urlPostfix != "" && !urlPostfix.hasPrefix("/")) {
        urlPostfix = "/" + urlPostfix;
    }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        runtime:getInvocationContext().attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientEndpointConfig newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>runtime:getInvocationContext().attributes["KEY_TYPE"]) {
                
                    
    clientResponse = Mailbox__1_0_0_prod->forward(urlPostfix, req);

runtime:getInvocationContext().attributes["destination"] = "http://localhost:19090";
                
                } else {
                
                    
    clientResponse = Mailbox__1_0_0_sand->forward(urlPostfix, req);

runtime:getInvocationContext().attributes["destination"] = "http://localhost:19090";
                
                }
            
            
        
        
        runtime:getInvocationContext().attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(errorMessage.contains("connection timed out") || errorMessage.contains("Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(errorMessage.contains("Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            // Todo: error is not type any -> runtime:getInvocationContext().attributes["error_response"] =  clientResponse;
            runtime:getInvocationContext().attributes[gateway:ERROR_RESPONSE_CODE] = errorCode;
            runtime:getInvocationContext().attributes[gateway:ERROR_RESPONSE] = errorDescription;
            json payload = {fault : {
                code : errorCode,
                message : "Runtime Error",
                description : errorDescription
            }};
            res.setPayload(payload);
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }


    @http:ResourceConfig {
        methods:["DELETE"],
        path:"/mailbox",
        authConfig:{
    
        authProviders:["jwt","oauth2"]
      

        }
    }
    @gateway:RateLimit{policy : ""}
    resource function delete_b4618e6b_9260_454c_b5f1_d561eb9ae884 (http:Caller outboundEp, http:Request req) {
        handleExpectHeaderForMailbox__1_0_0(outboundEp, req);
    
    
    string urlPostfix = untaint req.rawPath.replaceFirst("/mailbox/1.0.0", "");
    if (urlPostfix != "" && !urlPostfix.hasPrefix("/")) {
        urlPostfix = "/" + urlPostfix;
    }
        http:Response|error clientResponse;
        http:Response r = new;
        clientResponse = r;
        string destination_attribute;
        runtime:getInvocationContext().attributes["timeStampRequestOut"] = time:currentTime().time;
        boolean reinitRequired = false;
        string failedEtcdKey = "";
        string failedEtcdKeyConfigValue = "";
        boolean|error hasUrlChanged;
        http:ClientEndpointConfig newConfig;
        boolean reinitFailed = false;
        boolean isProdEtcdEnabled = false;
        boolean isSandEtcdEnabled = false;
        map<string> endpointEtcdConfigValues = {};
        
            
                if("PRODUCTION" == <string>runtime:getInvocationContext().attributes["KEY_TYPE"]) {
                
                    
    clientResponse = Mailbox__1_0_0_prod->forward(urlPostfix, req);

runtime:getInvocationContext().attributes["destination"] = "http://localhost:19090";
                
                } else {
                
                    
    clientResponse = Mailbox__1_0_0_sand->forward(urlPostfix, req);

runtime:getInvocationContext().attributes["destination"] = "http://localhost:19090";
                
                }
            
            
        
        
        runtime:getInvocationContext().attributes["timeStampResponseIn"] = time:currentTime().time;


        if(clientResponse is http:Response) {
            
            
            var outboundResult = outboundEp->respond(clientResponse);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        } else {
            http:Response res = new;
            res.statusCode = 500;
            string errorMessage = clientResponse.reason();
            int errorCode = 101503;
            string errorDescription = "Error connecting to the back end";

            if(errorMessage.contains("connection timed out") || errorMessage.contains("Idle timeout triggered")) {
                errorCode = 101504;
                errorDescription = "Connection timed out";
            }
            if(errorMessage.contains("Malformed URL")) {
                errorCode = 101505;
                errorDescription = "Malformed URL";
            }
            // Todo: error is not type any -> runtime:getInvocationContext().attributes["error_response"] =  clientResponse;
            runtime:getInvocationContext().attributes[gateway:ERROR_RESPONSE_CODE] = errorCode;
            runtime:getInvocationContext().attributes[gateway:ERROR_RESPONSE] = errorDescription;
            json payload = {fault : {
                code : errorCode,
                message : "Runtime Error",
                description : errorDescription
            }};
            res.setPayload(payload);
            log:printError("Error in client response", err = clientResponse);
            var outboundResult = outboundEp->respond(res);
            if (outboundResult is error) {
                log:printError("Error when sending response", err = outboundResult);
            }
        }
    }

}

    function handleExpectHeaderForMailbox__1_0_0 (http:Caller outboundEp, http:Request req ) {
        if (req.expects100Continue()) {
            req.removeHeader("Expect");
            var result = outboundEp->continue();
            if (result is error) {
            log:printError("Error while sending 100 continue response", err = result);
            }
        }
    }

function getUrlOfEtcdKeyForReInitMailbox__1_0_0(string defaultUrlRef,string etcdRef, string defaultUrl, string etcdKey) returns string {
    string retrievedEtcdKey = <string> gateway:retrieveConfig(etcdRef,etcdKey);
    gateway:urlChanged[<string> retrievedEtcdKey] = false;
    string url = <string> gateway:etcdUrls[retrievedEtcdKey];
    if (url == "") {
        return <string> gateway:retrieveConfig(defaultUrlRef, defaultUrl);
    } else {
        return url;
    }
}