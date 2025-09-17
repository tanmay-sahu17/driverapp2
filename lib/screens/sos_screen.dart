import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../services/api_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isEmergencyActive = false;
  String? _emergencyMessage;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendSosAlert() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if (_isEmergencyActive) {
      // Stop emergency
      setState(() {
        _isEmergencyActive = false;
        _emergencyMessage = null;
      });
      _showSnackbar('Emergency stopped', Colors.green);
      return;
    }

    if (locationProvider.currentPosition == null) {
      _showSnackbar('Location not available. Please enable GPS tracking.', Colors.red);
      return;
    }

    final message = _messageController.text.trim().isNotEmpty 
        ? _messageController.text.trim() 
        : 'Emergency SOS Alert from Driver';

    setState(() {
      _isEmergencyActive = true;
      _emergencyMessage = message;
    });

    try {
      await ApiService.sendSosAlert(
        driverId: authProvider.user?['uid'] ?? 'unknown',
        busNumber: locationProvider.selectedBusNumber ?? 'Unknown',
        latitude: locationProvider.currentPosition!.latitude,
        longitude: locationProvider.currentPosition!.longitude,
        emergencyMessage: message,
      );

      _showSnackbar('SOS Alert sent successfully!', Colors.orange);
    } catch (e) {
      _showSnackbar('Failed to send SOS alert: $e', Colors.red);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Emergency SOS',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer2<AuthProvider, LocationProvider>(
          builder: (context, authProvider, locationProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Emergency Status Card
                  Card(
                    elevation: _isEmergencyActive ? 8 : 2,
                    color: _isEmergencyActive ? Colors.red[50] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _isEmergencyActive ? Colors.red : Colors.grey[300]!,
                        width: _isEmergencyActive ? 2 : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            _isEmergencyActive ? Icons.warning : Icons.security,
                            size: 48,
                            color: _isEmergencyActive ? Colors.red : Colors.grey[600],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isEmergencyActive ? 'Emergency Active' : 'Emergency Standby',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _isEmergencyActive ? Colors.red[700] : Colors.grey[700],
                            ),
                          ),
                          if (_isEmergencyActive && _emergencyMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _emergencyMessage!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location Info Card
                  if (locationProvider.currentPosition != null) ...[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Latitude', locationProvider.currentPosition!.latitude.toStringAsFixed(6)),
                            _buildInfoRow('Longitude', locationProvider.currentPosition!.longitude.toStringAsFixed(6)),
                            _buildInfoRow('Bus Number', locationProvider.selectedBusNumber ?? 'BUS001'),
                            _buildInfoRow('Driver', authProvider.user?['displayName'] ?? 'test'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Emergency Message Input
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Message (Optional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _messageController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Describe your emergency (optional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.red[400]!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // SOS Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _sendSosAlert,
                      icon: Icon(
                        _isEmergencyActive ? Icons.stop : Icons.warning,
                        size: 24,
                      ),
                      label: Text(
                        _isEmergencyActive ? 'STOP EMERGENCY' : 'SEND SOS ALERT',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEmergencyActive ? Colors.green[600] : Colors.red[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Emergency Contacts
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Contacts',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildContactRow('Control Room', '+91-911-EMERGENCY', Icons.headset_mic),
                          const SizedBox(height: 4),
                          _buildContactRow('Police', '100', Icons.local_police),
                          const SizedBox(height: 4),
                          _buildContactRow('Ambulance', '108', Icons.local_hospital),
                          const SizedBox(height: 4),
                          _buildContactRow('Fire Service', '101', Icons.local_fire_department),
                          const SizedBox(height: 4),
                          _buildContactRow('Bus Supervisor', '+91-98765-43210', Icons.supervisor_account),
                        ],
                      ),
                    ),
                  ),
                  
                  // Add bottom padding for scrolling
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(String name, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          _showSnackbar('Calling $name at $number...', Colors.blue);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.phone,
                size: 16,
                color: Colors.green[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}