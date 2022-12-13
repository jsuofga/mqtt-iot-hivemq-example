
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client_iot_project/dataProviderModel.dart';
import 'package:mqtt_client_iot_project/mqttHive.dart';



class keypadButton extends StatelessWidget {
  final int button;
  final String buttonName;
  final IconData iconName;

  // constructor
  keypadButton({this.button,this.buttonName, this.iconName});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(buttonName,style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(iconName,color: Colors.white,),
          ),
          CupertinoSwitch(
              activeColor: Colors.blueAccent,
              trackColor: Colors.white54,
              thumbColor: CupertinoColors.white,
              value: Provider.of<dataProviderModel>(context).slideSwitchStates[button] ,
              onChanged: (value){
                     Provider.of<dataProviderModel>(context,listen: false).toggleSwitch(button);
                     if(Provider.of<dataProviderModel>(context,listen: false).slideSwitchStates[button] == true){
                        //ON
                       switch(button){
                         case 0:

                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin7_gpio4_on');
                           break;
                         case 1:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin11_gpio17_on');
                           break;
                         case 2:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin12_gpio18_on');
                           break;
                         case 3:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin13_gpio27_on');
                           break;
                       }

                     }else{
                        //OFF
                       switch(button){
                         case 0:

                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin7_gpio4_off');
                           break;
                         case 1:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin11_gpio17_off');
                           break;
                         case 2:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin12_gpio18_off');
                           break;
                         case 3:
                           Provider.of<MQTTClientWrapper>(context,listen: false).publishMessage('pin13_gpio27_off');
                           break;
                       }
                     }
              }),
          Container(
            child: Provider.of<dataProviderModel>(context).slideSwitchStates[button] == true ? Text('ON',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent)): Text('OFF',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white60))
          ),

        ],
      ),
    );
  }
}



