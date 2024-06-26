import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refill/model/refillstation.dart';
import 'package:refill/model/user.dart';
import 'package:refill/provider/refillstation_provider.dart';
import 'package:refill/provider/user_provider.dart';
import 'package:refill/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../restApi/waterEnums.dart';
import 'WaterstationReport.dart';
import 'WaterstationReview.dart';

class Waterstationdetails extends StatefulWidget {
  final RefillStationMarker marker;

  const Waterstationdetails({super.key, required this.marker});

  @override
  State<Waterstationdetails> createState() => WaterstationdetailsState();
}

class WaterstationdetailsState extends State<Waterstationdetails> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = Provider.of<UserProvider>(context, listen: false).user;
  }

  Future<void> navigateToReviewPage(
      BuildContext context, RefillStation marker) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Waterstationreview(station: marker),
      ),
    );
    await Provider.of<RefillStationProvider>(context, listen: false)
        .fetchReviewAverage(marker.id);
    await Provider.of<RefillStationProvider>(context, listen: false)
        .fetchReview(currentUser!.userId, marker.id);
    setState(() {});
  }

  void navigateToReportPage(BuildContext context, RefillStation marker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Waterstationreport(station: marker),
      ),
    );
  }

  static String formatAddressWithLineBreak(String address) {
    List<String> addressParts = address.split(', ');

    String formattedAddress = "${addressParts[0]},\n${addressParts[1]}";
    return formattedAddress;
  }

  List<Widget> generateStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      double filledStarRatio = (rating - i) >= 0 ? 1 : rating - i;
      Icon starIcon;
      if (filledStarRatio >= 0.5) {
        starIcon = Icon(
          Icons.star,
          color: Colors.yellow[700],
          size: 20.0,
        );
      } else if (filledStarRatio > 0) {
        starIcon = Icon(
          Icons.star_half,
          color: Colors.yellow[700],
          size: 20.0,
        );
      } else {
        starIcon = Icon(
          Icons.star_border,
          color: Colors.grey[500],
          size: 20.0,
        );
      }
      stars.add(starIcon);
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasserstation'),
        actions: [
          Consumer<RefillStationProvider>(
            builder: (context, provider, child) {
              return TextButton(
                onPressed: () {
                  if (provider.selectedStation != null) {
                    navigateToReportPage(context, provider.selectedStation!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Problem melden',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(decoration: TextDecoration.underline),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<RefillStationProvider>(
        builder: (context, provider, child) {
          if (provider.selectedStation == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: provider.imageBase64?.image != null &&
                                    provider.imageBase64!.image!.isNotEmpty
                                ? DecorationImage(
                                    image: MemoryImage(base64Decode(
                                        provider.imageBase64!.image!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: provider.imageBase64?.image == null ||
                                  provider.imageBase64!.image!.isEmpty
                              ? const LoadingScreen()
                              : null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              provider.selectedStation!.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ),
                                          Text(
                                            provider.likes.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              provider.toggleLike(
                                                  widget.marker.id,
                                                  currentUser!.userId);
                                            },
                                            icon: Icon(
                                              provider.isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: provider.isLiked
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_sharp,
                                            size: 22.0,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            formatAddressWithLineBreak(provider
                                                .selectedStation!.address),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              height: 20,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      provider.reviewAverage!.cleanness
                                          .toStringAsFixed(1)
                                          .toString(),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.star,
                                    ),
                                  ],
                                ),
                                const Text(
                                  ' · ',
                                ),
                                Row(
                                  children: [
                                    Text(
                                      provider.reviewAverage!.accesibility
                                          .toStringAsFixed(1)
                                          .toString(),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.star,
                                    ),
                                  ],
                                ),
                                const Text(
                                  ' · ',
                                ),
                                Row(
                                  children: [
                                    Text(
                                      provider.reviewAverage!.waterQuality
                                          .toStringAsFixed(1)
                                          .toString(),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.star,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sauberkeit",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Erreichbarkeit",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Wasser Qualität",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                          color: Colors.grey,
                        ),
                        Text(
                          provider.selectedStation!.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 22.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              offeredWaterTypeToString(
                                  provider.selectedStation!.offeredWatertype),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.glassWaterDroplet,
                              size: 22.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              waterStationTypeToString(
                                  provider.selectedStation!.type),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.water_rounded,
                              size: 22.0,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              provider.selectedStation!.waterSource,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 15, right: 15, bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      navigateToReviewPage(context, provider.selectedStation!);
                    },
                    child: const Text('Bewerten'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
