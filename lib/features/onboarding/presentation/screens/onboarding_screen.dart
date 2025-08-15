// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paganini_wallet/core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo({
    required this.title,
    required this.caption,
    required this.imageUrl,
  });
}

final slides = <SlideInfo>[
  SlideInfo(
    title: 'Paga sin complicaciones',
    caption:
        "Realiza tus pagos directamente y sin problemas utilizando códigos QR.",
    imageUrl: 'assets/img/tutorial/7.png',
  ),
  SlideInfo(
    title: "Tu billetera, tu estilo",
    caption:
        "Administra tu billetera digital y personalízala a tu gusto de forma fácil.",
    imageUrl: 'assets/img/tutorial/4.png',
  ),
  SlideInfo(
    title: 'Pagos a tu alcance',
    caption:
        "Utiliza diferentes métodos de pago y realiza transacciones en pocos pasos.",
    imageUrl: 'assets/img/tutorial/5.png',
  ),
  SlideInfo(
    title: 'Rápido y Sencillo',
    caption:
        "Una app sencilla, rápida y diseñada para que ahorres tiempo al pagar.",
    imageUrl: 'assets/img/tutorial/1.png',
  ),
];

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  bool isLastPage = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != currentPage) {
        setState(() {
          currentPage = page;
          isLastPage = currentPage == slides.length - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    GoRouter.of(context).go('/login');
  }

  void _goToNextPage() {
    if (isLastPage) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Botón Saltar
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(
                      color: Color(0xFF6A14F0),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Contenido
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(slideInfo: slides[index]);
                  },
                ),
              ),

              // Indicador
              SmoothPageIndicator(
                controller: _pageController,
                count: slides.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xFF6A14F0),
                  dotColor: Color(0xFFD9D0F5),
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 4,
                  expansionFactor: 3,
                ),
              ),

              const SizedBox(height: 30),

              // Botón Siguiente/Iniciar
              ElevatedButton(
                onPressed: _goToNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isLastPage ? 'Iniciar' : 'Siguiente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final SlideInfo slideInfo;

  const OnboardingPage({
    Key? key,
    required this.slideInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 60,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D0F5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 30,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F78F6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Image.asset(
                slideInfo.imageUrl,
                fit: BoxFit.contain,
                height: 240,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Text(
          slideInfo.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          slideInfo.caption,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
