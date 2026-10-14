import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/helpers.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialTab = Get.find<HomeController>().selectedTab;
    _pageController = PageController(initialPage: initialTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    Get.find<HomeController>().setTab(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await AppHelpers.showLogoutConfirmationDialog(context: context);
    if (shouldLogout != true) return;

    if (!mounted) return;
    AppHelpers.showLoadingDialog('Sedang keluar...');
    try {
      await Get.find<AuthController>().logout();
    } finally {
      AppHelpers.hideLoadingDialog();
    }

    if (!mounted) return;
    Get.offAllNamed(Routes.login);
  }

  String _getInitial(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    return name.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final user = authController.currentUser;
      final selectedTab = homeController.selectedTab;

      return Scaffold(
      backgroundColor: const Color(0xFFFAFAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        toolbarHeight: 74,
        title: Row(
          children: [
            // Logo Container Card
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const Gap(12),

            // Greeting & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'Halo, '),
                        TextSpan(
                          text: user?.displayName.toUpperCase() ?? 'LAKSANA',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(3),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      const Gap(4),
                      Text(
                        'Selasa, 01 September 2026',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF64748B),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    Gap(10),
                    Text(
                      'Keluar Akun',
                      style: TextStyle(color: AppColors.error, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(8),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          homeController.setTab(index);
        },
        physics: const BouncingScrollPhysics(),
        children: [
          _buildDashboardTab(user),
          _buildLaporanHarianTab(),
          _buildLaporanFunnelTab(),
          _buildProfilTab(user),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Stack(
              children: [
                // Animated sliding active indicator bar
                AnimatedAlign(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment(-1.0 + (selectedTab * (2.0 / 3.0)), -1.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.25,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 3,
                        width: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Navigation items
                Row(
                  children: [
                    _buildNavItem(
                      index: 0,
                      currentIndex: selectedTab,
                      label: 'Dashboard',
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                    ),
                    _buildNavItem(
                      index: 1,
                      currentIndex: selectedTab,
                      label: 'Laporan\nHarian',
                      icon: Icons.assignment_outlined,
                      selectedIcon: Icons.assignment,
                    ),
                    _buildNavItem(
                      index: 2,
                      currentIndex: selectedTab,
                      label: 'Laporan\nFunnel',
                      icon: Icons.filter_alt_outlined,
                      selectedIcon: Icons.filter_alt,
                    ),
                    _buildNavItem(
                      index: 3,
                      currentIndex: selectedTab,
                      label: 'Profil',
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    });
  }

  Widget _buildDashboardTab(UserEntity? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card 1: Alert / Announcement Banner (Full Width)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFCE8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFEF08A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFEAB308),
                  size: 20,
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    'Silakan lakukan check-in untuk mencatat kehadiran Anda hari ini',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: const Color(0xFF4B5563),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms),
          const Gap(14),

          // Card 2: Status Kehadiran (Full Width)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xFF007A5E),
                    size: 22,
                  ),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Kehadiran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Belum Check In',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007A5E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Check In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),
          const Gap(20),

          // Section Header: "Dashboard"
          Text(
            'Dashboard',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 350.ms),
          const Gap(12),

          // Card 3: Total Kehadiran (Full Width)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF9CA3AF),
                      size: 24,
                    ),
                    const Spacer(),
                    _buildPillBadge('Check In: 14', isPrimary: false),
                  ],
                ),
                const Gap(6),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildPillBadge('Check Out: 12', isPrimary: false),
                ),
                const Gap(6),
                Text(
                  '14 Hari',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const Gap(2),
                Text(
                  'Total Kehadiran',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 350.ms),
          const Gap(12),

          // Card 4: Laporan Harian Hari Ini (Full Width)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: Color(0xFF9CA3AF),
                      size: 24,
                    ),
                    const Spacer(),
                    _buildPillBadge('Draft: 1', isPrimary: false),
                  ],
                ),
                const Gap(6),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildPillBadge('Selesai: 2', isPrimary: true),
                ),
                const Gap(6),
                Text(
                  '3',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const Gap(2),
                Text(
                  'Laporan Harian Hari Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 350.ms),
          const Gap(12),

          // Card 5: Laporan Funnel (Full Width)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF9CA3AF),
                  size: 24,
                ),
                const Gap(18),
                Text(
                  '0',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const Gap(2),
                Text(
                  'Laporan Funnel',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildLaporanHarianTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const Gap(16),
            Text(
              'Laporan Harian',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              'Kelola dan pantau aktivitas laporan harian Anda di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaporanFunnelTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const Gap(16),
            Text(
              'Laporan Funnel',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              'Pantau progres funnel dan prospek penjualan Anda di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilTab(UserEntity? user) {
    final role = user?.role;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary.withAlpha(25),
                  child: Text(
                    _getInitial(user?.name),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Gap(12),
                Text(
                  user?.displayName ?? 'Pengguna MMS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(4),
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (role != null && role.isNotEmpty) ...[
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Gap(16),
          if (user?.provinceName != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 20),
                  const Gap(10),
                  Text(
                    'Wilayah Kerja',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    user!.provinceName!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
          ],
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text(
                'Keluar Akun',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final isSelected = index == currentIndex;
    const activeColor = AppColors.primary;
    const inactiveColor = Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelected(index),
        splashColor: AppColors.primary.withAlpha(20),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  size: 22,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              const Gap(4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? activeColor : const Color(0xFF64748B),
                  height: 1.1,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillBadge(String text, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          color: isPrimary ? const Color(0xFF059669) : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
