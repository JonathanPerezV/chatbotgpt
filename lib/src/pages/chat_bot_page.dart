import 'package:chat_bot_project/src/controller/service_chat_bot.dart';
import 'package:chat_bot_project/src/model/chat_bot_model.dart';
import 'package:chat_bot_project/utils/colors_chat.dart';
import 'package:flutter/material.dart';

import 'chat_widget.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final serviceBot = ServiceChatBot();

  bool waitResponse = false;

  final txtFieldController = TextEditingController();
  final scrollController = ScrollController();

  List<ChatModel> message = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: key,
        appBar: AppBar(
          backgroundColor: backgroundScaffoldColor,
          title: const Text("ChatBot"),
          centerTitle: true,
        ),
        backgroundColor: backgroundScaffoldColor,
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          Expanded(
              child: message.isNotEmpty
                  ? Column(
                      children: [
                        buildChat(),
                        if (waitResponse)
                          Container(
                              padding: const EdgeInsets.only(left: 15),
                              width: double.infinity,
                              height: 20,
                              child: const Text(
                                "ChatBot está escribiendo...",
                                style: TextStyle(color: Colors.white),
                              )),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "Inicia una conversación...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )),
          buildTextField(),
        ],
      );

  Expanded buildChat() => Expanded(
        child: ListView.builder(
            controller: scrollController,
            itemCount: message.length,
            itemBuilder: (context, index) {
              final data = message[index];
              return WidgetMessage(
                text: data.text,
                type: data.messageType,
              );
            }),
      );

  Widget buildTextField() => Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(left: 15),
        width: double.infinity,
        height: 70,
        color: backgroundTextField,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: () async {
                  await Future.delayed(const Duration(milliseconds: 400))
                      .then((value) {
                    scrollDown();
                  });
                },
                keyboardAppearance: Brightness.dark,
                maxLines: 7,
                controller: txtFieldController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Escribe un mensaje...",
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              color: backgroundTextField,
              child: IconButton(
                onPressed: () async {
                  if (txtFieldController.text == "Eliminar chat") {
                    setState(() {
                      txtFieldController.clear();
                      message.clear();
                    });
                  } else {
                    String input = "";
                    setState(() {
                      message.add(ChatModel(
                          text: txtFieldController.text,
                          messageType: ChatBotMessageType.user));
                      input = txtFieldController.text;
                      txtFieldController.clear();
                    });
                    Future.delayed(const Duration(milliseconds: 50))
                        .then((value) => scrollDown());

                    setState(() => waitResponse = true);
                    await serviceBot.getResponseBot(input).then((value) {
                      setState(() {
                        message.add(ChatModel(
                            text: value, messageType: ChatBotMessageType.bot));
                        waitResponse = false;
                      });
                    });
                    Future.delayed(const Duration(milliseconds: 50))
                        .then((value) => scrollDown());
                  }
                },
                icon: const Icon(Icons.send_rounded),
              ),
            )
          ],
        ),
      );

  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
