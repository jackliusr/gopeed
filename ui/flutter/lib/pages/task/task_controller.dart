import 'dart:async';

import 'package:get/get.dart';

import '../../api/api.dart';
import '../../api/model/task.dart';

class TaskController extends GetxController {
  final tabIndex = 0.obs;
  final unDoneTasks = <Task>[].obs;
  final doneTasks = <Task>[].obs;

  var _lastUnDoneSize = 0;
  var _lastDoneSize = 0;

  late final Timer _timer;

  loadTab() async {
    if (tabIndex.value == 0) {
      if (await _loadUnDone()) {
        await _loadDone();
      }
    } else {
      if (await _loadDone()) {
        await _loadUnDone();
      }
    }
  }

  @override
  void onClose() {
    super.onClose();

    _timer.cancel();
  }

  @override
  void onInit() {
    super.onInit();

    loadTab();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      loadTab();
    });
  }

  _loadDone() async {
    doneTasks.value = await getTasks([Status.done]);
    final lastLastSize = _lastDoneSize;
    if (lastLastSize != doneTasks.length) {
      _lastDoneSize = doneTasks.length;
    }
    // when doneTasks.length increase, it means some task is done, refresh unDoneTasks
    return lastLastSize < _lastDoneSize;
  }

  _loadUnDone() async {
    unDoneTasks.value = await getTasks(
        [Status.ready, Status.running, Status.pause, Status.error]);
    final lastLastSize = _lastUnDoneSize;
    if (lastLastSize != unDoneTasks.length) {
      _lastUnDoneSize = unDoneTasks.length;
    }
    // when unDoneTasks.length reduce, it means some task is done, refresh doneTasks
    return lastLastSize > _lastUnDoneSize;
  }
}
