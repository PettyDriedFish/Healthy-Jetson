import 'package:flutter/material.dart';

class DisplayTHCard extends StatelessWidget{
  const DisplayTHCard ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      // color: Colors.white,
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            // offset: Offset(5, 5),
          ),
        ],
      ),
      child:
      ListView(
        children: [
          Text("Current indoor conditions", textAlign: TextAlign.left, style: TextStyle(fontSize: 16,),),
          Divider(),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            // color: Colors.white,
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  // offset: Offset(5, 5),
                ),
              ],
            ),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1/0.25,
              ),
              children: [
                Text("Temperature", textAlign: TextAlign.left,),
                Text("25", textAlign: TextAlign.center,),
                Text("Humidity", textAlign: TextAlign.left,),
                Text("45", textAlign: TextAlign.center,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}