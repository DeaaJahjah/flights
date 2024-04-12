import 'package:flights/core/constents/constents.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/auth/screens/create_client_account_screen.dart';
import 'package:flights/features/auth/screens/create_company_account_screen.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class SelectAccountTypeScreen extends StatefulWidget {
  static const routeName = '/select-account-type';
  const SelectAccountTypeScreen({super.key});

  @override
  State<SelectAccountTypeScreen> createState() => _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  int selectedType = -1;
  @override
  Widget build(BuildContext context) {
    final types = ['زبون', 'شركة طيران'];
    return Scaffold(
      backgroundColor: R.primaryColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('اختر نوع الحساب', style: Theme.of(context).textTheme.headlineLarge),
              sizedBoxLarge,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Column(children: [
                  SelectTypeWidget(
                    title: types[0],
                    isSelected: 1 == selectedType,
                    onTap: () {
                      setState(() {});
                      selectedType = 1;
                    },
                  ),
                  SelectTypeWidget(
                    title: types[1],
                    isSelected: 2 == selectedType,
                    onTap: () {
                      setState(() {});
                      selectedType = 2;
                    },
                  ),
                ]),
              ),
              CustomFilledButton(
                  onPressed: () {
                    if (selectedType == 1) {
                      Navigator.of(context).pushNamed(CreateClientAccountScreen.routeName);
                      return;
                    }
                    if (selectedType == 2) {
                      Navigator.of(context).pushNamed(CreateCompanyAccountScreen.routeName);
                      return;
                    }
                  },
                  text: 'التالي')
            ],
          )),
    );
  }
}

//select Type Widget
class SelectTypeWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isSelected;
  const SelectTypeWidget({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? R.secondaryColor : R.tertiaryColor, borderRadius: BorderRadius.circular(borderRadius)),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
