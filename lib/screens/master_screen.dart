import 'package:flutter/material.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Data Management')),
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
                  Icons.data_usage,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 25),
                Text(
                  'Master Data Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Manage all core business data including products, suppliers, customers and more.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Master Data Options Section
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
                          'Data Categories',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),

                        // Products Management
                        ListTile(
                          leading: const Icon(Icons.inventory),
                          title: const Text('Products Management'),
                          subtitle: const Text('Manage your product catalog'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Navigating to Products Management',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Suppliers Management
                        ListTile(
                          leading: const Icon(Icons.local_shipping),
                          title: const Text('Suppliers Management'),
                          subtitle: const Text('Manage your suppliers list'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Navigating to Suppliers Management',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Customers Management
                        ListTile(
                          leading: const Icon(Icons.people),
                          title: const Text('Customers Management'),
                          subtitle: const Text('Manage your customer database'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Navigating to Customers Management',
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Pricing Management
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: const Text('Pricing Management'),
                          subtitle: const Text('Configure product pricing'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Navigating to Pricing Management',
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

                // Action Buttons - Fixed width buttons
                // Wrap(
                //   spacing: 20,
                //   runSpacing: 20,
                //   alignment: WrapAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 200, // Fixed width
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
                //       width: 200, // Fixed width
                //       child: OutlinedButton.icon(
                //         onPressed: () {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(
                //               content: Text('Exporting master data...'),
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
