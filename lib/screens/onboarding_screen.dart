import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voicelung/screens/tasks_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String userName;

  const OnboardingScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _formKeys = List.generate(15, (index) => GlobalKey<FormState>());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables to store form data
  String consent = '';
  String gender = '';
  String ageRange = '';
  String height = '';
  String ethnicity = '';
  String qualification = '';
  String age = '';
  List<String> medicalConditions = [];
  String smokingStatus = '';
  String vapingStatus = '';
  List<String> symptoms = [];
  String inhaler = '';
  String steroid = '';
  String medicineList = '';

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _submit() async {
    try {
      String userName = widget.userName;

      // Save onboarding data to Firestore under `users/{userName}`
      await _firestore.collection('users').doc(userName).set({
        'consent': consent,
        'gender': gender,
        'ageRange': ageRange,
        'height': height,
        'ethnicity': ethnicity,
        'qualification': qualification,
        'age': age,
        'medicalConditions': medicalConditions,
        'smokingStatus': smokingStatus,
        'vapingStatus': vapingStatus,
        'symptoms': symptoms,
        'inhaler': inhaler,
        'steroid': steroid,
        'medicineList': medicineList,
        'isFirstLogin': false,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge with existing data if any
      // Navigate to the next screen or dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskPage()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildConsentStep(),
          _buildGenderStep(),
          _buildAgeRangeStep(),
          _buildHeightStep(),
          _buildEthnicityStep(),
          _buildQualificationStep(),
          _buildAgeStep(),
          _buildMedicalConditionsStep(),
          _buildSmokingStatusStep(),
          _buildVapingStatusStep(),
          _buildSymptomsStep(),
          _buildInhalerStep(),
          _buildSteroidStep(),
          _buildMedicineListStep(),
          _buildFinalStep(),
        ],
      ),
    );
  }

  Widget _buildConsentStep() {
    return _buildStep(
      step: 0,
      title: "Consent",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This app aims to collect data as part of a project LUNGVOAI which is looking at finding alternatives to traditional spirometry test.",
          ),
          SizedBox(height: 16.0),
          Text(
            "The app will collect basic demographics, medical history, some voice, breathing and cough samples. Note that you must be 16 years or older.",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            consent = 'accepted';
            _nextPage();
          },
          child: Text("Consent"),
        ),
      ],
    );
  }

  Widget _buildGenderStep() {
    return _buildStep(
      step: 1,
      title: "Which is your biological sex?",
      content: Column(
        children: [
          _buildRadioOption("Male", "Male", gender, (value) {
            setState(() {
              gender = value!;
            });
          }),
          _buildRadioOption("Female", "Female", gender, (value) {
            setState(() {
              gender = value!;
            });
          }),
          _buildRadioOption("Other", "Other", gender, (value) {
            setState(() {
              gender = value!;
            });
          }),
          _buildRadioOption("Prefer not to say", "Prefer not to say", gender, (value) {
            setState(() {
              gender = value!;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildAgeRangeStep() {
    return _buildStep(
      step: 2,
      title: "How old are you?",
      content: Column(
        children: [
          _buildRadioOption("18-25", "18-25", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("26-35", "26-35", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("36-45", "36-45", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("46-55", "46-55", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("56-65", "56-65", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("66-75", "66-75", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption("76-85", "76-85", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
          _buildRadioOption(">85", ">85", ageRange, (value) {
            setState(() {
              ageRange = value!;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }
  Widget _buildHeightStep() {
    return _buildStep(
      step: 3,
      title: "Please provide your height in cm.",
      content: TextFormField(
        onChanged: (value) => height = value!,
        decoration: InputDecoration(hintText: "Your height"),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildEthnicityStep() {
    return _buildStep(
      step: 4,
      title: "Which is your Ethnicity?",
      content:
      SingleChildScrollView(
        child: Column(
          children: [
            _buildRadioOption("White British", "White British", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Irish", "Irish", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Gypsy or Irish traveller", "Gypsy or Irish traveller", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Roma", "Roma", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Indian", "Indian", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Pakistani", "Pakistani", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Bangladeshi", "Bangladeshi", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Chinese", "Chinese", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Any other Asian background", "Any other Asian background", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Caribbean", "Caribbean", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("African", "African", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("Any other Black, Black British or Caribbean background", "Any other Black, Black British or Caribbean background", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("White and Black Caribbean", "White and Black Caribbean", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("White and Black African", "White and Black African", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
            _buildRadioOption("White and Asian", "White and Asian", ethnicity, (value) {
              setState(() {
                ethnicity = value!;
              });
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildQualificationStep() {
    return _buildStep(
      step: 5,
      title: "What is your highest qualification?",
      content: Column(
        children: [
          _buildRadioOption("None", "None", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
          _buildRadioOption("Primary", "Primary", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
          _buildRadioOption("Secondary", "Secondary", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
          _buildRadioOption("Bachelors Degree", "Bachelors Degree", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
          _buildRadioOption("Masters Degree", "Masters Degree", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
          _buildRadioOption("PhD", "PhD", qualification, (value) {
            setState(() {
              qualification = value!;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildAgeStep() {
    return _buildStep(
      step: 6,
      title: "Please provide the age at which you left/complete your Schooling/degree. If you are still studying mention your current degree.",
      content: TextFormField(
        onChanged: (value) => age = value!,
        decoration: InputDecoration(hintText: "Your age"),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildMedicalConditionsStep() {
    return _buildStep(
      step: 7,
      title: "Do you have any of these medical conditions? (can choose more than one)",
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildCheckboxOption("None"),
            _buildCheckboxOption("Prefer not to say"),
            _buildCheckboxOption("Asthma"),
            _buildCheckboxOption("Cystic fibrosis"),
            _buildCheckboxOption("COPD/emphysema"),
            _buildCheckboxOption("Pulmonary fibrosis"),
            _buildCheckboxOption("Other lung disease"),
            _buildCheckboxOption("High blood pressure"),
            _buildCheckboxOption("Angina"),
            _buildCheckboxOption("Previous stroke or Transient Ischaemic Attack"),
            _buildCheckboxOption("Previous heart attack"),
            _buildCheckboxOption("Valvular heart disease"),
            _buildCheckboxOption("Other heart disease"),
            _buildCheckboxOption("Diabetes"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildSmokingStatusStep() {
    return _buildStep(
      step: 8,
      title: "Do you, or have you ever smoked-cigarettes?",
      content: Column(
        children: [
          _buildRadioOption("Never smoked", "Never smoked", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
          _buildRadioOption("Prefer not to say", "Prefer not to say", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
          _buildRadioOption("Ex-smoker", "Ex-smoker", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
          _buildRadioOption("Current smoker (1-5 cigarettes per day)", "Current smoker (1-5 cigarettes per day)", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
          _buildRadioOption("Current smoker (6-10 cigarettes per day)", "Current smoker (6-10 cigarettes per day)", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
          _buildRadioOption("Current smoker (11 or more cigarettes per day)", "Current smoker (11 or more cigarettes per day)", smokingStatus, (value) {
            setState(() {
              smokingStatus = value!;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildVapingStatusStep() {
    return _buildStep(
      step: 9,
      title: "Do you, or have you ever vaped?",
      content: Column(
        children: [
          _buildRadioOption("Never vaped", "Never vaped", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
          _buildRadioOption("Prefer not to say", "Prefer not to say", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
          _buildRadioOption("Ex-Vaper smoker", "Ex-Vaper smoker", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
          _buildRadioOption("Current Vaper smoker (1-5 times per day)", "Current Vaper smoker (1-5 times per day)", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
          _buildRadioOption("Current Vaper smoker (6-10 times per day)", "Current Vaper smoker (6-10 times per day)", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
          _buildRadioOption("Current Vaper smoker (11 or more times per day)", "Current Vaper smoker (11 or more times per day)", vapingStatus, (value) {
            setState(() {
              vapingStatus = value!;
            });
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildSymptomsStep() {
    return _buildStep(
      step: 10,
      title: "Do you have any of the following symptoms? (can choose more than one)",
      content: Column(
        children: [
          _buildCheckboxOptionSymptom("None"),
          _buildCheckboxOptionSymptom("Prefer not to say"),
          _buildCheckboxOptionSymptom("Dry cough"),
          _buildCheckboxOptionSymptom("Wet cough"),
          _buildCheckboxOptionSymptom("Difficulty breathing or feeling short of breath"),
          _buildCheckboxOptionSymptom("Tightness in your chest"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildInhalerStep() {
    return _buildStep(
      step: 11,
      title: "Please name the inhaler(s) if you are using any. Otherwise fill None. Use , to separate items.",
      content: TextFormField(
        onChanged: (value) => inhaler = value!,
        decoration: InputDecoration(hintText: "Inhaler"),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }
  Widget _buildSteroidStep() {
    return _buildStep(
      step: 12,
      title: "Please name the steroid(s) if you are using any. Otherwise fill None. Use , to separate items.",
      content: TextFormField(
        onChanged: (value) => steroid = value!,
        decoration: InputDecoration(hintText: "Steroid"),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }
  Widget _buildMedicineListStep() {
    return _buildStep(
      step: 13,
      title: "Please name the medicine(s) you are taking to treat your respiratory problems if any. Otherwise fill None. Use , to separate items.",
      content: TextFormField(
        onChanged: (value) => medicineList = value!,
        decoration: InputDecoration(hintText: "Medicine Lists"),
      ),
      actions: [
        TextButton(
          onPressed: _nextPage,
          child: Text("Next"),
        ),
      ],
    );
  }

  Widget _buildFinalStep() {
    return _buildStep(
      step: 14,
      title: "Thank you! Your participation is extremely helpful to us. We will now initiate collecting data.",
      content: Container(),
      actions: [
        TextButton(
          onPressed: _submit,
          child: Text("Submit"),
        ),
      ],
    );
  }
  Widget _buildStep({
    required int step,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return Form(
      key: _formKeys[step],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: content,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (step > 0)
                  TextButton(
                    onPressed: _previousPage,
                    child: Text("Previous"),
                  ),
                Spacer(), // Add a spacer between the buttons
                ...actions,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label, String value, String groupValue, ValueChanged<String?> onChanged) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxOption(String label) {
    return CheckboxListTile(
      title: Text(label),
      value: medicalConditions.contains(label),
      onChanged: (bool? value) {
        setState(() {
          if (label == "Prefer not to say" && value == true) {
            medicalConditions.clear();
            medicalConditions.add(label);
          } else if (value == true) {
            medicalConditions.remove("Prefer not to say");
            medicalConditions.add(label);
          } else {
            medicalConditions.remove(label);
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
  Widget _buildCheckboxOptionSymptom(String label) {
    return CheckboxListTile(
      title: Text(label),
      value: symptoms.contains(label),
      onChanged: (bool? value) {
        setState(() {
          if (label == "Prefer not to say" && value == true) {
            symptoms.clear();
            symptoms.add(label);
          } else if (value == true) {
            symptoms.remove("Prefer not to say");
            symptoms.add(label);
          } else {
            symptoms.remove(label);
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}

