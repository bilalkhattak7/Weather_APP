import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_fyp/bloc/weather_bloc_bloc.dart';
import 'package:intl/intl.dart';

import 'package:weather_fyp/screens//sign_up_page.dart';
import 'package:weather_fyp/screens/users_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showAuthOptions = false;


  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset("assets/1.png");
      case >= 300 && < 400:
        return Image.asset("assets/2.png");
      case >= 500 && < 600:
        return Image.asset("assets/3.png");
      case >= 600 && < 700:
        return Image.asset("assets/4.png");
      case >= 700 && < 800:
        return Image.asset("assets/5.png");
      case == 800:
        return Image.asset("assets/6.png");
      case > 800 && <= 804:
        return Image.asset("assets/7.png");
      default:
        return Image.asset("assets/7.png");
    }
  }
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Widget _buildAuthButton(String text, VoidCallback onPressed) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          // Weather content
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // Background elements
                  Align(
                    alignment: const AlignmentDirectional(3, -0.3),
                    child: Container(
                      height: 300, width: 300,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-3, -0.3),
                    child: Container(
                      height: 300, width: 300,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, -1.2),
                    child: Container(
                      height: 300, width: 600,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.transparent
                      ),
                    ),
                  ),

                  // Weather data
                  BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                    builder: (context, state) {
                      if (state is WeatherBlocSuccess) {
                        return _buildWeatherContent(state);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Settings and Users buttons
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showAuthOptions) ...[
                  _buildAuthButton('Sign Up', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                    setState(() => _showAuthOptions = false);
                  }),
                  // const SizedBox(height: 8),
                  // _buildAuthButton('Sign In', () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => const SignUpPage()),
                  //   );
                  //   setState(() => _showAuthOptions = false);
                  // }),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    setState(() => _showAuthOptions = !_showAuthOptions);
                  },
                  child: const Icon(Icons.settings),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),

          // Users list button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersListScreen()),
                );
              },
              child: const Icon(Icons.people),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(WeatherBlocSuccess state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📍 ${state.weather.areaName}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(_getGreeting(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          getWeatherIcon(state.weather.weatherConditionCode!),
          Center(
            child: Text("${state.weather.temperature!.celsius!.round()}°C",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 55,
              ),
            ),
          ),
          Center(
            child: Text(
              state.weather.weatherMain!.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              DateFormat("EE, dd").add_jm().format(state.weather.date!),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildWeatherDetails(state),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherBlocSuccess state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfo(
              icon: "assets/11.png",
              label: "Sunrise",
              value: DateFormat().add_jm().format(state.weather.sunrise!),
            ),
            _buildWeatherInfo(
              icon: "assets/12.png",
              label: "Sunset",
              value: DateFormat().add_jm().format(state.weather.sunset!),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Divider(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherInfo(
              icon: "assets/13.png",
              label: "Temp Max",
              value: "40 °C",
            ),
            _buildWeatherInfo(
              icon: "assets/14.png",
              label: "Temp Min",
              value: "${state.weather.tempMin!.celsius!.round()} °C",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherInfo({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Image.asset(icon, scale: 8),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
            Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

