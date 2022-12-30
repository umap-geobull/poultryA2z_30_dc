import 'package:flutter/material.dart';

import '../../User_Profile/User_Profile_Screen.dart';
import '../Utils/constants.dart';


class Maindrawer extends StatelessWidget {
  const Maindrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: kPrimaryColor,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 10
                      
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/profile.png'),
                        fit: BoxFit.fill)

                    )
                  ),
                  const Text('John Smith',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  )),
                  const Text('johnsmith@gmail.com',
                      style: TextStyle(

                        color: Colors.white,
                      ))

                ],
              ),
            ),
          ),
           ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home', style: TextStyle(fontSize: 18),
            ),
           onTap: () {
             /*Navigator.of(context).pop();
             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));*/
           },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Profile', style: TextStyle(fontSize: 18),
            ),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const User_Profile_Screen()));
            },
          ),
           const ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'History', style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
           const ListTile(
            leading: Icon(Icons.help),
            title: Text(
              'Help', style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          const ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'Share', style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),

           const ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout', style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          )

        ],
      )
    );
  }
}
