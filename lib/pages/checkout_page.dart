import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _catatanController = TextEditingController();

  String _metodeBayar = 'COD';
  bool _isLoading = false;

  // ===== PICKUP MODE =====
  bool _isImmediate = true; // true = Segera, false = Pilih Jam
  DateTime? _pickupTime;

  static const Color primaryColor = Color(0xFFC8956D);
  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color inputBg = Color(0xFF141414);
  static const Color dividerColor = Color(0xFF252525);

  final List<Map<String, dynamic>> _metodeBayarList = [
    {'name': 'COD', 'icon': Icons.payments_outlined, 'label': 'Bayar di Tempat'},
    {'name': 'Transfer Bank', 'icon': Icons.account_balance_outlined, 'label': 'BCA / Mandiri / BNI'},
    {'name': 'E-Wallet', 'icon': Icons.wallet_outlined, 'label': 'GoPay / OVO / Dana'},
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // ============================================
  // PICK TIME
  // ============================================
  Future<void> _pickPickupTime() async {
    final now = DateTime.now();
    final initialTime = TimeOfDay(hour: now.hour + 1, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'PILIH JAM PENGAMBILAN',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: cardColor,
              hourMinuteColor: primaryColor.withValues(alpha: 0.15),
              hourMinuteTextColor: Colors.white,
              dayPeriodColor: primaryColor.withValues(alpha: 0.15),
              dayPeriodTextColor: Colors.white,
              dialBackgroundColor: bgColor,
              dialHandColor: primaryColor,
              dialTextColor: Colors.white,
              entryModeIconColor: primaryColor,
              helpTextStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final now2 = DateTime.now();
    var pickup = DateTime(
      now2.year,
      now2.month,
      now2.day,
      picked.hour,
      picked.minute,
    );

    // Kalau jam yang dipilih < sekarang + 30 menit → anggap besok
    // (biar user nggak salah input, contoh: sekarang jam 20, user pilih jam 08)
    if (pickup.isBefore(now2.add(const Duration(minutes: 30)))) {
      pickup = pickup.add(const Duration(days: 1));
    }

    setState(() {
      _pickupTime = pickup;
      _isImmediate = false;
    });
  }

  // ============================================
  // HANDLE CHECKOUT
  // ============================================
  Future<void> _handleCheckout() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // Validasi: kalau pilih jam, harus ada _pickupTime
    if (!_isImmediate && _pickupTime == null) {
      _showSnackBar('Pilih jam pengambilan dulu ya', Icons.warning_amber_rounded);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final cart = context.read<CartProvider>();
    final order = await cart.createOrder(
      namaPenerima: _namaController.text.trim(),
      nomorHp: _hpController.text.trim(),
      metodeBayar: _metodeBayar,
      catatan: _catatanController.text.trim(),
      pickupTime: _isImmediate ? null : _pickupTime,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessPage(order: order),
      ),
    );
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== PICKUP INFO =====
                      _buildPickupInfo(cart),

                      const SizedBox(height: 32),

                      // ===== SECTION: INFO PEMESAN =====
                      _sectionLabel('INFO PEMESAN'),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _namaController,
                        hint: 'Nama lengkap',
                        icon: Icons.person_outline,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _hpController,
                        hint: 'Nomor WhatsApp',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nomor HP tidak boleh kosong';
                          }
                          if (val.trim().length < 10) {
                            return 'Nomor HP minimal 10 digit';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // ===== SECTION: JAM PENGAMBILAN =====  ← ✅ BARU
                      _sectionLabel('JAM PENGAMBILAN'),
                      const SizedBox(height: 14),
                      _buildPickupTimeOptions(),

                      const SizedBox(height: 28),

                      // ===== SECTION: CATATAN =====
                      _sectionLabel('CATATAN (OPSIONAL)'),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _catatanController,
                        hint: 'Contoh: Tanpa es, extra pedas, dll',
                        icon: Icons.edit_note_outlined,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 28),

                      // ===== SECTION: METODE PEMBAYARAN =====
                      _sectionLabel('METODE PEMBAYARAN'),
                      const SizedBox(height: 14),
                      ..._metodeBayarList.map((m) => _buildPaymentOption(
                        name: m['name'],
                        icon: m['icon'],
                        label: m['label'],
                      )),

                      const SizedBox(height: 28),

                      // ===== SECTION: RINGKASAN =====
                      _sectionLabel('RINGKASAN PESANAN'),
                      const SizedBox(height: 14),
                      _buildOrderSummary(cart),
                    ],
                  ),
                ),
              ),
            ),

            _buildBottomBar(cart),
          ],
        ),
      ),
    );
  }

  // ============================================
  // PICKUP TIME OPTIONS (SEGERA / PILIH JAM)
  // ============================================
  Widget _buildPickupTimeOptions() {
    return Column(
      children: [
        Row(
          children: [
            // ===== TOMBOL: SEGERA =====
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _isImmediate = true;
                  _pickupTime = null;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _isImmediate
                        ? primaryColor.withValues(alpha: 0.1)
                        : inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isImmediate ? primaryColor : dividerColor,
                      width: _isImmediate ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bolt,
                        color: _isImmediate ? primaryColor : Colors.grey,
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Segera',
                        style: TextStyle(
                          color: _isImmediate ? Colors.white : Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Udah di cafe',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ===== TOMBOL: PILIH JAM =====
            Expanded(
              child: GestureDetector(
                onTap: _pickPickupTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: !_isImmediate
                        ? primaryColor.withValues(alpha: 0.1)
                        : inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !_isImmediate ? primaryColor : dividerColor,
                      width: !_isImmediate ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: !_isImmediate ? primaryColor : Colors.grey,
                        size: 22,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih Jam',
                        style: TextStyle(
                          color: !_isImmediate ? Colors.white : Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Atur waktu',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // ===== INFO HASIL PILIHAN =====
        if (_isImmediate) ...[
          const SizedBox(height: 12),
          _buildPickupInfoBox(
            icon: Icons.bolt,
            text: 'Pesanan disiapkan segera. Ambil kapan saja di cafe.',
            color: primaryColor,
          ),
        ] else if (_pickupTime != null) ...[
          const SizedBox(height: 12),
          _buildPickupInfoBox(
            icon: Icons.event_available,
            text: 'Diambil ${_formatPickupTime(_pickupTime!)}',
            color: const Color(0xFF4CAF50),
            onEdit: _pickPickupTime,
          ),
        ],
      ],
    );
  }

  Widget _buildPickupInfoBox({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Ubah',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatPickupTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pickupDate = DateTime(dt.year, dt.month, dt.day);
    final diffDays = pickupDate.difference(today).inDays;

    final hourStr = dt.hour.toString().padLeft(2, '0');
    final minStr = dt.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minStr';

    if (diffDays == 0) return 'hari ini pukul $timeStr WIB';
    if (diffDays == 1) return 'besok pukul $timeStr WIB';
    return '${dt.day}/${dt.month}/${dt.year} pukul $timeStr WIB';
  }

  // ============================================
  // PICKUP INFO (banner atas)
  // ============================================
  Widget _buildPickupInfo(CartProvider cart) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: dividerColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: primaryColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AMBIL DI',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cart.cafeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: dividerColor),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pesanan disiapkan setelah kamu datang',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: dividerColor),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String name,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _metodeBayar == name;

    return GestureDetector(
      onTap: () => setState(() => _metodeBayar = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : inputBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.black, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dividerColor, width: 1),
      ),
      child: Column(
        children: [
          ...cart.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.item.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  'Rp ${item.subtotal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
          Container(height: 1, color: dividerColor),
          const SizedBox(height: 12),
          _summaryRow('Subtotal',
              'Rp ${cart.subtotal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
          const SizedBox(height: 8),
          _summaryRow('Biaya Layanan',
              'Rp ${CartProvider.serviceFee.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(top: BorderSide(color: dividerColor, width: 1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp ${cart.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: _isLoading ? null : _handleCheckout,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}