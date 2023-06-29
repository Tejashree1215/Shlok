import 'package:flutter/material.dart';
import 'package:levelpage/main.dart';

import 'IntroPage.dart';


void main() => runApp(MaterialApp(
  home: IntroPage(),
  debugShowCheckedModeBanner: false,
));


class IntroPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    List<String> name = ['a','b','c'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,

        title: Text('Intro'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text( 'WELCOME', style:TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(
            width: double.infinity,
            height: 400,
            child: ListView.builder(
                itemCount: name.length,
                itemBuilder:(context, index){
                  return Card(
                      child: ListTile(
                        title :Text(name[index].toString()),
                      )
                  );
                }),
          ),
          SizedBox(
            height: 11,
          ),
          ElevatedButton(onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (context)=> MainHome() ,)
            );

          }, child: Text ('Next'))
        ],
      ),
    );


  }


}