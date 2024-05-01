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
import 'package:flights/features/auth/models/company.dart';
import 'package:flights/features/auth/services/file_services.dart';
import 'package:flights/features/auth/services/user_db_services.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class EditCompanyAccountScreen extends StatefulWidget {
  static const routeName = '/edit-company-account';
  const EditCompanyAccountScreen({super.key});

  @override
  State<EditCompanyAccountScreen> createState() => _EditCompanyAccountScreenState();
}

class _EditCompanyAccountScreenState extends State<EditCompanyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  // late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
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
    Future.delayed(
      Duration.zero,
      () {
        final company = ModalRoute.of(context)!.settings.arguments as Company;

        _fullNameController = TextEditingController(text: company.name);
        _addressController = TextEditingController(text: company.address);
        _emailController = TextEditingController(text: company.email);
// _passwordController=TextEditingController(text: company.name);
        _phoneController = TextEditingController(text: company.phone);
        _descriptionController = TextEditingController(text: company.description);

        setState(() {
          isInit = true;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final company = ModalRoute.of(context)!.settings.arguments as Company;

    return Scaffold(
      backgroundColor: R.primaryColor,
      body: !isInit
          ? const SizedBox.shrink()
          : ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعديل حساب شركة', style: Theme.of(context).textTheme.headlineLarge),
                    sizedBoxLarge,
                    InkWell(
                      onTap: () async {
                        try {
                          chooseImage();
                          setState(() {});
                        } catch (e) {}
                      },
                      child: company.imageUrl != null && logoBase64 == null
                          ? CircleAvatar(
                              radius: 60, backgroundColor: Colors.transparent, child: Image.network(company.imageUrl!))
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
                                prefixIcon: Icon(Icons.person, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _fullNameController,
                                keyboardType: TextInputType.text,
                                validator: emptyValidator,
                              ),
                              sizedBoxMedium,
                              CustomTextField(
                                labelText: 'العنوان',
                                prefixIcon: Icon(Icons.location_city, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _addressController,
                                keyboardType: TextInputType.text,
                                validator: emptyValidator,
                              ),
                              sizedBoxMedium,
                              CustomTextField(
                                labelText: 'البريد الإلكتروني',
                                prefixIcon: Icon(Icons.email, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: emptyValidator,
                              ),
                              // sizedBoxMedium,
                              // CustomTextField(
                              //   labelText: 'كلمة السر',
                              //   prefixIcon: Icon(Icons.lock, color: R.secondaryColor),
                              //   mainColor: R.secondaryColor,
                              //   secondaryColor: R.tertiaryColor,
                              //   controller: _passwordController,
                              //   keyboardType: TextInputType.visiblePassword,
                              //   validator: emptyValidator,
                              // ),
                              sizedBoxMedium,
                              CustomTextField(
                                labelText: 'رقم الهاتف',
                                prefixIcon: Icon(Icons.phone, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                digitsOnly: true,
                                validator: emptyValidator,
                              ),
                              CustomTextField(
                                labelText: 'وصف عن الشركة',
                                prefixIcon: Icon(Icons.description, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _descriptionController,
                                keyboardType: TextInputType.text,
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
                                    imageUrl = await FileDbService().uploadeFile(imageName!, logoBase64!, context);
                                  }

                                  if (imageUrl == 'error') {
                                    showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }

                                  var company = Company(
                                    id: '',
                                    email: _emailController.text,
                                    name: _fullNameController.text,
                                    phone: _phoneController.text,
                                    address: _addressController.text,
                                    description: _descriptionController.text,
                                    imageUrl: imageUrl,
                                    userType: UserType.company,
                                  );

                                  if (mounted) {
                                    final result =
                                        await UserDbServices().editCompany(company: company, context: context);
                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (result == 'error') {
                                      return;
                                    }

                                    Navigator.of(context).pop(true);
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
