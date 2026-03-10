int nextProcessDay(int currentDay) {
  if (currentDay <= 0) return 1;
  if (currentDay >= 3) return 3;
  return currentDay + 1;
}

int restartProcessDay() {
  return 0;
}

bool canContinueProcess(int currentDay) {
  return currentDay > 0 && currentDay < 3;
}

bool canRestartProcess(int currentDay) {
  return currentDay > 0;
}

bool canStartProcess(int currentDay) {
  return currentDay == 0;
}