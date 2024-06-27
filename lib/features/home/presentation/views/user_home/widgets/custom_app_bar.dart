import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final ValueChanged<String>? onSearch;

  const CustomAppBar({Key? key, this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Implement search functionality
              },
              icon: const Icon(
                Icons.search,
                size: 24,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (query) {
                    // Handle search query changes
                    if (onSearch != null) {
                      onSearch!(query);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}