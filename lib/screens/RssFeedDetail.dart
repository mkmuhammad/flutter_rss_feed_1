import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rss_feed_1/screens/FirstScreen.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class RssFeedDetail extends StatefulWidget {
  final Map<String, dynamic> rssFeed;

  const RssFeedDetail({Key? key, required this.rssFeed}) : super(key: key);

  @override
  State<RssFeedDetail> createState() => _RssFeedDetailState();
}

class _RssFeedDetailState extends State<RssFeedDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FirstScreen(title: ''))),
        ),
        title: Text(widget.rssFeed['title']),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                color: Colors.black12,
                child: Image(
                  image: CachedNetworkImageProvider(
                    widget.rssFeed['image'],
                    errorListener: () => detailImageLoadedError(),
                  ),
                  errorBuilder: (_, __, ___) => detailImageLoadedError(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.rssFeed['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(Ionicons.time_outline),
                    Text(
                      DateFormat('MMM dd').format(
                        DateTime.parse(
                          widget.rssFeed['pubDate'].toString(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Ionicons.person_outline),
                    Text(widget.rssFeed['author'])
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () => launchUrl(Uri.parse(widget.rssFeed['link'])),
                  icon: const Icon(Ionicons.link),
                  label: const Text('Visit link'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Html(
                data: widget.rssFeed['content'],
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget detailImageLoadedError() {
  return SizedBox(
    height: 300,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.black,
        ),
        SizedBox(height: 15.0,),
        Text('Error Loading Image')
      ],
    ),
  );
}
