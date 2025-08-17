import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Management')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.shopping_bag,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 25),
                Text(
                  'Purchase Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Manage your inventory purchases, supplier orders, and procurement processes.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Purchase Options Section
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase Actions',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),

                        // New Purchase
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Create New Purchase'),
                          subtitle: const Text(
                            'Record a new inventory purchase',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Creating new purchase order...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Purchase History
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('Purchase History'),
                          subtitle: const Text('View past purchase records'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening purchase history...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Supplier Management
                        ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: const Text('Supplier Purchases'),
                          subtitle: const Text('View purchases by supplier'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Showing supplier purchases...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Inventory Reports
                        ListTile(
                          leading: const Icon(Icons.inventory),
                          title: const Text('Inventory Reports'),
                          subtitle: const Text('Generate purchase analytics'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Generating inventory reports...',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Action Buttons
                // Wrap(
                //   spacing: 20,
                //   runSpacing: 20,
                //   alignment: WrapAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 200,
                //       child: ElevatedButton.icon(
                //         onPressed: () => Navigator.pop(context),
                //         icon: const Icon(Icons.arrow_back),
                //         label: const Text('Back to Dashboard'),
                //         style: ElevatedButton.styleFrom(
                //           padding: const EdgeInsets.symmetric(vertical: 15),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 200,
                //       child: OutlinedButton.icon(
                //         onPressed: () {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(
                //               content: Text('Exporting purchase data...'),
                //             ),
                //           );
                //         },
                //         icon: const Icon(Icons.download),
                //         label: const Text('Export Data'),
                //         style: OutlinedButton.styleFrom(
                //           padding: const EdgeInsets.symmetric(vertical: 15),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
