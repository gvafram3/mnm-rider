import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m_rider/commons/app_colors.dart';
import 'package:m_n_m_rider/widgets/alert_dialog.dart';

import '../../../../utils/providers/payment_account_provider.dart';

class PaymentMethodsPage extends ConsumerWidget {
  const PaymentMethodsPage({super.key});
  static const routeName = '/payment-methods';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;
    final accounts = ref.watch(accountProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(IconlyLight.arrow_left_2),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
        title: Text(
          'Payment Methods',
          style: theme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: size.height * 0.01),
              if (accounts.isNotEmpty)
                Text('Your Accounts', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...[
                      SizedBox(height: size.height * 0.01),
                      ...accounts.map((account) =>
                          _buildAccountCard(context, account, ref)),
                      SizedBox(height: size.height * 0.04),
                    ],
                  ],
                ),
              ),
              if (accounts.isNotEmpty) SizedBox(height: size.height * 0.03),
              Text('Mobile Money', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              _buildAddCard(
                  context, Icons.phone_iphone_outlined, 'Add mobile money', () {
                Navigator.pushNamed(context, '/add-account');
              }),
              SizedBox(height: size.height * 0.03),
              Text('Bank Card', style: theme.titleMedium),
              SizedBox(height: size.height * 0.01),
              _buildAddCard(
                  context, Icons.credit_card, 'Add a credit/debit card', () {
                Navigator.pushNamed(context, '/add-account');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard(
      BuildContext ctx, IconData icon, String title, VoidCallback onTap) {
    final size = MediaQuery.of(ctx).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppColors.cardColor),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Center(
          child: Row(
            children: [
              Icon(
                icon,
                size: size.width * 0.1,
                color: Colors.grey[500],
              ),
              SizedBox(width: size.width * 0.02),
              Text(title),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext ctx, Account account, WidgetRef ref) {
    final size = MediaQuery.of(ctx).size;
    return Padding(
      padding: EdgeInsets.only(right: size.width * 0.025),
      child: Container(
        height: size.height * 0.19,
        width: size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: account.network == Network.MTN
              ? const Color.fromARGB(255, 255, 203, 5)
              : const Color.fromARGB(255, 155, 1, 1),
        ),
        child: Stack(
          children: [
            // The background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/connect.png',
                fit: BoxFit.cover,
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                  color: account.network == Network.MTN
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Number:',
                              style: TextStyle(
                                  color: account.network == Network.MTN
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            Text(
                              'Reference:',
                              style: TextStyle(
                                  color: account.network == Network.MTN
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: SizedBox(
                          width: size.width * 0.26,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Afram Gyebi Visca',
                                style: TextStyle(
                                    color: account.network == Network.MTN
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                '0242424242',
                                style: TextStyle(
                                    color: account.network == Network.MTN
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                'This is my first MTN momo line',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: account.network == Network.MTN
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      account.network == Network.MTN
                          ? Row(
                              children: [
                                Image.asset('assets/images/MTN-logo-1.png'),
                                Image.asset('assets/images/MTN-momo-logo.png'),
                              ],
                            )
                          : Image.asset('assets/images/telecash-logo.png'),
                      GestureDetector(
                        onTap: () {
                          showCustomAlertDialog(
                            context: ctx,
                            title: 'Confirm Deletion',
                            body: const Text(
                                'Are you sure you want to delete this account?'),
                            onTapRight: () {
                              ref
                                  .read(accountProvider.notifier)
                                  .removeAccount(account);
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                  content: Text('Account deleted successfully'),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.errorColor2,
                          ),
                          height: size.height * 0.035,
                          width: size.width * 0.1,
                          child: const Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
