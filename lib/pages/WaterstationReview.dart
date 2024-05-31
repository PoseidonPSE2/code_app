import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets.dart/reviewSlider.dart';
import 'navbar/map.dart';


class Waterstationreview extends StatelessWidget {
  const Waterstationreview({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wasserstation Details'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sauberkeit',
                  style: Theme.of(context).textTheme.labelLarge
                ),
                const Reviewslider(initialValue: 3.5),
                Text(
                    'Barrierefreiheit',
                    style: Theme.of(context).textTheme.labelLarge
                ),
                const Reviewslider(initialValue: 3.5),
                Text(
                    'Wasserqualität',
                    style: Theme.of(context).textTheme.labelLarge
                ),
                const Reviewslider(initialValue: 3.5),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child:
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Absenden',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),

              ]),
        ));
  }
}