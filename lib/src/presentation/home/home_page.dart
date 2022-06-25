// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_simple_ping/src/presentation/home/ping_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
            child: Stack(
          children: [
            Container(
              color: Colors.grey.shade200,
            ),
            Container(
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    title: Text(widget.title.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            letterSpacing: 2,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.grey,
                    elevation: 4,
                    floating: false,
                    foregroundColor: Colors.white,
                    flexibleSpace: const FlexibleSpaceBar(),
                    expandedHeight: 60,
                    bottom: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        indicatorPadding:
                            const EdgeInsets.only(top: 40, bottom: 2),
                        // isScrollable: true,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: const Tab(text: 'Ping')),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: const Tab(text: 'Network Info')),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: const Tab(text: 'About App')),
                        ]
                        // controller: controller,
                        ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          PingTab(),
                          Container(color: Colors.blue),
                          Container(color: Colors.green),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
