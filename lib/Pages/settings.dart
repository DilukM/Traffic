import 'package:audioplayers/audioplayers.dart';
import 'package:color_detector/util/radioButton.dart';
import 'package:color_detector/util/settingsButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  late String _customAlarmPath;
  bool selected = false;
  late String selectedOption = "alarm.mp3";
  late String _value = "alarm.mp3";
  final player = AudioPlayer();
  bool soundOn = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Retrieve custom alarm path from SharedPreferences
      _customAlarmPath = _prefs.getString('customAlarmPath') ?? '';
      _value = _prefs.getString('selectedOption') ?? '';
      selectedOption = _prefs.getString('selectedOption') ?? '';

      selected = _customAlarmPath.isEmpty ? true : false;
      _loadSelectedOption();

      if (_value.isEmpty) {
        _setAlarmTone("alarm.mp3");
      }
    });
  }

  _loadSelectedOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = prefs.getString('selectedOption') ?? '';
    });
  }

  _saveSelectedOption(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedOption', value);
    setState(() {
      selectedOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        currentIndex: 1, // Set current index according to the selected page
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .animate(animation),
                    child: child,
                  );
                },
              ),
            );
          } else if (index == 1) {
            return null;
          }
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  soundOn = !soundOn;
                });
              },
              icon: soundOn
                  ? Icon(
                      Icons.notifications_off,
                      color: Color(0xff52b5b5),
                    )
                  : Icon(
                      Icons.notifications_on,
                      color: Color(0xff52b5b5),
                    ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm.mp3");
              },
              child: RadioButton(
                Title: "Default",
                selected: selected,
                color1: _value == "alarm.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm1.mp3");
              },
              child: RadioButton(
                Title: "Alarm 1",
                selected: selected,
                color1: _value == "alarm1.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm1.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm2.mp3");
              },
              child: RadioButton(
                Title: "Alarm 2",
                selected: selected,
                color1: _value == "alarm2.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm2.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm3.mp3");
              },
              child: RadioButton(
                Title: "Alarm 3",
                selected: selected,
                color1: _value == "alarm3.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm3.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm4.mp3");
              },
              child: RadioButton(
                Title: "Alarm 4",
                selected: selected,
                color1: _value == "alarm4.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm4.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            GestureDetector(
              onTap: () {
                _setAlarmTone("alarm5.mp3");
              },
              child: RadioButton(
                Title: "Alarm 5",
                selected: selected,
                color1: _value == "alarm5.mp3"
                    ? const Color(0xff52b5b5)
                    : Color.fromARGB(255, 186, 186, 186),
                color2: _value == "alarm5.mp3"
                    ? const Color(0xff20dcdc)
                    : Color.fromARGB(255, 233, 233, 233),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.grey[200],
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectFromDevice();
              },
              child: SettingsButton(
                Title: "Set custom alarm tone",
                selected: selected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDevice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          _customAlarmPath = filePath;
          selected = false;
          _value = "100";
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customAlarmPath', _customAlarmPath);
      }
    }
  }

  Future<void> _setDefaultAlarmTone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('customAlarmPath'); // Remove custom alarm tone
    setState(() {
      selected = true;
    });
  }

  Future<void> _setAlarmTone(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('customAlarmPath'); // Remove custom alarm tone
    setState(() {
      selected = true;
      _value = value;
      selectedOption = value;
    });
    await prefs.setString('selectedOption', value);
    if (soundOn) {
      player.play(AssetSource(selectedOption));
    }
  }
}
