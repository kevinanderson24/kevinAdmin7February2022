import 'package:ebutler/Services/database_services.dart';
import 'package:ebutler/model/product_model.dart';
import 'package:ebutler/notifier/product_notifier.dart';
import 'package:ebutler/screens/InformationScreen/info_screen.dart';
import 'package:ebutler/screens/OrderListScreen/orders.dart';
import 'package:ebutler/screens/OrderListScreen/receiver_screen.dart';
import 'package:ebutler/screens/OrderListScreen/scheduled_screen.dart';
import 'package:ebutler/screens/OrderListScreen/status_screen.dart';
import 'package:ebutler/screens/ProductScreen/product_screen.dart';
import 'package:ebutler/screens/UserScreen/user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
        initialData: const [],
        value: DatabaseServices().productStream,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ProductNotifier(),
              ),
            ],
            child: MaterialApp(
              home: DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue[900],
                    title: const Text(
                      "Binus Hotel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    bottom: const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.list), text: 'ORDER'),
                        Tab(
                          icon: Icon(Icons.list),
                          text: 'PRODUCT',
                        ),
                        Tab(
                          icon: Icon(Icons.info),
                          text: 'INFORMATION',
                        ),
                        Tab(
                          icon: Icon(Icons.people),
                          text: 'USER',
                        ),
                      ],
                      unselectedLabelColor: Colors.black,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Orders(),
                      const ListProduct(),
                      const InformationScreen(),
                      const ListUser(),
                    ],
                  ),
                ),
              ),
              routes: {
                ScheduledScreen.routeName: (ctx) => const ScheduledScreen(),
                StatusScreen.routeName: (ctx) => const StatusScreen(),
                Receiver.routeName: (ctx) => const Receiver(),
              },
            ),
          );
        });
  }
}
