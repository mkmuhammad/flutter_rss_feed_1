import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_feed_1/screens/RssFeedDetail.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:webfeed/domain/rss_feed.dart';

class FirstScreen extends StatefulWidget {
  final String title;

  const FirstScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  /*static BannerAd myBanner = BannerAd(
    adUnitId: InterstitialAd.testAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );*/

  bool isAdVisible = true;
  bool isLoading = false;
  late RssFeed rss = RssFeed();

  loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      const API = 'https://adeptosdebancada.com/rssfeed?content=articles';
      final response = await get(Uri.parse(API));
      var channel = RssFeed.parse(response.body);

      setState(() {
        rss = channel;
        isLoading = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Adeptos Rss Feed 1',style: TextStyle(fontSize: 15.0),),
        actions: [
          ElevatedButton(
            onPressed: () => loadData(),
            child: Row(
              children: const <Widget>[
                Icon(Ionicons.refresh_circle),
                SizedBox(width: 5.0,),
                Text('Refresh')
              ],
            ),
          )
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoading == false
              ? ListView.builder(
                  itemCount: rss.items!.length,
                  itemBuilder: (BuildContext context, index) {
                    final item = rss.items![index];
                    final feedItems = {
                      'title': item.title,
                      'content': item.content!.value,
                      'creator': item.dc!.creator,
                      'image': item.media!.contents![0].url,
                      'link': item.link,
                      'pubDate': item.pubDate,
                      'author': item.dc!.creator
                    };
                    return InkWell(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RssFeedDetail(rssFeed: feedItems),
                        ),
                      ),
                      child: ListTile(
                        leading: Image(
                          image: CachedNetworkImageProvider(
                              item.media!.contents![0].url.toString()),
                        ),
                        title: Text(item.title.toString()),
                        subtitle: Row(
                          children: <Widget>[
                            const Icon(Ionicons.time_outline),
                            Text(DateFormat('MMM dd').format(
                                DateTime.parse(item.pubDate.toString()))),
                            const Spacer(),
                            const Icon(Ionicons.person_outline),
                            Text(item.dc!.creator.toString()),
                          ],
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
