import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/screens/customer/split_bills/split_bills.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../../utils/colors.dart';
import '../../../widgets/glassmorphic_container.dart';
import '../../../widgets/show_snackbar.dart';

class AddFriendFromContactsPage extends StatefulWidget {
  const AddFriendFromContactsPage({super.key});

  @override
  State<AddFriendFromContactsPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendFromContactsPage> {
  TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late Iterable<Contact> contacts = [];

  bool _isLoading = false;
  List<Contact> filteredContacts = [];
  getContacts() async {
    setState(() {
      _isLoading = true;
    });

    contacts = await ContactsService.getContacts();

    // Remove duplicates from phone numbers
    Set<String> seenPhoneNumbers = {};
    List<Contact> tempFilteredContacts = [];

    for (Contact contact in contacts) {
      if (contact.phones != null && contact.phones!.isNotEmpty) {
        List<Item> uniquePhones = [];
        for (Item phone in contact.phones!) {
          if (!seenPhoneNumbers.contains(phone.value)) {
            seenPhoneNumbers.add(phone.value!);
            uniquePhones.add(phone);
          }
        }
        // Create a new Contact with unique phone numbers
        Contact uniqueContact = Contact(
          givenName: contact.givenName,
          familyName: contact.familyName,
          phones: uniquePhones,
        );
        tempFilteredContacts.add(uniqueContact);
      }
    }

    setState(() {
      filteredContacts = tempFilteredContacts;
      _isLoading = false;
    });
  }

  void filterContacts() {
    final searchText = _searchController.text.toLowerCase();

    setState(() {
      filteredContacts = contacts.where((contact) {
        final name = contact.givenName?.toLowerCase() ?? '';
        final phone = contact.phones?.isNotEmpty == true
            ? contact.phones![0].value
                    ?.replaceAll(RegExp(r'\D'), '')
                    .toLowerCase() ??
                ''
            : '';
        return name.contains(searchText) || phone.contains(searchText);
      }).toList();
    });
  }

  @override
  initState() {
    super.initState();
    getContacts();
    _searchController = TextEditingController();
    _searchController.addListener(filterContacts);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    // return SafeArea(
    // child: Scaffold(
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(FontAwesomeIcons.arrowLeft)),
        title: const Text(
          'Add new friend',
        ),
        backgroundColor: green,
      ),
      backgroundColor: secondary,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: white,
              ),
            )
          : Container(
              width: width * 100,
              color: secondary,
              padding: EdgeInsets.all(width * 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      cursorColor: white,
                      controller: _searchController,
                      focusNode: _searchFocus,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: _searchFocus.hasFocus
                              ? Colors.white
                              : Colors.grey,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: _searchFocus.hasFocus
                              ? Colors.white
                              : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 5,
                    ),
                    for (var user in filteredContacts) ...{
                      if (user.phones!.isNotEmpty) ...{
                        NewFriendContactBox(contact: user),
                        SizedBox(
                          height: width * 2,
                        )
                      }
                    }
                  ],
                ),
              ),
            ),
      // ),
    );
  }
}

class NewFriendContactBox extends StatefulWidget {
  final Contact contact;
  // User user;
  const NewFriendContactBox({super.key, required this.contact});

  @override
  State<NewFriendContactBox> createState() => _NewFriendContactBoxState();
}

class _NewFriendContactBoxState extends State<NewFriendContactBox> {
  final bool _isLoading = false;
  textContact() async {
// if we are unable to launch the phone app, we will throw an error. This is what the below line means. launch is an in-built function provided by url_launcher
//  if (!await launch('tel:+919876543210')) throw 'Could not launch phone app';
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: widget.contact.phones![0].value.toString(),
      queryParameters: <String, String>{
        'body': Uri.encodeQueryComponent(
            'Hi ${widget.contact.givenName}! Tap this link to add me as a friend on Splitify: https://github.com/rahulmokaria'),
      },
    );

