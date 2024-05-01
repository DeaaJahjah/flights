import 'package:flights/core/utils/validators.dart';
import 'package:flights/core/widgets/custom_text_field.dart';
import 'package:flights/features/client/models/traveler.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/next_back_buttons.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v1.dart';

class TravlerScreen extends StatefulWidget {
  static const String routeName = '/travler';
  const TravlerScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<TravlerScreen> createState() => _TravlerScreenState();
}

class _TravlerScreenState extends State<TravlerScreen> {
  @override
  void initState() {
    context.read<TicketProvider>().travlersList = [];
    context.read<TicketProvider>().travlersList = List.generate(
        context.read<TicketProvider>().travelerNumber,
        (index) => Traveler(
            id: const UuidV1().generate(),
            name: '',
            phoneNumber: '',
            birthDay: null,
            passportEndDate: null,
            passportReleaseDate: null,
            nationality: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.travelerNumber,
              itemBuilder: (BuildContext context, int index) {
                print(context.read<TicketProvider>().travlersList[index].passportEndDate);
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), border: Border.all(color: R.secondaryColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('المسافر رقم ${index + 1}', style: TextStyle(color: R.secondaryColor, fontSize: 20)),
                      CustomTextField(
                        labelText: 'الاسم',
                        prefixIcon: Icon(Icons.person, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller:
                            TextEditingController(text: context.read<TicketProvider>().travlersList[index].name),
                        keyboardType: TextInputType.text,
                        digitsOnly: false,
                        validator: emptyValidator,
                        onChanged: (value) {
                          context.read<TicketProvider>().travlersList[index] =
                              context.read<TicketProvider>().travlersList[index].copyWith(name: value);
                        },
                      ),
                      CustomTextField(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller:
                            TextEditingController(text: context.read<TicketProvider>().travlersList[index].phoneNumber),
                        keyboardType: TextInputType.text,
                        digitsOnly: true,
                        validator: emptyValidator,
                        onChanged: (value) {
                          context.read<TicketProvider>().travlersList[index] =
                              context.read<TicketProvider>().travlersList[index].copyWith(phoneNumber: value);
                        },
                      ),
                      CustomTextField(
                        labelText: 'الجنسية',
                        prefixIcon: Icon(Icons.flag, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller:
                            TextEditingController(text: context.read<TicketProvider>().travlersList[index].nationality),
                        keyboardType: TextInputType.text,
                        // digitsOnly: true,
                        validator: emptyValidator,
                        onChanged: (value) {
                          context.read<TicketProvider>().travlersList[index] =
                              context.read<TicketProvider>().travlersList[index].copyWith(nationality: value);
                        },
                      ),
                      CustomTextField(
                        labelText: 'تاريخ الميلاد',
                        prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller: TextEditingController(
                            text: context.read<TicketProvider>().travlersList[index].birthDay != null
                                ? '${context.read<TicketProvider>().travlersList[index].birthDay!.year}-${context.read<TicketProvider>().travlersList[index].birthDay!.month}-${context.read<TicketProvider>().travlersList[index].birthDay!.day}'
                                : ''),
                        keyboardType: TextInputType.text,
                        digitsOnly: false,
                        validator: emptyValidator,
                        readOnly: true,
                        onTap: () async {
                          final birthDay = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2025),
                          );
                          context.read<TicketProvider>().travlersList[index] =
                              context.read<TicketProvider>().travlersList[index].copyWith(birthDay: birthDay);

                          setState(() {});
                          // if (birthDay == null) {
                          //   // _dateController.text = '';
                          // } else {
                          //   // _dateController.text = '${leavingDate!.year}-${leavingDate!.month}-${leavingDate!.day}';
                          // }
                        },
                      ),
                      CustomTextField(
                        labelText: 'تاريخ منح جواز السفر',
                        prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller: TextEditingController(
                            text: context.read<TicketProvider>().travlersList[index].passportReleaseDate != null
                                ? '${context.read<TicketProvider>().travlersList[index].passportReleaseDate!.year}-${context.read<TicketProvider>().travlersList[index].passportReleaseDate!.month}-${context.read<TicketProvider>().travlersList[index].passportReleaseDate!.day}'
                                : ''),
                        keyboardType: TextInputType.text,
                        digitsOnly: false,
                        validator: emptyValidator,
                        readOnly: true,
                        onTap: () async {
                          final passportReleaseDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2025),
                          );

                          context.read<TicketProvider>().travlersList[index] = context
                              .read<TicketProvider>()
                              .travlersList[index]
                              .copyWith(passportReleaseDate: passportReleaseDate);
                          // if (passportReleaseDate == null) {
                          //   // _dateController.text = '';
                          // } else {
                          //   // _dateController.text = '${leavingDate!.year}-${leavingDate!.month}-${leavingDate!.day}';
                          // }

                          setState(() {});
                        },
                      ),
                      CustomTextField(
                        labelText: 'تاريخ انتهاء جواز السفر',
                        prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                        mainColor: R.secondaryColor,
                        secondaryColor: R.tertiaryColor,
                        controller: TextEditingController(
                            text: context.read<TicketProvider>().travlersList[index].passportEndDate != null
                                ? '${context.read<TicketProvider>().travlersList[index].passportEndDate!.year}-${context.read<TicketProvider>().travlersList[index].passportEndDate!.month}-${context.read<TicketProvider>().travlersList[index].passportEndDate!.day}'
                                : ''),
                        keyboardType: TextInputType.text,
                        digitsOnly: false,
                        validator: emptyValidator,
                        readOnly: true,
                        onTap: () async {
                          final passportEndDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1920),
                            lastDate: DateTime(2025),
                          );

                          context.read<TicketProvider>().travlersList[index] = context
                              .read<TicketProvider>()
                              .travlersList[index]
                              .copyWith(passportEndDate: passportEndDate);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          NextBackButtons(
            onNext: () {
              // final provider = context.read<TicketProvider>();
              // if (provider.travelerNumber < selectedSeat.length) {
              //   showErrorSnackBar(context, 'الرجاء اختيار مقاعد لكل الأشخاص');
              //   return;
              // }
              // if (provider.selectedFlights.isEmpty) {
              //   showErrorSnackBar(context, 'الرجاء اختيار رحلة');
              //   return;
              // }
              widget.tabController.animateTo(4);
            },
            onBack: () {
              widget.tabController.animateTo(2);
            },
          )
        ],
      );
    });
  }
}
