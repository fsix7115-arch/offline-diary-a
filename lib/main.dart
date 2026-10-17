import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(const OfflineDiaryApp());

class OfflineDiaryApp extends StatelessWidget {
  const OfflineDiaryApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(title: 'Offline Diary — A', theme: ThemeData.dark(), home: const DiaryHome());
}

class DiaryHome extends StatefulWidget {
  const DiaryHome({super.key});
  @override State<DiaryHome> createState() => _DiaryHomeState();
}

class _DiaryHomeState extends State<DiaryHome> {
  final _controller = TextEditingController();
  List<String> entries = [];
  final _file = File('offline_diary.json');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (await _file.exists()) {
      final data = await _file.readAsString(); setState(() => entries = List<String>.from(jsonDecode(data)));
    }
  }

  Future<void> _save() async {
    await _file.writeAsString(jsonEncode(entries));
  }

  Future<void> _add() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => entries.add('${DateTime.now()}: ${_controller.text}'));
    _controller.clear();
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Diary A')),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (_, i) => ListTile(title: Text(entries[i])),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Write entry...'))),
            ElevatedButton(onPressed: _add, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
