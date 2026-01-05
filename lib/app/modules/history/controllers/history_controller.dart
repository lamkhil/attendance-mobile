import 'package:get/get.dart';
import 'package:absensi/app/data/models/attendance.dart';
import 'package:absensi/app/data/services/attendance_services.dart';
import 'package:flutter/material.dart';

class HistoryController extends GetxController
    with StateMixin<List<Attendance>> {
  final RxList<Attendance> _attendances = <Attendance>[].obs;
  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;

  List<Attendance> get attendances => _attendances;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceHistory();

    // Listen scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          canLoadMore &&
          !_isLoadingMore) {
        loadMore();
      }
    });
  }

  /// Fetch awal / load more
  void fetchAttendanceHistory({
    int page = 1,
    bool isLoadMore = false,
    bool reset = false,
  }) async {
    if (isLoadMore) _isLoadingMore = true;
    if (!isLoadMore) change(null, status: RxStatus.loading());
    if (reset) {
      _attendances.clear();
      _currentPage = 1;
      _lastPage = 1;
    }

    final result = await AttendanceServices.getAttendances(page: page);

    if (!result.success) {
      if (!isLoadMore) {
        change(
          null,
          status: RxStatus.error(result.message ?? 'Gagal mengambil data'),
        );
      }
    } else {
      _currentPage = page;
      _lastPage = result.pagination?.lastPage ?? page;

      if (isLoadMore) {
        _attendances.addAll(result.data ?? []);
        _isLoadingMore = false;
      } else {
        _attendances.assignAll(result.data ?? []);
      }

      change(_attendances, status: RxStatus.success());

      if (_attendances.isEmpty) {
        change(_attendances, status: RxStatus.empty());
      }
    }
  }

  /// Cek apakah masih bisa load next page
  bool get canLoadMore => _currentPage < _lastPage;

  /// Load halaman berikutnya
  void loadMore() {
    if (canLoadMore && !_isLoadingMore) {
      fetchAttendanceHistory(page: _currentPage + 1, isLoadMore: true);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
