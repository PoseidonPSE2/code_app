import 'package:flutter/material.dart';
import 'package:refill/model/refillstation.dart';
import 'package:refill/provider/refillstation_provider.dart';
import 'package:refill/provider/user_provider.dart';
import 'package:refill/restApi/apiService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';

class Waterstationreview extends StatefulWidget {
  final RefillStation station;

  const Waterstationreview({super.key, required this.station});

  @override
  State<Waterstationreview> createState() => _WaterstationreviewState();
}

class _WaterstationreviewState extends State<Waterstationreview> {
  User? currentUser;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentUser = Provider.of<UserProvider>(context, listen: false).user;
      _fetchUser();
    });
  }

  void _fetchUser() {
    if (currentUser != null) {
      _fetchUserRatings();
    }
  }

  Future<void> _fetchUserRatings() async {
    try {
      final provider =
          Provider.of<RefillStationProvider>(context, listen: false);
      await provider.fetchReview(currentUser!.userId, widget.station.id);
    } catch (error) {
      print('Fehler beim Laden der Bewertungen: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasserstation Details'),
      ),
      body: Consumer<RefillStationProvider>(
        builder: (context, provider, child) {
          if (provider.review == null) {
            return const Center(child: CircularProgressIndicator());
          }

          double cleanlinessRating = provider.review!.cleanness.toDouble();
          double accessibilityRating =
              provider.review!.accessibility.toDouble();
          double waterQualityRating = provider.review!.water_quality.toDouble();

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sauberkeit',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: cleanlinessRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      cleanlinessRating = rating;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Erreichbarkeit',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: accessibilityRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      accessibilityRating = rating;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Wasserqualität',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: waterQualityRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      waterQualityRating = rating;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            setState(() {
                              _isSubmitting = true;
                            });

                            RefillstationReview review = RefillstationReview(
                              cleanness: cleanlinessRating.toInt(),
                              accessibility: accessibilityRating.toInt(),
                              water_quality: waterQualityRating.toInt(),
                              station_id: widget.station.id,
                              user_id: currentUser?.userId,
                            );

                            try {
                              ApiService().postRefillstationReview(review);

                              await provider.fetchReview(
                                  currentUser!.userId, widget.station.id);
                              await provider
                                  .fetchReviewAverage(widget.station.id);
                              setState(() {});
                              Navigator.pop(context);
                            } catch (error) {
                              print(
                                  'Fehler beim Absenden der Bewertung: $error');
                            } finally {
                              setState(() {
                                _isSubmitting = false;
                              });
                            }
                          },
                    child: _isSubmitting
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Bewertung senden'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
