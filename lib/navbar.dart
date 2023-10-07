import 'package:flutter/material.dart';
import 'package:fire_archive/Service.dart';
import 'package:fire_archive/helpline.dart';
import 'package:fire_archive/safety_index.dart';
import 'package:fire_archive/safety_std.dart';

class NavBar extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Text(
                  "DashBoard",
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      'https://s01.sgp1.cdn.digitaloceanspaces.com/article/176553-utozsasvkp-1656677011.jpg'),
                  fit: BoxFit.cover,
                ))),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Safety Index',
                    icon: Icons.add_chart_outlined,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Color.fromARGB(179, 9, 9, 9)),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Helpline',
                    icon: Icons.phone,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Color.fromARGB(179, 9, 9, 9)),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Safety Standards',
                    icon: Icons.security,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Color.fromARGB(179, 9, 9, 9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => Safety_index(),
        ));
        break;
      case 1:Navigator.push(context,MaterialPageRoute(
        builder: (context) => ServicesPage(),
      ));
          break;
      case 2:
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => safety_std(),
        ));
        break;
    }
  }
}