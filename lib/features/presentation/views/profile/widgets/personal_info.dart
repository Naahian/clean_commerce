import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/widgets.dart';
import 'package:clean_commerce/features/presentation/widgets/dialog_action.dart';
import 'package:clean_commerce/features/presentation/widgets/edit_dialog.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/infocard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfo extends ConsumerWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = ref.read(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);

    final email = authState.email;
    final phone = authState.profile?.phone ?? 0;
    final address = authState.profile?.address ?? 'none';

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        InfoCard(icon: Icons.email_outlined, label: "Email", value: email),
        InfoCard(
          icon: Icons.phone_outlined,
          label: "Phone",
          value: "$phone",
          isEdit: true,
          onTap: () => showDialog(
            context: context,
            builder: (context) => EditDialog(
              title: "Edit Phone",
              currentValue: "$phone",
              onSave: (val) => authCtrl.updatePhone(val),
              inputType: TextInputType.phone,
            ),
          ),
        ),
        InfoCard(
          icon: Icons.home_work_outlined,
          label: "Address",
          value: address,
          isEdit: true,
          onTap: () => showDialog(
            context: context,
            builder: (context) => EditDialog(
              title: "Edit Address",
              currentValue: address,
              onSave: (val) => authCtrl.updateAddress(val),
            ),
          ),
        ),
        InfoCard(
          icon: Icons.delete_forever,
          label: "account action",
          value: "Delete My Account",
          isDanger: true,
          onTap: () => showDialog(
            context: context,
            builder: (_) => DialogAction(
              title: 'Are You Sure?',
              subtitle:
                  'This action is Irreversible. Deleting account forever in 3 days.',
              iconColor: Colors.red,
              onSubmit: () {},
            ),
          ),
        ),
      ]),
    );
  }
}
