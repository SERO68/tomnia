import 'package:flutter/material.dart';

import 'Homedriver/profiledriver.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:  Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tomnaia',
              style: TextStyle(
                fontFamily: 'Sail',
                fontSize: 30,
                color: Color.fromARGB(255, 38, 37, 136),
              ),
            ),
            CircleAvatar(backgroundImage:    const AssetImage(
              'images/serologo.png',
              
            ) ,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profiledriver(),
                      ),
                    );
                  },
                ),)
          
          ],
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            SettingTile(
              title: 'Change Name',
              subtitle: 'Sero Ahmed',
               titleStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
            ),
            SettingTile(
              title: 'Change Password',
              subtitle: '*******',
               titleStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
            ),
            SettingTile(
              title: 'Change Phone Number',
              subtitle: '+2011111111',
              titleStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
            ),
            SettingTile(
              title: 'Change Main Address',
              subtitle: 'Qina, Qina, 32 St',
               titleStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
            ),
            SettingTile(
              title: 'Change Account Type',
              subtitle: 'Passenger',
               titleStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
            ),
            SettingTile(
              title: 'Delete The account',
              subtitle: '',
              titleStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.w400,fontSize: 18),
            ),
          ],
        ),
      ),
        );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;

  const SettingTile({super.key, required this.title, required this.subtitle, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 2,margin: const EdgeInsets.all(10),color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: titleStyle,
        ),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}