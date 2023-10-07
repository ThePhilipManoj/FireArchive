import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import  'service.dart';

class Service {
  final String name;
  final String phoneNumber;
  final IconData icon;

  Service({required this.name, required this.phoneNumber, required this.icon});
}

final List<Service> services = [
  Service(name: 'Police', phoneNumber: '123-456-7890', icon: Icons.local_police),
  Service(name: 'Ambulance', phoneNumber: '987-654-3210', icon: Icons.local_hospital),
  Service(name: 'Fire Services', phoneNumber: '123456789', icon: Icons.local_fire_department),
  // Add more services as needed
];

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helpline"),
        backgroundColor: Colors.blue, // Set app bar color
      ),
      backgroundColor: Colors.grey[200], // Set background color
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color for each service
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Add a subtle box shadow
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(
                  service.icon,
                  color: Colors.blue, // Customize icon color
                  size: 32.0, // Increase icon size
                ),
                title: Text(
                  service.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue, // Text color
                  ),
                ),
                subtitle: Text(
                  service.phoneNumber,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                    color: Colors.grey[700], // Text color
                  ),
                ),
                onTap: () async {
                  final url = 'tel:${service.phoneNumber}';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ServicesPage(),
  ));
}
