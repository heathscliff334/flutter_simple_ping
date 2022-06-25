// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PingTab extends StatefulWidget {
  const PingTab({
    Key? key,
  }) : super(key: key);

  @override
  State<PingTab> createState() => _PingTabState();
}

class _PingTabState extends State<PingTab>
    with AutomaticKeepAliveClientMixin<PingTab> {
  bool get wantKeepAlive => true;
  final _key = GlobalKey<FormState>();
  bool? _pingStart = false;
  final TextEditingController _hostController = TextEditingController();
  final List<String>? _pingResponse = [];
  Ping? ping;
  final ScrollController _scrollController = ScrollController();

  void _startPing(String _host) async {
    _pingResponse!.clear();
    ping =
        Ping(_host.toString(), encoding: const Utf8Codec(allowMalformed: true));
    inspect(ping);
    ping!.stream.listen((event) {
      String? _temp = event
          .toString()
          .replaceAll("PingResponse(", "")
          .replaceAll(")", "")
          .replaceAll("PingSummary(", "")
        ..replaceAll("PingError(", "");
      setState(() => _pingResponse!.add(_temp.toString()));
      if (_pingResponse!.length > 20) {
        _scrollDown();
      }
    });
  }

  void _stopPing() async {
    await ping!.stop();
    if (_pingResponse!.length > 20) {
      _scrollDown();
    }
  }

  void _scrollDown() {
    // ? With animation
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );
    // ? Without animation
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            // color: Colors.blue,
            child: Form(
              key: _key,
              child: Row(
                children: [
                  Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      height: double.infinity,
                      child: const Text("Host :",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        child: TextFormField(
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Host cannot be empty.";
                        }
                      },
                      autofocus: false,
                      enableInteractiveSelection: false,
                      controller: _hostController,
                      maxLines: 1,
                      decoration: const InputDecoration(hintText: "google.com"),
                    )),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    child: Bounceable(
                        onTap: () {
                          if (!_pingStart!) {
                            final form = _key.currentState;
                            if (form!.validate()) {
                              form.save();
                              setState(() => _pingStart = !_pingStart!);
                              _startPing(_hostController.text);
                            }
                          } else {
                            _stopPing();
                            setState(() => _pingStart = !_pingStart!);
                          }
                        },
                        child: Icon(
                          _pingStart!
                              ? FontAwesomeIcons.circleStop
                              : FontAwesomeIcons.circlePlay,
                          size: 30,
                          color: _pingStart! ? Colors.red : Colors.green,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              padding: const EdgeInsets.only(top: 10),
              child: _pingResponse!.length > 0
                  ? Scrollbar(
                      child: ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: _pingResponse!.length,
                          itemBuilder: (context, i) => Container(
                                // height: 30,
                                margin: EdgeInsets.only(
                                  top: i == 0 ? 0 : 10,
                                  // bottom: i ==  _pingResponse.length? 10 : 0,
                                ),
                                width: double.infinity,
                                // color: Colors.blue,
                                child: FlipInX(
                                    child: _pingResponse![i]
                                            .contains('transmitted')
                                        ? Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              _pingResponse![i].toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ))
                                        : Text(_pingResponse![i].toString())),
                              )),
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }
}
