// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../utils/colors.dart';

// class AddFriendPage extends StatefulWidget {
//   const AddFriendPage({super.key});

//   @override
//   State<AddFriendPage> createState() => _AddFriendPageState();
// }

// class _AddFriendPageState extends State<AddFriendPage> {
//   TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocus = FocusNode();
//   late Iterable<Contact> contacts;
//   bool _isLoading = false;
//   List<Contact> filteredContacts = [];

//   getContacts() async {
//     setState(() {
//       _isLoading = true;
//     });
//     // print(1);

//     contacts = await ContactsService.getContacts();
//     filteredContacts = contacts.toList();
//     // print(1);
//     // for (var contact in contacts) {
//     //   userList.add(User(
//     //       name:
//     //           "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
//     //       contactNo: contact.phones![0].toString()));
//     //   print(contact.givenName);
//     // }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void filterContacts() {
//     final searchText = _searchController.text.toLowerCase();
//     setState(() {
//       filteredContacts = contacts
//           .where((contact) =>
//               contact.givenName!.toLowerCase().contains(searchText) ||
//               contact.phones![0].toString().toLowerCase().contains(searchText))
//           .toList();
//     });
//     // print(_searchController.text);
//   }

//   @override
//   initState() {
//     super.initState();
//     getContacts();
//     _searchController = TextEditingController();
//     _searchController.addListener(filterContacts);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width * 0.01;

//     // List<User> userList = [
//     //   User(
//     //     name: 'John Smith',
//     //     email: 'john.smith@example.com',
//     //   ),
//     //   User(
//     //     name: 'Alice Johnson',
//     //     email: 'alice.johnson@example.com',
//     //   ),
//     //   User(
//     //     name: 'Bob Williams',
//     //     email: 'bob.williams@example.com',
//     //   ),
//     //   User(
//     //     name: 'Emma Davis',
//     //     email: 'emma.davis@example.com',
//     //   ),
//     //   User(
//     //     name: 'James Rodriguez',
//     //     email: 'james.rodriguez@example.com',
//     //   ),
//     //   User(
//     //     name: 'Mia Thompson',
//     //     email: 'mia.thompson@example.com',
//     //   ),
//     //   User(
//     //     name: 'Oliver Lee',
//     //     email: 'oliver.lee@example.com',
//     //   ),
//     //   User(
//     //     name: 'Sophie Chen',
//     //     email: 'sophie.chen@example.com',
//     //   ),
//     //   User(
//     //     name: 'Ryan Garcia',
//     //     email: 'ryan.garcia@example.com',
//     //   ),
//     //   User(
//     //     name: 'Isabella Wilson',
//     //     email: 'isabella.wilson@example.com',
//     //   ),
//     //   User(
//     //     name: 'David Brown',
//     //     email: 'david.brown@example.com',
//     //   ),
//     //   User(
//     //     name: 'Sofia Thomas',
//     //     email: 'sofia.thomas@example.com',
//     //   ),
//     //   User(
//     //     name: 'Luke Martinez',
//     //     email: 'luke.martinez@example.com',
//     //   ),
//     //   User(
//     //     name: 'Lily Hernandez',
//     //     email: 'lily.hernandez@example.com',
//     //   ),
//     //   User(
//     //     name: 'Ethan Robinson',
//     //     email: 'ethan.robinson@example.com',
//     //   ),
//     //   User(
//     //     name: 'Emily Allen',
//     //     email: 'emily.allen@example.com',
//     //   ),
//     //   User(
//     //     name: 'William Baker',
//     //     email: 'william.baker@example.com',
//     //   ),
//     //   User(
//     //     name: 'Ava Nelson',
//     //     email: 'ava.nelson@example.com',
//     //   ),
//     //   User(
//     //     name: 'Michael Hall',
//     //     email: 'michael.hall@example.com',
//     //   ),
//     //   User(
//     //     name: 'Grace Green',
//     //     email: 'grace.green@example.com',
//     //   ),
//     //   // Add more users here as needed
//     // ];
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: secondary,
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: white,
//               ),
//             )
//           : Container(
//               width: width * 100,
//               color: secondary,
//               padding: EdgeInsets.all(width * 5),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextField(
//                       cursorColor: white,
//                       controller: _searchController,
//                       focusNode: _searchFocus,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.2),
//                         prefixIcon: Icon(
//                           FontAwesomeIcons.magnifyingGlass,
//                           color: _searchFocus.hasFocus
//                               ? Colors.white
//                               : Colors.grey,
//                         ),
//                         // suffixIcon: IconButton(
//                         //   icon: Icon(
//                         //     Icons.clear,
//                         //     color: _searchFocus.hasFocus
//                         //         ? Colors.white
//                         //         : Colors.transparent,
//                         //   ),
//                         //   onPressed: () {
//                         //     _searchController.clear();
//                         //   },
//                         // ),
//                         hintText: 'Search',
//                         hintStyle: TextStyle(
//                           color: _searchFocus.hasFocus
//                               ? Colors.white
//                               : Colors.grey,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(100),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: width * 5,
//                     ),
//                     for (var user in filteredContacts) ...{
//                       if (user.phones!.isNotEmpty) ...{
//                         NewFriendBox(contact: user),
//                         SizedBox(
//                           height: width * 5,
//                         )
//                       }
//                     }
//                   ],
//                 ),
//               ),
//             ),
//     ));
//   }
// }

