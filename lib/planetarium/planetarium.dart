import 'package:flutter/material.dart';
import 'package:astroquest/globals.dart';
import 'package:astroquest/results/resvar.dart';

class Planetarium extends StatefulWidget {
  const Planetarium({super.key});

  @override
  State<Planetarium> createState() => _PlanetariumState();
}

class _PlanetariumState extends State<Planetarium> {
  PageController pageController = PageController();

  void selectPlanet(String planet) async {
    List<Map> list =
        await db.query('planets', where: 'name = ?', whereArgs: [planet]);

    resHead = planet;
    resImgPath = 'assets/${planet}SS.jpg';

    Map data = list[0];

    String complbl = 'Atmospheric';
    if (planet == 'Moon' || planet == 'Mercury') complbl = 'Elemental';

    String distlbl = 'Sun';
    String perlbl = 'Perihelion';
    String aplbl = 'Aphelion';
    if (planet == 'Moon') {
      distlbl = 'Earth';
      perlbl = 'Perigee';
      aplbl = 'Apogee';
    }

    String dataString = """
      ${data['desc']}\n
      Mass: ${data['mass']} x 10^24 kg
      Diameter: ${data['diameter']} km
      Avg. Density: ${data['density']} kg/m^3\n
      Surf. Gravity: ${data['gravity']} m/s^2
      Escape Velocity: ${data['escvel']} km/s\n
      Surf. Pressure: ${data['press']} atm
      Mean Temperature: ${data['temp']} °C\n
      Rotation Period: ${data['rotper']} hours
      Length of Day: ${data['day']} hours
      Axial Tilt: ${data['axialtilt']} degrees\n
      Orbital Period: ${data['orbper']} days
      Orbital Velocity: ${data['orbvel']} km/s
      Orbital Inclination: ${data['orbinc']} degrees
      Orbital Eccentricity: ${data['orbecc']}\n
      Distance ($distlbl): ${data['dist']} x 10^6 km
      $perlbl: ${data['perhel']} x 10^6 km
      $aplbl: ${data['aphel']} x 10^6 km\n
      Ring System: ${data['ring']}
      Number of Moons: ${data['moons']}\n
      Global Magnetic Field: ${data['magfield']}\n
      $complbl Composition:\n${data['comp']}\n
      """;

    resBody = dataString;
    if (mounted) Navigator.pushNamed(context, '/result');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<String> topics = [
      'Mercury',
      'Venus',
      'Earth',
      'Moon',
      'Mars',
      'Jupiter',
      'Saturn',
      'Uranus',
      'Neptune',
    ];

    Center imgButton(String text, String image) {
      return Center(
        child: GestureDetector(
            onTap: () {
              selectPlanet(text);
            },
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: txtColor,
                  width: 1,
                ),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    const Icon(
                      Icons.arrow_forward,
                      size: 27,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )),
      );
    }

    Container plPage(int page) {
      return Container(
        decoration: background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar('Planetarium'),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              imgButton(topics[3 * page], "assets/${topics[3 * page]}.jpg"),
              imgButton(
                  topics[3 * page + 1], "assets/${topics[3 * page + 1]}.jpg"),
              imgButton(
                  topics[3 * page + 2], "assets/${topics[3 * page + 2]}.jpg"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    style: pageBtnStyle,
                    iconSize: 30,
                    onPressed: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Text(
                    'Page ${page + 1}',
                    style: const TextStyle(fontSize: 20, color: txtColor),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                    ),
                    style: pageBtnStyle,
                    iconSize: 30,
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      children: <Widget>[
        plPage(0),
        plPage(1),
        plPage(2),
      ],
    );
  }
}
