import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/model.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold( 
  appBar: AppBar(
    title: const Text('Ride Details'),
  ),
  body: Consumer<Model>(
    builder: (context, mapProvider, child) {
      return ListView(
        children: [
          // Map section
          SizedBox(
            height: 150, // Adjust the height as needed
            child: FlutterMap(
              options: MapOptions(
                initialCenter: mapProvider.startLatLng!,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                if (mapProvider.startLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapProvider.startLatLng!,
                        child: const Icon(Icons.location_on,
                            color: Colors.green, size: 40),
                      ),
                    ],
                  ),
                if (mapProvider.endLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapProvider.endLatLng!,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                if (mapProvider.polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: mapProvider.polylinePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          // Ride details
          ListTile(
            title: Text(mapProvider.selectedDateTime?.toString() ?? ''),
            subtitle: Text(mapProvider.city!),
          ),
          ListTile(
            title: const Text('From'),
            subtitle: Text(mapProvider.startAddress ?? 'Fetching address...'),
            trailing: Text(mapProvider.selectedDateTime
                    ?.toLocal()
                    .toString()
                    .substring(11, 16) ??
                ''),
          ),
          ListTile(
            title: const Text('To'),
            subtitle: Text(mapProvider.endAddress ?? 'Fetching address...'),
          ),
          
          // Divider
          const Divider(),

          // List of passengers
          ...List.generate(3, (index) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/avatar.jpg'),
              ),
              title: const Text('Bella Alex'),
              trailing: ElevatedButton(
                onPressed: () {
               
                },
                child: const Text('Chat'),
              ),
            );
          }),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  ),
);
  }
}
