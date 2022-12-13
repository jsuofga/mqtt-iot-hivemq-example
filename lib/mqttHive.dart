import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';

// connection states for easy identification
enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED
}

class MQTTClientWrapper extends ChangeNotifier{

  MqttServerClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  String hiveMQ_cluster = 'enterYourHiveMQ_cluster';
  String hiveMQ_username = 'enter your hive mq user';
  String hiveMQ_password = 'enter your hive mq password';
  String mqtt_client_name = 'client name, it can be anything';
  int mqtt_port = 8883;
  String mqttTopic = 'Dart/Mqtt_client/octava/testtopic/pi';  // enter your topic name here.

  var myData = 'Loading...' ;  //Need to pass updates to widget, using Provider

  // using async tasks, so the connection won't hinder the code flow
  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic(mqttTopic);
    _publishMessage('Reading CPU Temp');
  }

  void publishMessage(_message){
    //Added by Jeff
    _publishMessage(_message);
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect(hiveMQ_username, hiveMQ_password);
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;

      print('client connected');

    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(hiveMQ_cluster, mqtt_client_name, mqtt_port);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

 void _subscribeToTopic(String topicName) {

    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    //print the message when it is received
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {

      final MqttPublishMessage recMess = c[0].payload ;
      String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('YOU GOT A NEW MESSAGE:');
      myData = message;
      print(myData);
      if(myData.contains('gpio')){
        //Don't display mqtt message if it contains 'gpio'
        //Display temperature of cpu only
      }
      else{
        notifyListeners();
      }

    });

  }

  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    print('Publishing message "$message" to topic ${mqttTopic}');
    client.publishMessage(mqttTopic , MqttQos.exactlyOnce, builder.payload);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was sucessful');
  }

}