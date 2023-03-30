import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServiceChatBot {
  Future<String> getResponseBot(String text) async {
    final apiKey = dotenv.env["api_chat_bot"];

    var url = Uri.https("api.openai.com", "/v1/completions");

    final petition = await http.post(url,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": text,
          "temperature": 0,
          "max_tokens": 2000,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
        }));

    if (petition.statusCode > 199 && petition.statusCode < 300) {
      final decode = jsonDecode(utf8.decode(petition.bodyBytes));

      return decode["choices"][0]["text"];
    } else {
      return "No pude procesar tu solicitud, intenta con algo más.";
    }
  }
}
