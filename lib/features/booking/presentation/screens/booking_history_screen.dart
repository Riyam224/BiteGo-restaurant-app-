import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/booking/data/models/booking_model.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/booking_history_card.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  // Sample booking data
  List<BookingModel> get _bookings => [
        BookingModel(
          id: '1',
          restaurantName: 'Ambrosia Hotel & Restaurant',
          date: 'Today',
          time: '10:00 AM - 08:00 PM',
          status: 'Active',
          imageUrl:
              'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg',
        ),
        BookingModel(
          id: '2',
          restaurantName: 'Tava Restaurant',
          date: 'Tomorrow',
          time: '12:00 PM - 10:00 PM',
          status: 'Pending',
          imageUrl:
              'https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg',
        ),
        BookingModel(
          id: '3',
          restaurantName: 'Haatkhola',
          date: 'Yesterday',
          time: '11:00 AM - 09:00 PM',
          status: 'Completed',
          imageUrl:
              'https://images.pexels.com/photos/3201921/pexels-photo-3201921.jpeg',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Booking History',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textWhite,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // Bookings List
            Expanded(
              child: _bookings.isEmpty
                  ? _EmptyBookings()
                  : ListView.builder(
                      itemCount: _bookings.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final booking = _bookings[index];
                        return BookingHistoryCard(
                          booking: booking,
                          onTap: () {
                            debugPrint('Tapped on booking: ${booking.id}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 80.sp,
            color: AppColors.getTextSecondary(context).withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No bookings yet',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start booking restaurants to see them here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
