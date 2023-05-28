import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/chat_user.dart';
import 'package:hoodie/Models/user_management.dart';
import 'package:hoodie/screens/chat_page.dart';

class ChatPeopleFragment extends StatefulWidget {
  const ChatPeopleFragment({super.key});
  @override
  State<ChatPeopleFragment> createState() => _ChatPeopleFragmentState();
}

class _ChatPeopleFragmentState extends State<ChatPeopleFragment> {
  var searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 1 == 1
        ? ColoredBox(
            color: const Color.fromRGBO(203, 194, 255, 45),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      "Discover People",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 200),
                  Column(
                    children: [
                      Image.asset("assets/images/under_construction.png"),
                      const Text(
                        "Under Construction",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("messages")
                .where(
                  "uid",
                  arrayContains: UserProvider.uid,
                )
                .orderBy("lastMessageTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return Container(
                color: const Color(0xffE2DEFF),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      backgroundColor: const Color(0xffE2DEFF),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Messages",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: "Search",
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.black38,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              height: 30,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: snapshot.hasData ? snapshot.data!.size : 1,
                        (c1, index) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.docs[index].data();
                            ChatUser user = ChatUser(
                              lastMessage: data["lastMessage"],
                              lastMessageTime: data["lastMessageTime"],
                              uid: data["uid"][0] == UserProvider.uid
                                  ? data["uid"][1]
                                  : data["uid"][0],
                              avatar: data["uid"][0] == UserProvider.uid
                                  ? data["avatar"][1]
                                  : data["avatar"][0],
                              displayName: data["uid"][0] == UserProvider.uid
                                  ? data["name"][1]
                                  : data["name"][0],
                            );
                            return ColoredBox(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(c1).pushNamed(ChatPage.route,
                                          arguments: user.getMessageId());
                                    },
                                    minVerticalPadding: 20,
                                    horizontalTitleGap: 30,
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset("assets/test.png"),
                                    ),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        user.displayName,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    subtitle: Text(
                                      user.lastMessage,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    color: Colors.black12,
                                  )
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
              );
            });
  }
}
