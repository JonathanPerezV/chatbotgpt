import 'package:chat_bot_project/utils/colors_chat.dart';
import 'package:flutter/material.dart';

import '../model/chat_bot_model.dart';

class WidgetMessage extends StatelessWidget {
  final String text;
  final ChatBotMessageType type;
  const WidgetMessage({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      alignment: type == ChatBotMessageType.bot
          ? Alignment.centerLeft
          : Alignment.centerRight,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: type == ChatBotMessageType.bot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (type == ChatBotMessageType.bot)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.abc,
                size: 35,
              ),
            ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: type == ChatBotMessageType.bot ? 5.0 : 65.0,
                  right: type == ChatBotMessageType.user ? 5.0 : 65.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: type == ChatBotMessageType.bot
                      ? backgroundMessageBot
                      : backgroundMessageUser,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (type == ChatBotMessageType.user)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.person,
                size: 35,
              ),
            )
        ],
      ),
    );
  }
}
