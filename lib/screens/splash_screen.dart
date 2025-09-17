import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
    
    // Navigate after delay
    _navigateToNextScreen();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 100));
    _rotateController.forward();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Check auth status and navigate accordingly
      Widget nextScreen;
      if (authProvider.isSignedIn) {
        nextScreen = const DashboardScreen();
      } else {
        nextScreen = const LoginScreen();
      }
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF0D1421),
                    const Color(0xFF1A2332),
                    const Color(0xFF2A3441),
                    const Color(0xFF6BB6FF).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFF1A237E),
                    const Color(0xFF283593),
                    const Color(0xFF3949AB),
                    const Color(0xFF5C6BC0),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo container
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _fadeAnimation,
                    _scaleAnimation,
                    _rotateAnimation,
                  ]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value * 0.1,
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode 
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 25,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: isDarkMode 
                                      ? const Color(0xFF6BB6FF).withOpacity(0.3)
                                      : Colors.white.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.directions_bus,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // App title with animation
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeOutBack,
                        )),
                        child: Column(
                          children: [
                            Text(
                              'Bus Driver',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.6),
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                  Shadow(
                                    color: isDarkMode 
                                        ? const Color(0xFF6BB6FF).withOpacity(0.3)
                                        : Colors.white.withOpacity(0.3),
                                    offset: const Offset(0, 0),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Track • Navigate • Connect',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 60),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkMode 
                                    ? const Color(0xFF6BB6FF)
                                    : Colors.white,
                              ),
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}