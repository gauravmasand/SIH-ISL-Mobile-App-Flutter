import 'package:flutter/material.dart';

// Updated SavedAnnouncementsPage
class SavedAnnouncementsPage extends StatefulWidget {
  const SavedAnnouncementsPage({Key? key}) : super(key: key);

  @override
  _SavedAnnouncementsPageState createState() => _SavedAnnouncementsPageState();
}

class _SavedAnnouncementsPageState extends State<SavedAnnouncementsPage> {
  String _filterType = 'All';
  bool _isPlaying = false;
  int? _playingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Announcements'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filterType = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All',
                child: Text('All Announcements'),
              ),
              const PopupMenuItem(
                value: 'Flight',
                child: Text('Flight Only'),
              ),
              const PopupMenuItem(
                value: 'Train',
                child: Text('Train Only'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Filter: $_filterType'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search announcements...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Replace with actual announcements count
              itemBuilder: (context, index) {
                final isPlaying = _playingIndex == index && _isPlaying;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            index % 2 == 0 ? Icons.flight : Icons.train,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(
                          index % 2 == 0
                              ? 'Flight AA123 - Gate 5'
                              : 'Train 456 - Platform 3',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('From: City A\nTo: City B'),
                            Text(
                              'Time: 10:00 AM • Date: 2024-02-20',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_playingIndex == index) {
                                    _isPlaying = !_isPlaying;
                                  } else {
                                    _playingIndex = index;
                                    _isPlaying = true;
                                  }
                                });
                                // Implement play/pause functionality
                              },
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              onSelected: (value) {
                                // Handle menu item selection
                              },
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                      if (isPlaying)
                        Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('ISL Animation Here'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}