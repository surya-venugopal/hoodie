import 'package:flutter/material.dart';

class ChatPeople extends StatefulWidget {
  static const route = "ChatPeople";
  const ChatPeople({super.key});
  @override
  State<ChatPeople> createState() => _ChatPeopleState();
}

class _ChatPeopleState extends State<ChatPeople> {
  var searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE2DEFF),
      body: CustomScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
              childCount: 50,
              (context, index) {
                return ColoredBox(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        minVerticalPadding: 20,
                        horizontalTitleGap: 30,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("assets/test.png"),
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Surya",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        subtitle: const Text(
                          "Hi, How are you",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.90,
                        color: Colors.black12,
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
