import 'package:flutter/material.dart';
import 'package:mqtt_client_iot_project/keypadButton.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_client_iot_project/dataProviderModel.dart';
import 'package:mqtt_client_iot_project/mqttHive.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider( create: (context) => dataProviderModel()),
      ChangeNotifierProvider( create: (context) => MQTTClientWrapper()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple KeyPad',
        debugShowCheckedModeBanner: false,
      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({super.key});
  // This widget is the home page of your application.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState() {
    // TODO: implement initState
    Provider.of<MQTTClientWrapper>(context,listen: false).prepareMqttClient(); // Connect to HiveMQ, initiate subScribe and publish
    super.initState();
  }

  //
  List buttonList = [
    keypadButton(button: 0, buttonName: 'Light', iconName: Icons.lightbulb),
    keypadButton(button: 1, buttonName: 'Power', iconName: Icons.power),
    keypadButton(button: 2, buttonName: 'Curtain', iconName: Icons.curtains ),
    keypadButton(button: 3, buttonName: 'Lock', iconName: Icons.lock ),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return
      Scaffold(
      backgroundColor: Colors.black26,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'WELCOME',
                style: TextStyle(fontSize: 20,color: Colors.white
                ),
              ),
            ),
            Text(
              'OCTAVA IoT',
              style: TextStyle(fontSize: 40,color: Colors.white
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text('Temperature (C)', style: TextStyle(fontSize: 20,color: Colors.white),),

            Text(Provider.of<MQTTClientWrapper>(context).myData,  // This is not receiving the changeNotifier 'myData'
              style: TextStyle(fontSize: 20,color: Colors.white),),

            Expanded(
            child: GridView.builder(
                itemCount: buttonList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: buttonList[index],

                  );
                }),
          ),

          ],
        ),
      ),

    );
  }
}
