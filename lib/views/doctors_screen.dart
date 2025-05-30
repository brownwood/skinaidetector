import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appservices/dermatologist_service.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  List<dynamic> _doctors = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _highlyRatedOnly = true;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchDoctors();
  }

  Future<void> _getLocationAndFetchDoctors() async {

    try{
    final SharedPreferences sp = await SharedPreferences.getInstance();

    double? latitude = sp.getDouble("lat");
    double? longitude = sp.getDouble("long");

      final doctors = await DermatologistService.getNearbyDermatologists(
        latitude: latitude!,
        longitude: longitude!,
        problemDetected: _highlyRatedOnly,
      );

      setState(() {
        _doctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: doctor['photos'] != null && doctor['photos'].isNotEmpty
            ? CachedNetworkImage(
          imageUrl: doctor['photos'][0],
          placeholder: (context, url) =>
          const CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
          const Icon(Icons.person),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.person, size: 50),
        title: Text(doctor['name'] ?? 'No name'),
        subtitle: Text(doctor['address'] ?? 'No address'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 18),
            Text('${doctor['rating'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Dermatologists'),
        actions: [
          Row(
            children: [
              const Text("Highly Rated"),
              Switch(
                value: _highlyRatedOnly,
                onChanged: (value) {
                  setState(() => _highlyRatedOnly = value);
                  _getLocationAndFetchDoctors();
                },
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _doctors.isEmpty
          ? const Center(child: Text("No dermatologists found."))
          : RefreshIndicator(
        onRefresh: _getLocationAndFetchDoctors,
        child: ListView.builder(
          itemCount: _doctors.length,
          itemBuilder: (context, index) =>
              _buildDoctorCard(_doctors[index]),
        ),
      ),
    );
  }
}
