# exchange-powershell-gateway

Se o diretorio api_definitions nao existir, o build ira falhar com essa mensagem "File write operations failed during ballerina code" 

docker run -d -v /Users/joaoemilio/wso2/projects/banco-pichincha/exchange-connector/mailbox-api/target:/home/exec/ -p 9095:9095 -p 9090:9090 -e project="mailbox-api"  wso2/wso2micro-gw:3.0.1

No Mac, para testes, a versão do microgateway tem que ser a 3.0.2 wso2am-micro-gw-macos-3.0.2.zip
