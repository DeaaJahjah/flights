import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/features/auth/screens/edit_company_account_screen.dart';
import 'package:flights/features/auth/services/user_db_services.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatefulWidget {
  static const routeName = '/company-profile';

  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: UserDbServices().getCompanyProfileInfo(userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data == null) {
              return const Center(
                child: Text('حدث خطأ'),
              );
            }
            final company = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'الملف الشخصي',
                  style: TextStyle(fontFamily: fontFamily),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          child: company.imageUrl == null
                              ? Image.asset("assets/images/pick_image.png", scale: 1.2)
                              : CircleAvatar(radius: 70, backgroundImage: NetworkImage(company.imageUrl!)),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('الاسم', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(company.name, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.call, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('رقم الهاتف', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(company.phone, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.call, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('البريد الالكتروني', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(company.email, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('العنوان', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(company.address, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.description, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('من نحن', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(company.description, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: userId == context.userUid
                  ? FloatingActionButton(
                      backgroundColor: Theme.of(context).indicatorColor,
                      child: Icon(
                        Icons.edit,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        await Navigator.of(context)
                            .pushNamed(EditCompanyAccountScreen.routeName, arguments: company)
                            .then((value) {
                          if (value == true) {
                            setState(() {});
                          }
                        });
                      },
                    )
                  : const SizedBox.shrink(),
            );
          case ConnectionState.waiting:
            return const Scaffold(body: CustomProgress());
          case ConnectionState.active:
          // TODO: Handle this case.
          case ConnectionState.none:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
