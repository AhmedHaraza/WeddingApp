import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedding/features/auth/data/profile.dart';

import 'custom_provider_image.dart';

class ProviderDetails extends StatelessWidget {
  const ProviderDetails({super.key, required this.profile, });
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .2, vertical: 16),
          child:  CustomProviderImage(imageUrl: profile.profilePic!,),
        ),
        const SizedBox(
          height: 40,
        ),
         Text(
          profile.name!,
          style: const TextStyle(
              fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 6,
        ),

         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 3,),
            Text(
              profile.governorate!,
              style:const TextStyle(
                  fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(
              width: 16,
            ),

            Text(
              profile.address!,
              style:const TextStyle(
                  fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        const SizedBox(height: 8,),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone),
            const SizedBox(width:8,),
            Text(
              profile.phoneNumber!,
              style:const TextStyle(
                  fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        const SizedBox(height: 8,),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.poundSign),
            const SizedBox(width:8,),
            Text(
              profile.price!,
              style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        )


      ],
    );
  }
}
