import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Profiledriver extends StatefulWidget {
  const Profiledriver({super.key});

  @override
  State<Profiledriver> createState() => _ProfiledriverState();
}

class _ProfiledriverState extends State<Profiledriver> {
  void createNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Hello!',
        body: 'This is a local notification',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF181D33),
                    Color(0xFF1B6896)
                  ], // Adjust gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(
                        'images/backgroundload.jpg',
                      ), // Your profile image asset
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sero Ahmed',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 5),
                        Text(
                          '4.8',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconContainer(icon: Icons.info, label: 'About'),
                      IconContainer(icon: Icons.history, label: 'History'),
                      IconContainer(icon: Icons.support, label: 'Support'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recent Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const FeedbackTile(name: 'Bella Alex', rating: 4.8),
                  const FeedbackTile(name: 'Bella Alex', rating: 4.8),
                  const SizedBox(height: 20),
                  const Text(
                    'Notification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  NotificationTile(
                    title: 'Ride is complete kick off',
                    onTap: () {
                      createNotification();
                    },
                  ),
                  NotificationTile(
                    title: 'Rider Sero Booked',
                    onTap: () {
                      createNotification();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconContainer({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 36, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final String name;
  final double rating;

  const FeedbackTile({super.key, required this.name, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage(
              'images/backgroundload.jpg'), // Your profile image asset
        ),
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 5),
            Text(rating.toString()),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const Icon(Icons.notifications, color: Colors.blue),
          title: Text(title),
        ),
      ),
    );
  }
}