// class NewFriendBox extends StatelessWidget {
//  final  Contact contact;
//   // User user;
//   const NewFriendBox({super.key, required this.contact});

//   textContact() async {
// // if we are unable to launch the phone app, we will throw an error. This is what the below line means. launch is an in-built function provided by url_launcher
// //  if (!await launch('tel:+919876543210')) throw 'Could not launch phone app';
//     final Uri smsLaunchUri = Uri(
//       scheme: 'sms',
//       path: contact.phones![0].value.toString(),
//       queryParameters: <String, String>{
//         'body': Uri.encodeComponent(
//             'Hi ${contact.givenName}! Tap this link to add me as a friend on Splitify: https://github.com/rahulmokaria'),
//       },
//     );

//     launchUrl(smsLaunchUri);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Avatar _avatar = DiceBearBuilder(
//     // sprite: DiceBearSprite.adventurer,
//     // seed:
//     // "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
//     // ).build();
//     // String urlimg = _avatar.svgUri.toString();
//     // print(urlimg);
//     double width = MediaQuery.of(context).size.width * 0.01;

//     return InkWell(
//       // onTap: () => Navigator.of(context).push(
//       // MaterialPageRoute(builder: (_) => FriendDetails(friend: friend))),
//       onTap: () => textContact(),
//       child: Container(
//           width: width * 100,
//           height: width * 23,
//           decoration: BoxDecoration(
//               color: white.withOpacity(0.1),
//               border: Border.all(color: green.withOpacity(0.3)),
//               borderRadius: BorderRadius.circular(20)),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: width * 5,
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: Container(
//                   color: secondary,
//                   height: width * 18,
//                   width: width * 18,
//                   child:
//                       // _avatar.toImage(),
//                       //     Image.asset(
//                       //   contact.avatar.toString(),
//                       //   fit: BoxFit.cover,
//                       // ),
//                       Image.network(
//                     // friend.photoUrl,
//                     // _avatar.svgUri.toString(),
//                     'https://picsum.photos/200',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: width * 5,
//               ),
//               SizedBox(
//                 width: width * 48,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         // contact.givenName!,
//                         // "fds",
//                         "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
//                         overflow: TextOverflow.ellipsis,
//                         // textScaleFactor: 1,
//                         style: const TextStyle(color: white),
//                         // maxLines: 1,
//                       ),
//                     ),
//                     SizedBox(
//                       height: width * 2,
//                     ),
//                     Flexible(
//                       child: Text(
//                         // contact.givenName!,
//                         // "fds",
//                         contact.phones![0].value.toString(),
//                         overflow: TextOverflow.ellipsis,
//                         // textScaleFactor: 0.8,
//                         textScaler: const TextScaler.linear(0.8),
//                         style: const TextStyle(color: white),
//                         // maxLines: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Flexible(
//               //   flex: 1,
//               //   child: Container(),
//               // ),
//               const Icon(
//                 FontAwesomeIcons.plus,
//                 color: white,
//               ),
//               SizedBox(
//                 width: width * 5,
//               ),
//             ],
//           )),
//     );
    
//   }
// }

// class User {
//   String name;
//   String? contactNo;

//   User({required this.name, required this.contactNo});
// }
