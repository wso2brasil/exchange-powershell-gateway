import ballerina/io;
import ballerina/runtime;
import ballerina/http;
import ballerina/log;
import wso2/gateway;

stream<gateway:IntermediateStream> sDefaultintermediateStream = new;
stream<gateway:GlobalThrottleStreamDTO> sDefaultresultStream = new;
stream<gateway:EligibilityStreamDTO> sDefaulteligibilityStream = new;
stream<gateway:RequestStreamDTO> sDefaultreqCopy= gateway:requestStream;
stream<gateway:GlobalThrottleStreamDTO> sDefaultglobalThrotCopy = gateway:globalThrottleStream;

function initSubscriptionDefaultPolicy() {

    forever {
        from sDefaultreqCopy
        select sDefaultreqCopy.messageID as messageID, (sDefaultreqCopy.subscriptionTier == "Default") as
        isEligible, sDefaultreqCopy.subscriptionKey as throttleKey, 0 as expiryTimestamp
        => (gateway:EligibilityStreamDTO[] counts) {
        foreach var c in counts{
            sDefaulteligibilityStream.publish(c);
        }
        }

        from sDefaulteligibilityStream
        throttler:timeBatch(60000)
        where sDefaulteligibilityStream.isEligible == true
        select sDefaulteligibilityStream.throttleKey as throttleKey, count() as eventCount, true as
        stopOnQuota, expiryTimeStamp
        group by sDefaulteligibilityStream.throttleKey
        => (gateway:IntermediateStream[] counts) {
        foreach var c in counts{
            sDefaultintermediateStream.publish(c);
        }
        }

        from sDefaultintermediateStream
        select sDefaultintermediateStream.throttleKey, sDefaultintermediateStream.eventCount>= 500 as isThrottled,
        sDefaultintermediateStream.stopOnQuota, sDefaultintermediateStream.expiryTimeStamp
        group by sDefaulteligibilityStream.throttleKey
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            sDefaultresultStream.publish(c);
        }
        }

        from sDefaultresultStream
        throttler:emitOnStateChange(sDefaultresultStream.throttleKey, sDefaultresultStream.isThrottled)
        select sDefaultresultStream.throttleKey as throttleKey, sDefaultresultStream.isThrottled,
        sDefaultresultStream.stopOnQuota, sDefaultresultStream.expiryTimeStamp
        => (gateway:GlobalThrottleStreamDTO[] counts) {
        foreach var c in counts{
            sDefaultglobalThrotCopy.publish(c);
        }
        }
    }
}

