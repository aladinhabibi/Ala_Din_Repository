import 'dart:isolate';
import 'dart:math';

// Data class to pass parameters to isolate
class PrimeRangeTask {
  final int start;
  final int end;
  final SendPort sendPort;

  PrimeRangeTask(this.start, this.end, this.sendPort);
}

// Check if a number is prime
bool isPrime(int n) {
  if (n < 2) return false;
  if (n == 2) return true;
  if (n % 2 == 0) return false;

  for (int i = 3; i <= sqrt(n); i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

// Isolate entry point function
void primeWorker(PrimeRangeTask task) {
  int sum = 0;
  for (int i = task.start; i <= task.end; i++) {
    if (isPrime(i)) {
      sum += i;
    }
  }
  task.sendPort.send(sum);
}

// Calculate sum of primes using isolates
Future<int> calculatePrimeSumWithIsolates(int n, {int numIsolates = 4}) async {
  if (n < 2) return 0;

  List<ReceivePort> receivePorts = [];
  List<Isolate> isolates = [];

  int rangeSize = (n / numIsolates).ceil();

  // Create isolates and distribute work
  for (int i = 0; i < numIsolates; i++) {
    int start = i * rangeSize + 1;
    int end = min((i + 1) * rangeSize, n);

    if (start > n) break;

    ReceivePort receivePort = ReceivePort();
    receivePorts.add(receivePort);

    Isolate isolate = await Isolate.spawn(
      primeWorker,
      PrimeRangeTask(start, end, receivePort.sendPort),
    );
    isolates.add(isolate);
  }

  // Collect results from all isolates
  int totalSum = 0;
  for (ReceivePort port in receivePorts) {
    int partialSum = await port.first;
    totalSum += partialSum;
  }

  // Clean up isolates
  for (Isolate isolate in isolates) {
    isolate.kill();
  }

  return totalSum;
}

void main() async {
  // Write a program calculating a sum of all prime numbers from 1 to N using
  // [Isolate]s to speed up the algorithm.

  const int n = 10000;

  print('Calculating sum of prime numbers from 1 to $n using isolates...');

  final stopwatch = Stopwatch()..start();
  int sum = await calculatePrimeSumWithIsolates(n);
  stopwatch.stop();

  print('Sum of prime numbers from 1 to $n: $sum');
  print('Time taken: ${stopwatch.elapsedMilliseconds} ms');

  // Compare with single-threaded approach
  print('\nComparing with single-threaded approach...');
  final stopwatch2 = Stopwatch()..start();
  int singleThreadSum = 0;
  for (int i = 1; i <= n; i++) {
    if (isPrime(i)) {
      singleThreadSum += i;
    }
  }
  stopwatch2.stop();

  print('Single-threaded sum: $singleThreadSum');
  print('Single-threaded time: ${stopwatch2.elapsedMilliseconds} ms');
  print(
    'Speedup: ${(stopwatch2.elapsedMilliseconds / stopwatch.elapsedMilliseconds).toStringAsFixed(2)}x',
  );
}
