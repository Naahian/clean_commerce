import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/models/transaction_model.dart';
import 'package:clean_commerce/features/domain/entity/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/widgets.dart';
import 'package:clean_commerce/features/presentation/widgets/dialog_action.dart';
import 'package:clean_commerce/features/presentation/widgets/edit_dialog.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/infocard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // Track editable values
  String phoneNumber = '+1 234 567 8900';
  String address = 'New York, USA';
  final String email = 'john.doe@example.com';
  final TransactionEntity transaction = TransactionEntity(
    id: 'TRX-YXZ1313R0F1',
    userId: '1',
    type: TransactionType.payment.name,
    amount: 99.99,
    date: DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        InfoCard(icon: Icons.email_outlined, label: "Email", value: email),
        InfoCard(
          icon: Icons.phone_outlined,
          label: "Phone",
          value: phoneNumber,
          isEdit: true,
          onTap: () {},
        ),
        InfoCard(
          icon: Icons.home_work_outlined,
          label: "Address",
          value: address,
          isEdit: true,
          onTap: () {},
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Text(
            "Most Recent Transaction",
            style: theme.textTheme.titleLarge,
          ),
        ),
        TransactionItem(transaction: transaction, isTransaction: true),
      ]),
    );
  }
}
