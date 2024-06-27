import 'package:flutter/material.dart';
import 'package:wedding/features/home/presentation/views/user_home/widgets/faq_item.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 28),
        child: ListView(
          children: const <Widget>[
            FAQItem(
              question: 'What is the purpose of the wedding application?',
              answer:
              'The wedding application is designed to assist couples in planning and organizing their wedding events. It provides various features to streamline the planning process, manage guest lists, share event details, and capture memorable moments.'
                  ,
            ),
            FAQItem(
              question: 'Is the wedding application free to use?',
              answer:
              'Yes, the basic version of the wedding application is free to use. However, there may be premium features or upgrades available for purchase within the app.',
            ),
            FAQItem(
                question: "What features does the wedding application offer?",
                answer: "The wedding application offers a range of features, including:"
                    "\n. Guest list management"
                    "\n. Photo and video sharing"
            ),
            FAQItem(
              question: ' Is my data secure on the wedding application?',
              answer:
              ' Yes, we prioritize the security and privacy of your data. The wedding application employs encryption and follows industry-standard security measures to ensure the confidentiality of your wedding-related information.',
            ),
            // Add more FAQ items as needed
          ],
        ),
      ),
    );
  }
}

