import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/custom.dart';

class ConsultPage extends StatefulWidget {
  ConsultPage({super.key});

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController resingBPController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController fastingController = TextEditingController();
  final TextEditingController resingECGController = TextEditingController();
  final TextEditingController heartrateController = TextEditingController();
  final TextEditingController exerciseController = TextEditingController();
  final TextEditingController stController = TextEditingController();
  final TextEditingController oldpeakController = TextEditingController();
  String? _patientDocumentId;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
  }

  Future<void> saveConsultationDetails() async {
    if (_patientDocumentId == null) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Patient not found, cannot update booking details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(_patientDocumentId)
          .update({
        'consultation': FieldValue.arrayUnion([
          {
            'age': ageController.text,
            'sex': genderController.text,
            'restingBpS': resingBPController.text,
            'cholesterol': cholesterolController.text,
            'chestPainType': chestController.text,
            'fastingBloodSugar': fastingController.text,
            'restingEcg': resingECGController.text,
            'maxHeartRate': heartrateController.text,
            'exerciseAngina': exerciseController.text,
            'STSlope': stController.text,
            'oldpeak': oldpeakController.text,
            'Dateofconsultation': Timestamp.now(),
          }
        ])
      });
    }
    // try {
    //   await patientDocument!.update({
    //     'consultations': FieldValue.arrayUnion([
    //       {
    //         'age': ageController.text,
    //         'sex': genderController.text,
    //         'restingBpS': resingBPController.text,
    //         'cholesterol': cholesterolController.text,
    //         'chestPainType': chestController.text,
    //         'fastingBloodSugar': fastingController.text,
    //         'restingEcg': resingECGController.text,
    //         'maxHeartRate': heartrateController.text,
    //         'exerciseAngina': exerciseController.text,
    //         'STSlope': stController.text,
    //         'oldpeak': oldpeakController.text,
    //         'Dateofconsultation': Timestamp.now(),
    //       }
    //     ])
    //   });
    //   AwesomeDialog(
    //     context: context,
    //     animType: AnimType.scale,
    //     dialogType: DialogType.success,
    //     body: const Center(
    //       child: Text(
    //         'Consultation details saved successfully',
    //         style: TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //     title: 'Success',
    //     desc: 'Consultation details added to patient record',
    //     btnOkColor: Colors.deepPurple,
    //     btnOkOnPress: () {},
    //   ).show();
    // }
    catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Error while saving consultation details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'Error',
        desc: 'Could not save consultation details',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
    }
  }
  // else {
  //   AwesomeDialog(
  //     context: context,
  //     animType: AnimType.scale,
  //     dialogType: DialogType.error,
  //     body: const Center(
  //       child: Text(
  //         'No patient selected',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //     title: 'Error',
  //     desc: 'Please enter a valid auth code to select a patient',
  //     btnOkColor: Colors.deepPurple,
  //     btnOkOnPress: () {},
  //   ).show();
  // }

  // Future<void> SavePredition() async {
  //   CollectionReference predictions =
  //       FirebaseFirestore.instance.collection('predictions');

  //   try {
  //     await predictions.add({
  //       'age': ageController.text,
  //       'sex': genderController.text,
  //       'restingBpS': resingBPController.text,
  //       'cholesterol': cholesterolController.text,
  //       'chestPainType': chestController.text,
  //       'fastingBloodSugar': fastingController.text,
  //       'restingEcg': resingECGController.text,
  //       'maxHeartRate': heartrateController.text,
  //       'exerciseAngina': exerciseController.text,
  //       'STSlope': stController.text,
  //       'oldpeak': oldpeakController.text,
  //       'Dateofconsultation': Timestamp.now(),
  //     });
  //   } catch (e) {
  //     SnackBar(
  //       backgroundColor: Colors.green,
  //       content: Text(
  //         "",
  //         style: TextStyle(fontSize: 20, color: Colors.white),
  //       ),
  //     );
  //   }
  // }

  Future<void> submitRequest() async {
    bool validateFields() {
      return ageController.text.isNotEmpty &&
          genderController.text.isNotEmpty &&
          fullnameController.text.isNotEmpty &&
          authController.text.isNotEmpty &&
          resingBPController.text.isNotEmpty &&
          cholesterolController.text.isNotEmpty &&
          chestController.text.isNotEmpty &&
          fastingController.text.isNotEmpty &&
          resingECGController.text.isNotEmpty &&
          heartrateController.text.isNotEmpty &&
          exerciseController.text.isNotEmpty &&
          stController.text.isNotEmpty &&
          oldpeakController.text.isNotEmpty;
    }

    if (!validateFields()) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Missing fields',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'ERROR',
        desc: 'Please fill all the fields',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
    } else {
      var url = 'http://192.168.158.253:3004/predict';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'age': ageController.text,
          'sex': genderController.text,
          'restingBpS': resingBPController.text,
          'cholesterol': cholesterolController.text,
          'chestPainType': chestController.text,
          'fastingBloodSugar': fastingController.text.toString(),
          'restingEcg': resingECGController.text,
          'maxHeartRate': heartrateController.text,
          'exerciseAngina': exerciseController.text,
          'STSlope': stController.text,
          'oldpeak': oldpeakController.text.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData); // Print or process the response data

        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          body: Center(
            child: Text(
              '$responseData',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: 'Success',
          desc:
              'Prediction successful and Booking details added to patient successfully!',
          btnOkColor: Colors.deepPurple,
          btnOkOnPress: () {
            saveConsultationDetails();
            clearFields();
          },
        ).show();
      } else {
        print('Request failed with status: ${response.statusCode}'.toString());
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          body: Center(
            child: Text(
              "Request failed with status: ${response.statusCode}".toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: 'Error',
          desc: 'Prediction request failed',
          btnOkColor: Colors.deepPurple,
          btnOkOnPress: () {
            clearFields();
          },
        ).show();
      }
    }
  }

  Timer? _debounce;
