import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../models/bus_model.dart';

class BusSelector extends StatefulWidget {
  const BusSelector({super.key});

  @override
  State<BusSelector> createState() => _BusSelectorState();
}

class _BusSelectorState extends State<BusSelector> {
  String? selectedBusNumber;
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredBusNumbers = MockBusData.getAllBusNumbers();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBusNumbers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBusNumbers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredBusNumbers = MockBusData.getAllBusNumbers();
      } else {
        filteredBusNumbers = MockBusData.getAllBusNumbers()
            .where((busNumber) => busNumber.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _selectBus(String busNumber) {
    setState(() {
      selectedBusNumber = busNumber;
      _searchController.text = busNumber;
    });
    
    // Update the location provider with selected bus
    Provider.of<LocationProvider>(context, listen: false)
        .setBusNumber(busNumber);
    
    // Close the dropdown
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Icons.directions_bus,
                  color: Color(0xFF4F86C6),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Bus',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Bus Selection
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Bus Number',
                hintText: 'BUS001, BUS002...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: selectedBusNumber != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            selectedBusNumber = null;
                            _searchController.clear();
                          });
                          Provider.of<LocationProvider>(context, listen: false)
                              .setBusNumber('');
                        },
                      )
                    : const Icon(Icons.keyboard_arrow_down),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              readOnly: false,
              onTap: () {
                _showBusSelectionModal();
              },
            ),
            
            if (selectedBusNumber != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned: $selectedBusNumber',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            _getBusRoute(selectedBusNumber!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getBusRoute(String busNumber) {
    Bus? bus = MockBusData.getBusByNumber(busNumber);
    return bus?.route ?? 'Route information not available';
  }

  void _showBusSelectionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Select Bus',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bus List
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredBusNumbers.length,
                      itemBuilder: (context, index) {
                        final busNumber = filteredBusNumbers[index];
                        final bus = MockBusData.getBusByNumber(busNumber);
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.directions_bus,
                              color: Colors.blue[600],
                            ),
                          ),
                          title: Text(
                            busNumber,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(bus?.route ?? 'No route info'),
                          trailing: selectedBusNumber == busNumber
                              ? Icon(Icons.check, color: Colors.green[600])
                              : null,
                          onTap: () {
                            _selectBus(busNumber);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}