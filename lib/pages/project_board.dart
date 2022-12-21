import 'package:flutter/material.dart';

class BoardTab extends StatefulWidget {
  const BoardTab({super.key});

  @override
  State<BoardTab> createState() => _BoardTabBuilder();
}

class _BoardTabBuilder extends State<BoardTab> with TickerProviderStateMixin {
  PageController pageController = PageController();
  List<String> topic = ["TODO", "IN PROGRESS", "DONE"];
  List<List<String>> data = [
    ["User Profile Page"],
    [
      "Show home screen",
      "Project Interface | Board",
      "Create new project",
      "Project Interface | Backlog",
      "Project Interface | Roadmap",
      "Project Interface | Setting => show project detail",
      "Epic page",
      "Issue Page",
      "jdjdjdd",
      "sdsds",
      "Epic page",
      "Issue Page",
      "jdjdjdd",
      "sdsds",
      "Epic page",
      "Issue Page",
      "jdjdjdd",
      "sdsds",
    ],
    [
      "Log In",
      "Sign Up",
      "Change Password",
    ]
  ];

  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);

    super.initState();
  }

  List<Card> buildListCard(int id) {
    List<Card> res = <Card>[];
    for (var i in data[id]) {
      res.add(
        Card(
          child: ListTile(
            title: Text(i.toString()),
            onTap: () {},
          ),
        ),
      );
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // Size pSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(200)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: PageView.builder(
              controller: pageController,
              // physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: topic.length,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final val = topic[index];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(153, 1, 176, 234),
                        width: double.infinity,
                        margin: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(val),
                            ),
                            ListView(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              children: buildListCard(index),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.create,
                                size: 24.0,
                              ),
                              label: const Text('Create'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              topic.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: pageIndex == index
                        ? const Color.fromARGB(255, 55, 52, 52)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
