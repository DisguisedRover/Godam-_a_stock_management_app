import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Management')),
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
                  Icons.shopping_cart,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 25),
                Text(
                  'Sales Management',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Track and manage all your sales transactions, invoices, and customer orders.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Sales Options Section
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
                          'Sales Actions',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),

                        // New Sale
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Create New Sale'),
                          subtitle: const Text(
                            'Record a new sales transaction',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Creating new sale...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Sales History
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('Sales History'),
                          subtitle: const Text('View past sales records'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening sales history...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Customer Management
                        ListTile(
                          leading: const Icon(Icons.people),
                          title: const Text('Customer Sales'),
                          subtitle: const Text('View sales by customer'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Showing customer sales...'),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 20),

                        // Reports
                        ListTile(
                          leading: const Icon(Icons.bar_chart),
                          title: const Text('Sales Reports'),
                          subtitle: const Text('Generate sales analytics'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Generating sales reports...'),
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
                //               content: Text('Exporting sales data...'),
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
