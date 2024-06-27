import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wedding/features/auth/data/profile.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/user_to_provider_details_page.dart';


class ProviderListViewItem extends StatelessWidget {
  const ProviderListViewItem({super.key, required this.profile, required this.userData, });
  final Profile profile;
  final Profile userData;
  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserToProviderDetailsPage(
            photographerData: profile,
              userData: userData,
            ),
          ),
        );      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,

        ),
        child: SizedBox(
          height: 125,
          child: Row(
            children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
              aspectRatio: 3.1 / 4,
              child:CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: profile.profilePic!,
                errorWidget:(context,url,error)=> const Icon(Icons.error , color: Colors.red,),
              )

          ),
        ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child:  Text(
                          profile.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 25
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                     Row(
                       children: [
                         const Icon(Icons.location_on),
                         Text(
                          profile.governorate!,
                          style: const TextStyle(
                              fontSize: 20
                          ),
                                             ),
                       ],
                     ),
                    const SizedBox(
                      height: 3,
                    ),

                    Row(
                      children: [
                        const Icon(Icons.currency_pound),
                        Text(profile.price! , style: const TextStyle(fontSize: 20),)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
