import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tomnia/model.dart';

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
  final String token = Model().token!;
  late Future<User?> _user;
  late Future<List<Review>> _reviews;

  @override
  void initState() {
    super.initState();
    _user = fetchCurrentUser(token);
    _reviews = fetchReviews(token);
      Future.microtask(() =>
        Provider.of<Model>(context, listen: false)
            .fetchCurrentUser(token));
  }

  Future<User?> fetchCurrentUser(String token) async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is Map<String, dynamic>) {
        return User.fromJson(json);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch user: ${response.reasonPhrase}');
    }
  }

  Future<List<Review>> fetchReviews(String token) async {
    final user = await fetchCurrentUser(token);
    final url = Uri.parse('http://tomnaia.runasp.net/api/Reviews/GetReview${user?.id}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is List) {
        return json.map<Review>((review) => Review.fromJson(review)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 404) {
      // Return a default review if no reviews are found
      return [
        Review(
          reviewId: 'Admin',
          content: 'No reviews yet. Be the first to leave a review!',
          rating: 5.0,
          date: DateTime.now(),
          rideRequestId: 'Admin',
          reviewerId: 'Admin',
          revieweeId: user?.id ?? 'Admin',
        ),
      ];
    } else {
      throw Exception('Failed to fetch reviews: ${response.reasonPhrase}');
    }
  }

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<User?>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found'));
            } else {
final model = Model().currentUser1;
              return Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF181D33),
                          Color(0xFF1B6896)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200),
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
                           CircleAvatar(
                            radius: 60,
                            backgroundImage:NetworkImage(
                      'http://tomnaia.runasp.net${model!.profilePicture}',
                    ),
                          ),
                          const SizedBox(height: 10),
                           Text(
                            '${model.firstName} ${model.lastName}',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          FutureBuilder<List<Review>>(
                            future: _reviews,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('No reviews');
                              } else {
                                final reviews = snapshot.data!;
                                final averageRating = calculateAverageRating(reviews);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 5),
                                    Text(
                                      averageRating.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                );
                              }
                            },
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
                        FutureBuilder<List<Review>>(
                          future: _reviews,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No reviews');
                            } else {
                              return Column(
                                children: snapshot.data!.map((review) {
                                  return FeedbackTile(
                                    name: review.reviewerId, // Assuming reviewerId is the name for now
                                    rating: review.rating,
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
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
              );
            }
          },
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

class User {
  final String id;
  final String userName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final int? reviewsCount;
  final double? rate;
  final String profilePicture;
  final int accountType;

  User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.reviewsCount,
    this.rate,
    required this.profilePicture,
    required this.accountType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      reviewsCount: json['reviewsCount'],
      rate: json['rate'],
      profilePicture: json['profilePicture'],
      accountType: json['accountType'],
    );
  }
}

class Review {
  final String reviewId;
  final String content;
  final double rating;
  final DateTime date;
  final String rideRequestId;
  final String reviewerId;
  final String revieweeId;

  Review({
    required this.reviewId,
    required this.content,
    required this.rating,
    required this.date,
    required this.rideRequestId,
    required this.reviewerId,
    required this.revieweeId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      content: json['content'],
      rating: json['rating'].toDouble(),
      date: DateTime.parse(json['date']),
      rideRequestId: json['rideRequestId'],
      reviewerId: json['reviewerId'],
      revieweeId: json['revieweeId'],
    );
  }
}
