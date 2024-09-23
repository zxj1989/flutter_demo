import 'package:flutter/material.dart';
import '../linked_list/linked_list.dart';

class LinkedListsPage extends StatelessWidget {
  const LinkedListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Linked Lists Page'),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: const Text("xxx"),
            ),
            const Expanded(
              child: LinkedListsWidget(),
            )
          ],
        ));
  }
}
