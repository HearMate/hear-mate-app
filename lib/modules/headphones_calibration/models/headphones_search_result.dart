import 'package:hear_mate_app/modules/headphones_calibration/models/ebay_item.dart';

class HeadphonesSearchResult {
  final List<EbayItem> items;
  final String extractedModel;

  HeadphonesSearchResult({required this.items, required this.extractedModel});

  static HeadphonesSearchResult get empty =>
      HeadphonesSearchResult(items: [], extractedModel: "");
}
