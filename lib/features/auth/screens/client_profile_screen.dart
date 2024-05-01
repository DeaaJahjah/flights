import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/features/auth/screens/edit_client_account_screen.dart';
import 'package:flights/features/auth/services/user_db_services.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class ClientProfileScreen extends StatefulWidget {
  static const routeName = '/client-profile';

  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: UserDbServices().getClientProfileInfo(userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data == null) {
              print(snapshot.error);
              return const Material(
                child: Center(
                  child: Text('حدث خطأ'),
                ),
              );
            }
            final client = snapshot.data!;
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
                          child: client.imageUrl == null
                              ? Image.asset("assets/images/pick_image.png", scale: 1.2)
                              : CircleAvatar(radius: 70, backgroundImage: NetworkImage(client.imageUrl!)),
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
                          Text(client.name, style: const TextStyle(fontSize: 14)),
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
                          Text(client.phone, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.email, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('البريد الالكتروني', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text(client.email, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.date_range, color: R.secondaryColor),
                          const SizedBox(width: 10),
                          const Text('تاريخ الميلاد', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Text('${client.birthday.year}-${client.birthday.month}-${client.birthday.day}',
                              style: const TextStyle(fontSize: 14)),
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
                        Navigator.of(context)
                            .pushNamed(EditClientAccountScreen.routeName, arguments: client)
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
