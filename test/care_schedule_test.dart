import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawly/models/models.dart';
import 'package:pawly/models/care_schedule.dart';
import 'package:pawly/repositories/pawly_repository.dart';

const pet = Pet(
    id: 'real',
    name: 'Pip',
    animalType: 'Cat',
    breed: 'Mixed',
    ageYears: 2,
    weightKg: 4,
    gender: 'Female',
    imageUrl: '');
CareRoutine routine(String recurrence, String date) => CareRoutine(
    id: 'routine',
    petId: pet.id,
    title: 'Breakfast',
    time: '08:00 AM',
    date: date,
    category: CareCategory.feeding,
    recurrence: recurrence);
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Recurrence respects start, weekly weekdays and end-of-month dates', () {
    expect(
        CareSchedule.isDue(
            routine('Daily', '2026-10-03'), DateTime(2026, 10, 2)),
        false);
    expect(
        CareSchedule.isDue(
            routine('Daily', '2026-10-03'), DateTime(2026, 10, 4)),
        true);
    expect(
        CareSchedule.isDue(
            routine('Weekly', '2026-10-03'), DateTime(2026, 10, 10)),
        true);
    expect(
        CareSchedule.isDue(
            routine('Weekly', '2026-10-03'), DateTime(2026, 10, 4)),
        false);
    expect(
        CareSchedule.isDue(
            routine('Monthly', '2026-01-31'), DateTime(2026, 2, 28)),
        true);
    expect(
        CareSchedule.isDue(
            routine('Every 30 days', '2026-10-03'), DateTime(2026, 11, 2)),
        true);
    expect(
        CareSchedule.isDue(
            routine('Once', '2026-10-03'), DateTime(2026, 10, 4)),
        false);
  });
  test('Time ordering understands midnight, noon and invalid times', () {
    expect(CareSchedule.minutes('12:00 AM'), 0);
    expect(CareSchedule.minutes('12:00 PM'), 720);
    expect(CareSchedule.minutes('08:30 PM'), 1230);
    expect(CareSchedule.minutes('23:59'), 1439);
    expect(CareSchedule.minutes('25:00'), 1440);
    expect(CareSchedule.minutes('08:70'), 1440);
  });
  test('Care completion survives restart without completing tomorrow',
      () async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.addPet(pet);
    final today = DateTime.now();
    await repo.addRoutine(routine(
        'Daily', CareSchedule.dayKey(today.subtract(const Duration(days: 1)))));
    await repo.toggleRoutine('routine');
    expect(repo.activePetRoutines.single.isCompleted, true);
    expect(
        repo
            .routinesForDate(today.add(const Duration(days: 1)))
            .single
            .isCompleted,
        false);
    final restored = PawlyRepository();
    await restored.init();
    expect(restored.activePetRoutines.single.isCompleted, true);
    await restored.toggleRoutine('routine');
    final reopened = PawlyRepository();
    await reopened.init();
    expect(reopened.activePetRoutines.single.isCompleted, false);
  });
  test('Demo entry preserves real records and invalid pet switching is ignored',
      () async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.addPet(pet);
    await repo.seedDemoData();
    expect(repo.pets.single.name, 'Pip');
    expect(repo.isDemoMode, false);
    repo.selectPet('missing');
    expect(repo.selectedPetId, 'real');
  });
  test(
      'Emergency details are isolated by pet and saved with documents and prep',
      () async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.addPet(pet);
    await repo.updateEmergencyCard(const EmergencyCardData(
        petId: 'real',
        emergencyContactName: 'Alex',
        emergencyPhone: '123',
        preferredVetName: '',
        preferredVetPhone: '',
        preferredClinic: 'Local vet'));
    await repo.addDocument(const DocumentItem(
        id: 'doc',
        petId: 'real',
        title: 'Clinic paperwork',
        category: 'Lab Result',
        dateAdded: '2026-10-03',
        fileType: 'Note'));
    await repo.addVetPrepItem(const VetPrepItem(
        id: 'prep', appointmentId: 'visit', text: 'Bring records'));
    await repo.toggleVetPrepItem('prep');
    await repo.addCaregiver(const CareCircleMember(
        id: 'sitter',
        name: 'Alex',
        role: 'Caregiver',
        email: '',
        phone: '123'));
    final restored = PawlyRepository();
    await restored.init();
    expect(restored.emergencyCard.emergencyContactName, 'Alex');
    expect(restored.activePetDocuments.single.title, 'Clinic paperwork');
    expect(restored.prepItemsForAppointment('visit').single.isChecked, true);
    expect(restored.careCircle.single.name, 'Alex');
    await restored.addPet(pet.copyWith(id: 'second', name: 'Bean'));
    expect(restored.emergencyCard.emergencyPhone, isEmpty);
  });
  test('Vaccine statuses follow due dates instead of a stored label', () {
    const vaccine = VaccinationRecord(
        id: 'v',
        petId: 'real',
        vaccineName: 'Booster',
        dateAdministered: '2025-10-03',
        nextDueDate: '2026-10-03',
        veterinarian: '',
        clinic: '',
        status: VaccineStatus.current);
    expect(vaccine.statusOn(DateTime(2026, 10, 4)), VaccineStatus.overdue);
    expect(vaccine.statusOn(DateTime(2026, 10, 3)), VaccineStatus.dueSoon);
    expect(vaccine.statusOn(DateTime(2026, 8, 1)), VaccineStatus.current);
  });
  test('Historical weigh-in does not replace the latest pet weight', () async {
    final repo = PawlyRepository();
    await repo.init();
    await repo.addPet(pet);
    await repo.addWeightEntry(const WeightEntry(
        id: 'new', petId: 'real', date: '2026-10-03', weightKg: 4.5));
    await repo.addWeightEntry(const WeightEntry(
        id: 'old', petId: 'real', date: '2026-09-03', weightKg: 3));
    expect(repo.activePet.weightKg, 4.5);
    expect(repo.activePetWeightHistory.first.id, 'new');
  });
}
