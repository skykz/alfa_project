// import 'dart:io';

// import 'package:alfa_project/components/widgets/fade_transition.dart';
// import 'package:alfa_project/core/data/consts/app_const.dart';
// import 'package:alfa_project/provider/story_bloc.dart';
// import 'package:alfa_project/screens/home/create_edit_template.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LoadingImageScreen extends StatelessWidget {
//   final String imageUrl;
//   const LoadingImageScreen({Key key, this.imageUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final storyBloc = Provider.of<StoryBloc>(context,listen: false);
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Color(0xFF6E7886).withOpacity(0.8),
//           resizeToAvoidBottomPadding: false,
//           body: Center(
//             child: CachedNetworkImage(
//               imageUrl: BASE_URL_IMAGE + imageUrl,
//               imageBuilder: (context, imageProvider) {
//                 storyBloc.set
//               // }a
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                       image: imageProvider,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//               placeholder: (context, url) => Center(
//                 child: !Platform.isAndroid
//                     ? const CupertinoActivityIndicator(
//                         radius: 15,
//                       )
//                     : SizedBox(
//                         height: 25,
//                         width: 25,
//                         child: const CircularProgressIndicator(
//                           strokeWidth: 2,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),
//               ),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           )),
//     );
//   }
// }
