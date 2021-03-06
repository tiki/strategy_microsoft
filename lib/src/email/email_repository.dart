/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:httpp/httpp.dart';
import 'package:logging/logging.dart';

class EmailRepository {
  final Logger _log = Logger('EmailRepository');

  static const String _pathProfile =
      "https://graph.microsoft.com/v1.0/me/messages";

  static const String _pathMessages =
      "https://graph.microsoft.com/v1.0/me/messages";

  static const String _pathSend =
      "https://graph.microsoft.com/v1.0/me/sendMail";

  Future<void> pathProfile(
      {required HttppClient client,
        String? accessToken,
        String? filter,
        void Function(HttppResponse)? onSuccess,
        required void Function(HttppResponse) onResult,
        void Function(Object)? onError}) {
    String queryParams = filter != null ? "?$filter&\$count=true" : "?\$count=true";
    HttppRequest request = HttppRequest(
        uri: Uri.parse(_pathProfile + queryParams),
        verb: HttppVerb.GET,
        headers: HttppHeaders.typical(bearerToken: accessToken),
        timeout: const Duration(seconds: 30),
        onSuccess: onSuccess,
        onResult: onResult,
        onError: onError);
    _log.finest('${request.verb.value} — ${request.uri}');
    return client.request(request);
  }

  Future<void> message(
      {required HttppClient client,
      String? accessToken,
      required String messageId,
      void Function(HttppResponse)? onSuccess,
      required void Function(HttppResponse) onResult,
      void Function(Object)? onError}) async {
    HttppRequest request = HttppRequest(
        uri: Uri.parse(_pathMessages +
            '/$messageId?\$select=internetMessageHeaders,from,receivedDateTime,toRecipients'),
        verb: HttppVerb.GET,
        headers: HttppHeaders.typical(bearerToken: accessToken),
        timeout: const Duration(seconds: 30),
        onSuccess: onSuccess,
        onResult: onResult,
        onError: onError);
    _log.finest('${request.verb.value} — ${request.uri}');
    return client.request(request);
  }

  Future<void> send(
      {required HttppClient client,
      String? accessToken,
      required HttppBody message,
      void Function(HttppResponse)? onSuccess,
      required void Function(HttppResponse) onResult,
      void Function(Object)? onError}) async {
    HttppRequest request = HttppRequest(
        uri: Uri.parse(_pathSend),
        verb: HttppVerb.POST,
        headers: HttppHeaders.typical(bearerToken: accessToken),
        timeout: const Duration(seconds: 30),
        body: message,
        onSuccess: onSuccess,
        onResult: onResult,
        onError: onError);
    _log.finest('${request.verb.value} — ${request.uri}');
    return client.request(request);
  }

  Future<void> messageId(
      {required HttppClient client,
      String? accessToken,
      String? filter,
      void Function(HttppResponse)? onSuccess,
      required void Function(HttppResponse) onResult,
      void Function(Object)? onError}) {
    String queryParams = "?\$select=id";
    if (filter != null) queryParams += "&\$filter=$filter";
    HttppRequest request = HttppRequest(
        uri: Uri.parse(_pathMessages + queryParams),
        verb: HttppVerb.GET,
        headers: HttppHeaders.typical(bearerToken: accessToken),
        timeout: const Duration(seconds: 30),
        onSuccess: onSuccess,
        onResult: onResult,
        onError: onError);
    _log.finest('${request.verb.value} — ${request.uri}');
    return client.request(request);
  }
}
