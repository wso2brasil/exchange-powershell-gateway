
function getOpenAPIs() returns map<json> {
	return {  "Mailbox__1_0_0" : {
  "openapi" : "3.0.1",
  "info" : {
    "title" : "Mailbox",
    "version" : "1.0.0"
  },
  "servers" : [ {
    "url" : "/"
  } ],
  "security" : [ {
    "default" : [ ]
  } ],
  "paths" : {
    "/mailbox" : {
      "post" : {
        "summary" : "Enable an Exchange Server mailbox",
        "description" : "Enable an Exchange Server mailbox",
        "parameters" : [ ],
        "requestBody" : {
          "content" : { },
          "required" : true
        },
        "responses" : {
          "202" : {
            "description" : "ok"
          },
          "404" : {
            "description" : "mailbox not found"
          }
        },
        "security" : [ {
          "default" : [ ]
        } ],
        "extensions" : {
          "x-auth-type" : "None"
        }
      },
      "delete" : {
        "summary" : "disable a mailbox",
        "description" : "disable a mailbox",
        "parameters" : [ ],
        "responses" : {
          "200" : {
            "description" : "ok"
          }
        },
        "security" : [ {
          "default" : [ ]
        } ],
        "extensions" : { }
      }
    }
  },
  "components" : {
    "securitySchemes" : {
      "default" : {
        "type" : "OAUTH2",
        "flows" : {
          "implicit" : {
            "authorizationUrl" : "https://test.com"
          }
        }
      }
    },
    "extensions" : { }
  },
  "extensions" : {
    "x-wso2-auth-header" : "Authorization",
    "x-wso2-cors" : {
      "accessControlAllowOrigins" : [ "*" ],
      "accessControlAllowCredentials" : false,
      "corsConfigurationEnabled" : true,
      "accessControlAllowHeaders" : [ "authorization", "Access-Control-Allow-Origin", "Content-Type", "SOAPAction" ],
      "accessControlAllowMethods" : [ "GET", "PUT", "POST", "DELETE", "PATCH", "OPTIONS" ]
    },
    "x-wso2-basePath" : "/mailbox/1.0.0",
    "x-wso2-production-endpoints" : {
      "type" : "http",
      "urls" : [ "http://localhost:19090" ]
    },
    "x-wso2-sandbox-endpoints" : {
      "type" : "http",
      "urls" : [ "http://localhost:19090" ]
    }
  }
}  };
}