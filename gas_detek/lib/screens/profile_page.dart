import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
     return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).canvasColor,]
              )
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( top: 16, right: 16,),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                    constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                    child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: const Card(
          margin: EdgeInsets.all(40.0),
          color: Color.fromARGB(255, 189, 232, 252),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Center(
              child: Text('Lorem Ipsum is simply dummy text of the printing and' 
                'typesetting industry. Lorem Ipsum has been the industrys standard dummy' 
                'text ever since the 1500s, when an unknown printer took a galley of type' 
                'and scrambled it to make a type specimen book. It has survived not only '
                'five centuries, but also the leap into electronic typesetting, remaining' 
                'essentially unchanged. It was popularised in the 1960s with the release of' 
                'Letraset sheets containing Lorem Ipsum passages.',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20, // size theo pixel 
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.underline
                )
              )
            ),
          ),
        ),
    );
  }

}