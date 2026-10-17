import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/medicine_model.dart';
import '../../core/providers/patient_provider.dart';
import '../../widgets/section_header.dart';
import 'package:ayupilot/core/utils/theme_utils.dart';

class MedicineStoreScreen extends StatefulWidget {
  final bool showBackButton;
  const MedicineStoreScreen({super.key, this.showBackButton = true});

  @override
  State<MedicineStoreScreen> createState() => _MedicineStoreScreenState();
}

class _MedicineStoreScreenState extends State<MedicineStoreScreen> {
  int _selectedCategory = 0;
  bool _showCart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().fetchMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientProvider>();
    final medicines = provider.medicines;
    final categories = ['All', ...medicines.map((m) => m.category).toSet()];
    final selectedCategory =
        _selectedCategory < categories.length ? _selectedCategory : 0;
    final filtered = selectedCategory == 0
        ? medicines
        : medicines
            .where((m) => m.category == categories[selectedCategory])
            .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Ayurvedic Store',
          style: GoogleFonts.playfairDisplay(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => setState(() => _showCart = !_showCart),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.shopping_cart_outlined,
                        color: context.txt, size: 22),
                  ),
                  if (provider.cartCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${provider.cartCount}',
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _showCart
          ? _CartView(
              provider: provider,
              onClose: () => setState(() => _showCart = false))
          : _buildStore(provider, filtered),
    );
  }

  Widget _buildStore(PatientProvider provider, List<MedicineModel> filtered) {
    final categories = ['All', ...provider.medicines.map((m) => m.category).toSet()];
    final selectedCategory =
        _selectedCategory < categories.length ? _selectedCategory : 0;
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🏪', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Curated for You',
                        style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        'Premium Ayurvedic products - 100% authentic & natural.',
                        style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Category filter
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final selected = i == selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: selected ? AppColors.primary : context.border),
                  ),
                  child: Text(
                    categories[i],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Products grid
        Expanded(
          child: provider.isLoadingMedicines
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No medicines are available right now.',
                        style: GoogleFonts.nunito(color: context.txtSecondary),
                      ),
                    )
                  : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _ProductCard(
                    medicine: filtered[i],
                    inCart: provider.cart.any((m) => m.id == filtered[i].id),
                    onAddToCart: () {
                      context.read<PatientProvider>().addToCart(filtered[i]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${filtered[i].name} added to cart!',
                              style: GoogleFonts.nunito()),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onTap: () => _showProductDetail(context, filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }

  void _showProductDetail(BuildContext context, MedicineModel medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductDetailSheet(medicine: medicine),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final MedicineModel medicine;
  final bool inCart;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;
  const _ProductCard({
    required this.medicine,
    required this.inCart,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image area
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.cardGold.withValues(alpha: 0.7),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(medicine.icon,
                    size: 52,
                    color: AppColors.primaryDark.withValues(alpha: 0.6)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medicine.unit,
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: context.txtSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 12, color: AppColors.accent),
                      const SizedBox(width: 2),
                      Text(
                        '${medicine.rating}',
                        style: GoogleFonts.nunito(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${medicine.price.toInt()}',
                        style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark),
                      ),
                      GestureDetector(
                        onTap: inCart ? null : onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: inCart
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            inCart ? Icons.check_rounded : Icons.add_rounded,
                            color: inCart ? AppColors.success : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailSheet extends StatelessWidget {
  final MedicineModel medicine;
  const _ProductDetailSheet({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.textLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
                child: Icon(medicine.icon,
                    size: 64,
                    color: AppColors.primaryDark.withValues(alpha: 0.6))),
            const SizedBox(height: 16),
            Text(medicine.name,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            Text(medicine.unit,
                style: GoogleFonts.nunito(
                    fontSize: 14, color: context.txtSecondary)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    size: 16, color: AppColors.accent),
                const SizedBox(width: 4),
                Text('${medicine.rating} (${medicine.reviewCount} reviews)',
                    style: GoogleFonts.nunito(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),
            Text(medicine.description,
                style: GoogleFonts.nunito(
                    fontSize: 14, color: context.txtSecondary, height: 1.5)),
            const SizedBox(height: 20),
            SectionHeader(title: '✨ Key Benefits'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: medicine.benefits
                  .map((b) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(b,
                            style: GoogleFonts.nunito(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  '₹${medicine.price.toInt()}',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${(medicine.price * 1.2).toInt()} MRP',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: context.txtLight,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('17% OFF',
                      style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<PatientProvider>().addToCart(medicine);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Added to cart!', style: GoogleFonts.nunito()),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text('Add to Cart',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class _CartView extends StatelessWidget {
  final PatientProvider provider;
  final VoidCallback onClose;
  const _CartView({required this.provider, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: onClose,
              ),
              Text('Cart (${provider.cartCount})',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Expanded(
          child: provider.cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🛒', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text('Your cart is empty',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.cart.length,
                  itemBuilder: (_, i) {
                    final item = provider.cart[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, size: 28, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                                Text(
                                    '₹${item.price.toInt()} × ${item.quantity}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: context.txtSecondary)),
                              ],
                            ),
                          ),
                          Text(
                            '₹${(item.price * item.quantity).toInt()}',
                            style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context
                                .read<PatientProvider>()
                                .removeFromCart(item.id),
                            child: const Icon(Icons.delete_outline_rounded,
                                color: AppColors.error, size: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (provider.cart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(
                      '₹${provider.cartTotal.toInt()}',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PatientProvider>().clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Order placed! Expected delivery in 3–5 days. 🎉',
                              style: GoogleFonts.nunito()),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Place Order',
                        style: GoogleFonts.nunito(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
