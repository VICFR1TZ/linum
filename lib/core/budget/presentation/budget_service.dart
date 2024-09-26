import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/budget/domain/enums/budget_change_mode.dart';
import 'package:linum/core/budget/domain/models/budget.dart';
import 'package:linum/core/budget/domain/models/main_budget.dart';

abstract class IBudgetService extends IProvidableService {
  Future<List<Budget>> getBudgetsForDate(DateTime date);
  Future<Budget> createBudget(Budget budget);
  Future<void> updateBudget(Budget old, Budget update, DateTime selectedDate, BudgetChangeMode changeMode);
  Future<void> deleteBudget(Budget budget, DateTime selectedDate, BudgetChangeMode changeMode);

  Future<MainBudget?> getMainBudgetForDate(DateTime date);
  Future<MainBudget> createMainBudget(MainBudget budget);
  Future<void> updateMainBudget(MainBudget old, MainBudget update, DateTime selectedDate, BudgetChangeMode changeMode);
  Future<void> deleteMainBudget(MainBudget budget, DateTime selectedDate, BudgetChangeMode changeMode);
}
