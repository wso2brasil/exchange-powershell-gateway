//import ballerina/filepath;
import ballerina/io;

import ballerina/http;
import ballerina/log;
import ballerina/system;
import ballerina/config;

const HTTP_BAD_REQUEST = 400;
const HTTP_ACCEPTED = 202;
const HTTP_CREATED = 201;
const HTTP_SUCCESS = 200;

@http:ServiceConfig {
    basePath: "/"
}
service mailbox on new http:Listener(config:getAsInt("http.port", 19090)) {

    // 1 garantir que somente application/json seja enviado
    // 2 verificar se ha espaco em disco disponivel
    // 3 Garantir que o arquivo foi criado com sucesso
    // 4 Criar arquivo na pasta recebido
    // 5 Verificar que o payload esta em conformidade com o esperado
    // 6 Verificar se conseguiu fechar o arquivo
    // 7 Criar uma configuracao para determinar onde gravar o arquivo
    // 8 configurar respostas http corretamente

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/mailbox"
    }    
    resource function newMailbox(http:Caller caller, http:Request req) {
        // Get payload. It must be json and match Mailbox record
        var payload = req.getJsonPayload();

        // Certify it is a Mailbox record by testing the identity attribute
        if( payload is json ) {
            Mailbox|error _mailbox = Mailbox.constructFrom(payload);
            if(_mailbox is Mailbox ) {
                if( _mailbox.identity.trim() == "" ) {
                    errorResponse( caller, HTTP_BAD_REQUEST, "Bad Request. Identity is an empty string");
                    return;
                }
                log:printDebug("enable mailbox for identity: " + _mailbox.identity);
                string _uuid = enableMailbox( payload );
                string message = "identity accepted for mailbox enablement (" + _mailbox.identity + ")";
                successResponse( caller, HTTP_ACCEPTED, _uuid, <@untainted> message );
                return;
            } else {
                errorResponse( caller, HTTP_BAD_REQUEST, "Bad Request. Identity attribute is missing");
                return;
            }
        } else {
            errorResponse( caller, HTTP_BAD_REQUEST, "Bad Request. Not a valid json.");
            return;
        }

    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

function successResponse( http:Caller caller, int statusCode, string _uuid, string message ) {
    // Response successful with UUID to verify later if the mailbox has been enabled
    http:Response response = new;
    json responsePayload = { success: { "uuid": _uuid, "message": message } };
    response.setPayload( responsePayload );
    response.statusCode = statusCode;

    var result = caller->respond( response );
}

function errorResponse( http:Caller caller, int statusCode, string message ) {
    //TODO respond with BAD REQUEST HTTP. Message needs to be JSON 
    http:Response response = new;
    json responsePayload = { "error": {"message": message } };
    response.setPayload( responsePayload );
    response.statusCode = statusCode;    
    var result = caller->respond( response );
}

function enableMailbox( json mailbox ) returns string {
    // Get path to store the new request
    string _path = config:getAsString("path.enable.in");
    log:printDebug( "path enable.in " + _path );
    string _uuid = system:uuid();
    string path = _path + "/" + _uuid + ".json";

    // TODO Verify if identity exists. This needs a diferent API that is not yet developed.

    log:printDebug( "Create a json file for the PowerShell Script to enable mailbox later on a schedule task" );
    var _wbc = io:openWritableFile( path );

    log:printDebug( "verify if the file has been opened successfully " );
    if( _wbc is io:WritableByteChannel) {
        io:WritableCharacterChannel wch = new(_wbc, "UTF8");
        var _res = wch.writeJson( mailbox );
        closeWc(wch);
    }

    return _uuid;
}

type Mailbox record {
  string identity;
};