    launchUrl(smsLaunchUri);
  }

  sendFriendReq() async {
    try {
      String endPoint = dotenv.env["URL"].toString();
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: "authtoken");
      if (widget.contact.phones == null) throw ("Contact number not found");
      // print("kuchbhi");
      // print(widget.contact.phones![0].value.toString());
      String contactNo = widget.contact.phones![0].value.toString();
      if (contactNo.length > 10) {
        String finalcontactNo = contactNo.replaceAll(RegExp(r'\D'), '');
        contactNo = finalcontactNo;
      }
      if (contactNo.length > 10) {
        contactNo = contactNo.substring(contactNo.length - 10);
      }
      // print(contactNo);

      var response = await http.post(
        Uri.parse("$endPoint/friendSplitApi/addNewFriend"),
        body: {
          "token": value,
          "contactNo": contactNo,
        },
      );
      var res = jsonDecode(response.body) as Map<String, dynamic>;
      // print(res);
      if (res['flag']) {
        if (res['message'] == "Success") {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SplitBillsPage()));

          return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
            ctype: ContentType.success,
            message: "Friend added. Now you can easily split bills.",
          ));
        } else if (res['message'] == "User does not exist.") {
          // redirect to direct message
          if (!mounted) return;
          Navigator.of(context).pop();
          redirectToTextContact(context);
        }
      }
    } catch (e) {
      // print("Add new friend from contacts error: $e");
      if (!mounted) return;
      Navigator.of(context).pop();
      return ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
        ctype: ContentType.failure,
        message: "$e. Please contact admin to resolve",
      ));
    }
  }

  void redirectToTextContact(BuildContext context) {
    // Show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      showCustomSnackBar(
        ctype: ContentType.failure,
        message: "User is not registered.",
      ),
    );

    // Delay for 1 second and then call textContact
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        textContact();
      }
    });
  }

  confirmToSendPopUp(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: white,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Are you sure you want to send request to ${widget.contact.givenName}?',
                            style: const TextStyle(color: white),
                          ),
                          SizedBox(height: width * 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  sendFriendReq();
                                },
                                child: const Text('Send'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // confirmToSendPopUp(BuildContext context) {
  //   double width = MediaQuery.of(context).size.width * 0.01;
  //   print("confim clicked");
  //   return Dialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     elevation: 0,
  //     backgroundColor: Colors.transparent,
  //     child: Stack(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(width * 5),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.rectangle,
  //             color: secondary,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                   'Are you sure you want to send request to ${widget.contact.phones![0]}')
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;
    // double _height = MediaQuery.of(context).size.height * 0.01;

    return InkWell(
      // onTap: () => Navigator.of(context).push(
      // MaterialPageRoute(builder: (_) => FriendDetails(friend: friend))),
      onTap: () => confirmToSendPopUp(context),
      child: SizedBox(
        width: width * 100,
        height: width * 20,
        child: GlassMorphism(
            end: 0,
            start: 0.25,
            accent: green,
            borderRadius: 20,
            child: Row(
              children: [
                SizedBox(
                  width: width * 5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: secondary,
                    height: width * 18,
                    width: width * 18,
                    child:
                        // _avatar.toImage(),
                        //     Image.asset(
                        //   contact.avatar.toString(),
                        //   fit: BoxFit.cover,
                        // ),
                        Image.network(
                      // friend.photoUrl,
                      // _avatar.svgUri.toString(),
                      'https://picsum.photos/200',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 5,
                ),
                SizedBox(
                  width: width * 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          // contact.givenName!,
                          // "fds",
                          "${(widget.contact.givenName != null) ? widget.contact.givenName : ""} ${(widget.contact.familyName != null) ? widget.contact.familyName : ""}",
                          overflow: TextOverflow.ellipsis,
                          // textScaleFactor: 1,
                          // textScaler:const TextScaler.linear(),
                          style: const TextStyle(color: white),
                          // maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.5,
                      ),
                      Flexible(
                        child: Text(
                          // contact.givenName!,
                          // "fds",
                          widget.contact.phones![0].value.toString(),
                          overflow: TextOverflow.ellipsis,
                          // textScaleFactor: 0.8,
                          textScaler: const TextScaler.linear(0.8),
                          style: const TextStyle(color: white),
                          // maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(),
                // ),

                const Icon(
                  FontAwesomeIcons.plus,
                  color: white,
                ),
                SizedBox(
                  width: width * 5,
                ),
              ],
            )),
      ),
    );
  }
}

class User {
  String name;
  String? contactNo;

  User({required this.name, required this.contactNo});
}
