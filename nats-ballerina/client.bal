// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/java;

# The client provides the capability to publish messages to the NATS server.
# The `nats:Client` needs the nats url to be initialized.
public client class Client {

    # Creates a new `nats:Client`.
    #
    # + url - The NATS Broker URL. For a clustered use case, pass the URLs as a string array
    # + config - Configurations associated with the NATS client to establish a connection with the server
    public isolated function init(string|string[] url = DEFAULT_URL, ConnectionConfig? config = ()) {
        clientInit(self, url, config);
    }

    # Publishes data to a given subject.
    # ```ballerina
    # nats:Error? result = natsClient->publish(subject, <@untainted>message);
    # ```
    #
    # + subject - The subject to send the message
    # + data - Data to publish
    # + replyTo - The subject or the callback service to which the receiver should send the response
    # + return -  `()` or else a `nats:Error` if there is a problem when publishing the message
    public isolated remote function publish(string subject, byte[] data, (string | service)? replyTo = ())
                    returns Error? {
        return externPublish(self, subject, data, replyTo);
    }

    # Publishes data to a given subject and waits for a response.
    # ```ballerina
    # nats:Message|nats:Error reqReply = natsClient->request(subject, <@untainted>message, 5000);
    # ```
    #
    # + subject - The subject to send the message
    # + data - Data to publish
    # + duration - The time (in milliseconds) to wait for the response
    # + return -  The `nats:Message` response or else a `nats:Error` if an error is encountered
    public isolated remote function request(string subject, byte[] data, int? duration = ())
    returns Message|Error {
        return externRequest(self, subject, data, duration);
    }

    # Closes the nats client connection.
    #
    # + return - `()` or else a `nats:Error` if unable to complete the close the operation
    public isolated function close() returns Error? {
        return closeConnection(self);
    }
}

isolated function clientInit(Client clientObj, string|string[] url, ConnectionConfig? config) =
@java:Method {
    'class: "org.ballerinalang.nats.basic.client.Init"
} external;

isolated function closeConnection(Client clientObj) returns Error? =
@java:Method {
    'class: "org.ballerinalang.nats.basic.client.CloseConnection"
} external;

isolated function externRequest(Client clientObj, string subject, byte[] data, int? duration = ())
returns Message | Error = @java:Method {
    'class: "org.ballerinalang.nats.basic.client.Request"
} external;

isolated function externPublish(Client clientObj, string subject, byte[] data,
(string | service) ? replyTo = ()) returns Error? = @java:Method {
    'class: "org.ballerinalang.nats.basic.client.Publish"
} external;
