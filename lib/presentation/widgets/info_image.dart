import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/commons/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageInfoDetail extends StatefulWidget {
  String urlData;
  String? photographerData;
  String? photographerURL;
  String? widthImageData;
  int? heightImageData;
  String? avg_colorData;
  ImageInfoDetail(
      {super.key,
      required this.urlData,
      this.photographerData,
      this.photographerURL,
      this.widthImageData,
      this.heightImageData,
      this.avg_colorData});

  @override
  State<ImageInfoDetail> createState() => _ImageInfoDetailState();
}

class _ImageInfoDetailState extends State<ImageInfoDetail> {

  // Ir a la url del fotografo
  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: buttonsBar,
            child: Text(widget.photographerData.toString().substring(0, 1)),
          ),
          title: Text(
            widget.photographerData.toString(),
            style: contentStyle,
          ),
          subtitle: Text(
            widget.widthImageData.toString() +
                'x' +
                widget.heightImageData.toString(),
            style: subtitleStyle,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _launchInWebViewOrVC(Uri.parse(widget.photographerURL.toString()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: buttonsBar,
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Perfil público',
                    style: buttonProfileFotographer,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: HexColor(widget.avg_colorData.toString()),
                    borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.avg_colorData.toString()}',
                    style: buttonProfileFotographer),
              ),
            ],
          ),
        )
      ],
    );
  }
}
