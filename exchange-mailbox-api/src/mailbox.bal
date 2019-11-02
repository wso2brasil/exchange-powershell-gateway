import ballerina/file;
//import ballerina/filepath;
import ballerina/io;

import ballerina/http;
import ballerina/log;
import ballerina/system;


@http:ServiceConfig {
    basePath: "/"
}
service mailbox on new http:Listener(9090) {

    resource function sayHello(http:Caller caller, http:Request req) {
        var result = caller->respond("Hello, World!");
        if (result is error) {
                log:printError("Error sending response", result);
        }
    }

    // 1 garantir que somente application/json seja enviado
    // 2 verificar se ha espaco em disco disponivel
    // 3 Garantir que o arquivo foi criado com sucesso
    // 4 Criar arquivo na pasta recebido
    // 5 Verificar que o payload esta em conformidade com o esperado
    // 6 Verificar se conseguiu fechar o arquivo
    // 7 Criar uma configuracao para determinar onde gravar o arquivo

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/mailbox"
    }    
    resource function newMailbox(http:Caller caller, http:Request req) {
        var payload = req.getJsonPayload();
        string _uuid = system:uuid();
        string path = file:getCurrentDirectory() + "/" + _uuid + ".json";
        var _wbc = io:openWritableFile( path );
        if( _wbc is io:WritableByteChannel) {
            io:WritableByteChannel wbc = _wbc;
            io:WritableCharacterChannel wch = new(wbc, "UTF8");
            if (payload is json) {
                json _payload = payload;
                var _res = wch.writeJson( _payload );
            }
            closeWc(wch);
        }
        json response = { "uuid": _uuid };
        var result = caller->respond( response );
    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}