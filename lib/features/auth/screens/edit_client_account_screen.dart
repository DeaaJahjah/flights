import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flights/core/constents/constents.dart';
import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/utils/validators.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/core/widgets/custom_text_field.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/auth/models/client.dart';
import 'package:flights/features/auth/services/file_services.dart';
import 'package:flights/features/auth/services/user_db_services.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class EditClientAccountScreen extends StatefulWidget {
  static const routeName = '/edit-client-account';
  const EditClientAccountScreen({super.key});

  @override
  State<EditClientAccountScreen> createState() => _EditClientAccountScreenState();
}

class _EditClientAccountScreenState extends State<EditClientAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  // late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  DateTime? birthday;
  String? imageName;
  File? imageFile;
  FilePickerResult? pickedFile;
  Uint8List? logoBase64;

  bool isLoading = false;
  bool isInit = false;

  void chooseImage() async {
    pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      try {
        setState(() {
          logoBase64 = pickedFile!.files.first.bytes;
          imageName = pickedFile!.files.first.name;
        });
      } catch (err) {
        print(err);
      }
    } else {
      print('No Image Selected');
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final client = ModalRoute.of(context)!.settings.arguments as Client;
      _fullNameController = TextEditingController(text: client.name);
      _ageController =
          TextEditingController(text: '${client.birthday.year}-${client.birthday.month}-${client.birthday.day}');
// _addressController= TextEditingController(text: client.ad);
      _emailController = TextEditingController(text: client.email);
// _passwordController= TextEditingController(text:client. );
      _phoneController = TextEditingController(text: client.phone);
      birthday = client.birthday;
      setState(() {
        isInit = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final oldClient = ModalRoute.of(context)!.settings.arguments as Client;

    return Scaffold(
      backgroundColor: R.primaryColor,
      body: !isInit
          ? const SizedBox.shrink()
          : ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعديل حساب زبون', style: Theme.of(context).textTheme.headlineLarge),
                    sizedBoxLarge,
                    InkWell(
                      onTap: () async {
                        try {
                          chooseImage();
                          setState(() {});
                        } catch (e) {}
                      },
                      child: oldClient.imageUrl != null && logoBase64 == null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: Image.network(oldClient.imageUrl!))
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: (logoBase64 == null)
                                  ? Image.asset("assets/images/pick_image.png", scale: 1.2)
                                  : CircleAvatar(radius: 70, backgroundImage: MemoryImage(logoBase64!))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              CustomTextField(
                                labelText: 'الاسم الكامل',
                                controller: _fullNameController,
                                prefixIcon: Icon(Icons.person, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                keyboardType: TextInputType.text,
                                validator: emptyValidator,
                              ),
                              sizedBoxMedium,
                              CustomTextField(
                                  labelText: 'تاريخ الميلاد',
                                  prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                                  mainColor: R.secondaryColor,
                                  secondaryColor: R.tertiaryColor,
                                  controller: _ageController,
                                  validator: emptyValidator,
                                  onTap: () async {
                                    birthday = await showRoundedDatePicker(
                                      context: context,
                                      lastDate: DateTime.now(),
                                      initialDate: DateTime(1960),
                                      // firstDate: DateTime(2000),
                                      theme: ThemeData(primarySwatch: Colors.pink),
                                    );
                                    _ageController.text =
                                        ('${birthday!.year}-${birthday!.month}-${birthday!.day}').toString();
                                  },
                                  readOnly: true,
                                  keyboardType: TextInputType.text),
                              sizedBoxMedium,
                              // CustomTextField(
                              //     labelText: 'العنوان',
                              //     prefixIcon: Icon(Icons.location_city, color: R.secondaryColor),
                              //     mainColor: R.secondaryColor,
                              //     secondaryColor: R.tertiaryColor,
                              //     controller: _addressController,
                              //     validator: emptyValidator,
                              //     keyboardType: TextInputType.text),
                              // sizedBoxMedium,
                              CustomTextField(
                                  labelText: 'البريد الإلكتروني',
                                  prefixIcon: Icon(Icons.email, color: R.secondaryColor),
                                  mainColor: R.secondaryColor,
                                  secondaryColor: R.tertiaryColor,
                                  controller: _emailController,
                                  validator: emptyValidator,
                                  keyboardType: TextInputType.emailAddress),
                              sizedBoxMedium,
                              // CustomTextField(
                              //     labelText: 'كلمة السر',
                              //     prefixIcon: Icon(Icons.lock, color: R.secondaryColor),
                              //     mainColor: R.secondaryColor,
                              //     secondaryColor: R.tertiaryColor,
                              //     controller: _passwordController,
                              //     validator: emptyValidator,
                              //     keyboardType: TextInputType.visiblePassword),
                              // sizedBoxMedium,
                              CustomTextField(
                                labelText: 'رقم الهاتف',
                                prefixIcon: Icon(Icons.phone, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                digitsOnly: true,
                                validator: emptyValidator,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
                        child: !isLoading
                            ? CustomFilledButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  String? imageUrl;

                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (logoBase64 != null) {
                                    imageUrl = await FileDbService().uploadeImageByte(imageName!, logoBase64!, context);
                                  }

                                  if (imageUrl == 'error') {
                                    showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  var client = Client(
                                      id: oldClient.id,
                                      name: _fullNameController.text,
                                      phone: _phoneController.text,
                                      birthday: birthday!,
                                      userType: UserType.client,
                                      email: _emailController.text,
                                      imageUrl: imageUrl);
                                  if (mounted) {
                                    final result = await UserDbServices().editClient(client: client, context: context);
                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (result == 'error') {
                                      return;
                                    } else {
                                      Navigator.of(context).pop(true);
                                    }
                                  }
                                },
                                text: 'موافق')
                            : const CustomProgress()),
                  ],
                ),
              ],
            ),
    );
  }
}
