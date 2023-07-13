import 'package:flutter/material.dart';
import 'package:jetson_home/pages/tabs/Home.dart';
import 'package:jetson_home/pages/tabs/Wifi.dart';
import 'package:jetson_home/pages/tabs/Chart.dart';
import 'package:jetson_home/pages/tabs/ChartTest.dart';
import 'package:jetson_home/pages/tabs/WifiSwitch.dart';
import 'package:jetson_home/pages/tabs/Customsize.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;//默认选中第0个
  bool isConnected = false;
  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = IOWebSocketChannel.connect('ws://192.168.3.27:8000/websocket');
    channel!.stream.listen((message) {
      // 处理收到的消息
      setState(() {
        // 更新连接状态或其他数据
        isConnected = true; // 假设收到消息表示连接成功
      });
    }, onDone: () {
      // WebSocket连接关闭时的处理
      setState(() {
        isConnected = false; // 更新连接状态为false
      });
    });
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  //页面列表
  List _pageList = [
    HomePage(),
    // WifiPage(),
    CustomizePage(),
    // WifiSwitchPage(),
    ChartPage(),
    // SliderExamplePage(),
    // ChartTestPage(),
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        //最上面导航栏
        appBar: AppBar(
          title: Align(
            alignment: Alignment.bottomLeft,
            child: ListTile(
              title: Text(
                "Healthy Jetson",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                ),
              ),
              trailing: Icon(
                isConnected ? Icons.sync_alt : Icons.mobiledata_off_outlined,
                color: Color.fromRGBO(15, 15, 17, 0.9),
              ),
            ),
          ),
        ),
        //侧边弹窗
        // drawer: Drawer(
        //     child: Column(
        //       children: const <Widget>[
        //         UserAccountsDrawerHeader(
        //           accountName: Text("Lychee"),
        //           accountEmail: Text("Lychee@jetson.com"),
        //           currentAccountPicture: CircleAvatar(
        //             backgroundImage: AssetImage("images/account.png"),
        //           ),
        //           decoration: BoxDecoration(
        //             // color: Colors.amber,
        //             image: DecorationImage(
        //               image: AssetImage("images/drawerBackground.png"),
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           title: Text("Personal Center"),
        //           leading: CircleAvatar(
        //             backgroundColor: Color.fromRGBO(239,146,115,1),
        //             child: Icon(Icons.account_circle, color: Colors.white,),
        //           ),
        //         ),
        //         Divider(),
        //         ListTile(
        //           title: Text("Settings"),
        //           leading: CircleAvatar(
        //             backgroundColor: Color.fromRGBO(239,146,115,1),
        //             child: Icon(Icons.settings, color: Colors.white,),
        //           ),
        //         ),
        //       ],
        //     )
        // ),
        //主体
        body: this._pageList[this._currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFF3F3E7),
          type: BottomNavigationBarType.fixed,//解决底部导航四个的时候字体无法显示的情况
          currentIndex: this._currentIndex,//默认初始选中第0个Homepage
          onTap: (int index){
            setState(() {
              this._currentIndex = index;
            });
          },
          selectedItemColor: Color.fromRGBO(210,180,140,1),
          unselectedItemColor: Color.fromRGBO(15,15,17,0.9),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: "Customize",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: "Chart",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.smart_button),
            //   label: "Slider",
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.query_stats),
            //   label: "Test",
            // ),
          ],
        ),
      );
    // }
  }
}


// class BottomBar extends StatelessWidget{
//   const BottomBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     //获取设备的宽度和高度
//     final size = MediaQuery.of(context).size;
//
//     return Stack(
//       children: [
//         Positioned(
//           bottom: 0,
//           width: size.width,
//           height: 50,
//           child: Container(
//             color: Colors.blueGrey,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconContainer(Icons.home, color: Colors.blueGrey),
//                 IconContainer(Icons.pending_actions, color: Colors.blueGrey),
//                 IconContainer(Icons.search, color: Colors.blueGrey),
//                 IconContainer(Icons.settings, color: Colors.blueGrey),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class IconContainer extends StatelessWidget{
//   Color color;
//   IconData icon;
//   IconContainer(this.icon,{super.key, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         alignment: Alignment.center,
//         height: 120,
//         width: 120,
//         color: color,
//         child: Icon(
//           icon,
//           color: Colors.white,
//           size: 28,
//         )
//     );
//   }
// }