import 'package:flutter/material.dart';
import 'package:calculator/data/history.dart';

class HistoryPage extends StatelessWidget {
  final List<History> history;
  final Function(List<History>) onRemoveHistory;

  const HistoryPage(
      {super.key, required this.history, required this.onRemoveHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calculation History'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                // Remove all history
                if (history.isNotEmpty) {
                  onRemoveHistory([]);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Remove history',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: history.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'No History Available',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  title: Text(
                    item.equation,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.result,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  horizontalTitleGap: 2,
                );
              },
            ),
    );
  }
}
