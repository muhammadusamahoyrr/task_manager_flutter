import 'dart:convert';
import 'package:demo/models1/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final String _storageKey = 'tasks';
  bool _isLoading = false;

  TaskProvider() {
    loadTasks();
  }

  bool get isLoading => _isLoading;
  List<Task> get tasks => [..._tasks];
  
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  
  int get totalTasks => _tasks.length;
  int get completedTasksCount => completedTasks.length;
  int get pendingTasksCount => pendingTasks.length;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_storageKey);
      
      if (tasksJson != null) {
        _tasks = tasksJson
            .map((taskJson) => Task.fromJson(json.decode(taskJson)))
            .toList();
        
        // Sort tasks by creation date (newest first)
        _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = _tasks
          .map((task) => json.encode(task.toJson()))
          .toList();
      
      await prefs.setStringList(_storageKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    // Sort tasks by creation date (newest first)
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
    await _saveTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    
    if (taskIndex >= 0) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
      await _saveTasks();
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    
    if (taskIndex >= 0) {
      final task = _tasks[taskIndex];
      _tasks[taskIndex] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
    await _saveTasks();
  }
  
  Future<void> deleteAllTasks() async {
    _tasks.clear();
    notifyListeners();
    await _saveTasks();
  }
  
  Future<void> deleteCompletedTasks() async {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
    await _saveTasks();
  }
}