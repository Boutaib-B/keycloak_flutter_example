import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

class KeycloakLogin {
  String host;
  String realm;
  String clientId;
  List<String> scopes;
  Widget Function(VoidCallback)? onBeforeLogin;
  Widget Function(Credential?) onSuccess;
  Credential? credential;

  KeycloakLogin({
    required this.host,
    required this.realm,
    required this.clientId,
    required this.scopes,
    this.onBeforeLogin,
    required this.onSuccess,
  });

  Future<void> login(BuildContext context) async {
    try {
      var issuer = await Issuer.discover(Uri.parse('$host/auth/realms/$realm'));
      var client = Client(issuer, clientId);

      var authenticator = Authenticator(
        client,
        scopes: scopes,
        port: 4000, // Specify the port for the local web server used during authentication
      );

      print("test");
      // Launch the browser and wait for the authentication to complete
      authenticator.authorize().then((result) {
        this.credential = result;

        if (onBeforeLogin != null) {
          // Optionally handle any pre-login UI changes
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => onBeforeLogin!(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => onSuccess(credential)),
              );
            })),
          );
        } else {
          // Navigate to the success page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => onSuccess(credential)),
          );
        }
      }).catchError((e) {
        // Handle errors in case of failed login attempt
        print('Login error: $e');
      });
    } catch (e) {
      // Handle exceptions such as discovery document retrieval failure
      print('Login error: $e');
    }
  }
}
