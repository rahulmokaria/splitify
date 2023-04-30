import 'package:contacts_service/contacts_service.dart';
// import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:splitify/ui/utils/colors.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  late Iterable<Contact> contacts;
  bool _isLoading = false;
  List<User> userList = [];

  getContacts() async {
    setState(() {
      _isLoading = true;
    });
    print(1);
    contacts = await ContactsService.getContacts();
    print(1);
    // for (var contact in contacts) {
    //   userList.add(User(
    //       name:
    //           "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
    //       contactNo: contact.phones![0].toString()));
    //   print(contact.givenName);
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    // List<User> userList = [
    //   User(
    //     name: 'John Smith',
    //     email: 'john.smith@example.com',
    //   ),
    //   User(
    //     name: 'Alice Johnson',
    //     email: 'alice.johnson@example.com',
    //   ),
    //   User(
    //     name: 'Bob Williams',
    //     email: 'bob.williams@example.com',
    //   ),
    //   User(
    //     name: 'Emma Davis',
    //     email: 'emma.davis@example.com',
    //   ),
    //   User(
    //     name: 'James Rodriguez',
    //     email: 'james.rodriguez@example.com',
    //   ),
    //   User(
    //     name: 'Mia Thompson',
    //     email: 'mia.thompson@example.com',
    //   ),
    //   User(
    //     name: 'Oliver Lee',
    //     email: 'oliver.lee@example.com',
    //   ),
    //   User(
    //     name: 'Sophie Chen',
    //     email: 'sophie.chen@example.com',
    //   ),
    //   User(
    //     name: 'Ryan Garcia',
    //     email: 'ryan.garcia@example.com',
    //   ),
    //   User(
    //     name: 'Isabella Wilson',
    //     email: 'isabella.wilson@example.com',
    //   ),
    //   User(
    //     name: 'David Brown',
    //     email: 'david.brown@example.com',
    //   ),
    //   User(
    //     name: 'Sofia Thomas',
    //     email: 'sofia.thomas@example.com',
    //   ),
    //   User(
    //     name: 'Luke Martinez',
    //     email: 'luke.martinez@example.com',
    //   ),
    //   User(
    //     name: 'Lily Hernandez',
    //     email: 'lily.hernandez@example.com',
    //   ),
    //   User(
    //     name: 'Ethan Robinson',
    //     email: 'ethan.robinson@example.com',
    //   ),
    //   User(
    //     name: 'Emily Allen',
    //     email: 'emily.allen@example.com',
    //   ),
    //   User(
    //     name: 'William Baker',
    //     email: 'william.baker@example.com',
    //   ),
    //   User(
    //     name: 'Ava Nelson',
    //     email: 'ava.nelson@example.com',
    //   ),
    //   User(
    //     name: 'Michael Hall',
    //     email: 'michael.hall@example.com',
    //   ),
    //   User(
    //     name: 'Grace Green',
    //     email: 'grace.green@example.com',
    //   ),
    //   // Add more users here as needed
    // ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: secondary,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: white,
              ),
            )
          : Container(
              width: _width * 100,
              color: secondary,
              padding: EdgeInsets.all(_width * 5),
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
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     Icons.clear,
                        //     color: _searchFocus.hasFocus
                        //         ? Colors.white
                        //         : Colors.transparent,
                        //   ),
                        //   onPressed: () {
                        //     _searchController.clear();
                        //   },
                        // ),
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
                      height: _width * 5,
                    ),
                    for (var user in contacts) ...{
                      if (user.phones!.isNotEmpty) ...{
                        NewFriendBox(contact: user),
                        SizedBox(
                          height: _width * 5,
                        )
                      }
                    }
                  ],
                ),
              ),
            ),
    ));
  }
}

class NewFriendBox extends StatelessWidget {
  Contact contact;
  // User user;
  NewFriendBox({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // Avatar _avatar = DiceBearBuilder(
    // sprite: DiceBearSprite.adventurer,
    // seed:
    // "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
    // ).build();
    // String urlimg = _avatar.svgUri.toString();
    // print(urlimg);
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return InkWell(
      // onTap: () => Navigator.of(context).push(
      // MaterialPageRoute(builder: (_) => FriendDetails(friend: friend))),
      child: Container(
          width: _width * 100,
          height: _width * 23,
          decoration: BoxDecoration(
              color: white.withOpacity(0.1),
              border: Border.all(color: green.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              SizedBox(
                width: _width * 5,
              ),
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: secondary,
                    height: _width * 18,
                    width: _width * 18,
                    child:
                        // _avatar.toImage(),
                        Image.network(
                      // friend.photoUrl,
                      // _avatar.svgUri.toString(),
                      'https://picsum.photos/200',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _width * 5,
              ),
              Container(
                width: _width * 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        // contact.givenName!,
                        // "fds",
                        "${(contact.givenName != null) ? contact.givenName : ""} ${(contact.familyName != null) ? contact.familyName : ""}",
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1,
                        style: const TextStyle(color: white),
                        // maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: _width * 2,
                    ),
                    Flexible(
                      child: Text(
                        // contact.givenName!,
                        // "fds",
                        contact.phones![0].value.toString(),
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 0.8,
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
              Icon(
                FontAwesomeIcons.plus,
                color: white,
              ),
              SizedBox(
                width: _width * 5,
              ),
            ],
          )),
    );
    ;
  }
}

class User {
  String name;
  String? contactNo;

  User({required this.name, required this.contactNo});
}