String? _lastFetchedCode;

  void _onAuthCodeChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      if (value != _lastFetchedCode) {
        _lastFetchedCode = value;
        fetchPatientDetails(value); // Fetch details after delay
      }
    });
  }


  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void fetchPatientDetails(String authCode) async {
    try {
      // Query Firestore to get the patient details based on the auth code
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('code', isEqualTo: authCode)
          .get();

      // Check if any matching patient record found
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the auth codes
        var patientData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Store the document ID
        _patientDocumentId = querySnapshot.docs.first.id;

        // Update respective text form field controllers with patient details
        setState(() {
          String firstName = patientData['firstName'] ?? '';
          String lastName = patientData['lastName'] ?? '';
          fullnameController.text = '$firstName $lastName';
        });
      } else {
        // Clear text form field controllers if no matching patient record found
        // clearFields();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Error while fetching patient details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
      // Handle errors, such as Firestore query failures
      // print("Error fetching patient details: $e");
    }
  }

  void clearFields() {
    ageController.clear();
    fullnameController.clear();
    authController.clear();
    genderController.clear();
    resingBPController.clear();
    cholesterolController.clear();
    chestController.clear();
    fastingController.clear();
    resingECGController.clear();
    heartrateController.clear();
    exerciseController.clear();
    stController.clear();
    oldpeakController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
                      left: 10),
                  child: CustomText(
                    text: menuControllers.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auth Number',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: authController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Auth Code",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          _onAuthCodeChanged(
                              value); // Fetch details when code changes
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Full Name',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        readOnly: true,
                        controller: fullnameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Full Name ",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Age',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Age",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Gender',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: genderController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Gender",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Chest Pain type',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: chestController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Chest pain type",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Resting Blood pressure',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: resingBPController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Blood pressure in mm/Hg",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Cholesterol',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: cholesterolController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Cholesterol level in mg/dl",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Fasting blood sugar',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: fastingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Fasting blood sugar",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Resting Electrocardiographic',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: resingECGController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Resting ECG",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Max heart rate',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: heartrateController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Max heart rate",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Exercise Angina ',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: exerciseController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Exercise induced angina",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Old Peak',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: oldpeakController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old peak",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ST slope',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        controller: stController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "ST segment",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      submitRequest();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple),
                      child: const Center(
                        child: Text(
                          'Check',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  // const Text(
                  //   ' ',
                  //   style: TextStyle(fontSize: 25),
                  // ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
