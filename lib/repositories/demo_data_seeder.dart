import 'pawly_repository.dart';
import 'sample_data.dart';

/// Explicit seeder for portfolio demo exploration.
/// Real users start with a clean, empty account.
/// Demo mode is only activated when explicitly requested via "Explore Demo".
class DemoDataSeeder {
  DemoDataSeeder._();

  static Future<void> seed(PawlyRepository repository) async {
    // Seed sample pets
    for (final pet in SampleData.initialPets) {
      await repository.addPet(pet);
    }

    // Seed sample care routines
    for (final routine in SampleData.initialRoutines) {
      await repository.addCareRoutine(routine);
    }

    // Seed sample health records
    for (final event in SampleData.initialHealthEvents) {
      await repository.addHealthEvent(event);
    }

    // Seed sample weight entries
    for (final weight in SampleData.initialWeightHistory) {
      await repository.addWeightRecord(weight);
    }

    // Seed sample vaccinations
    for (final vac in SampleData.initialVaccinations) {
      await repository.addVaccination(vac);
    }

    // Seed sample medications
    for (final med in SampleData.initialMedications) {
      await repository.addMedication(med);
    }

    // Seed sample appointments
    for (final appt in SampleData.initialAppointments) {
      await repository.addAppointment(appt);
    }

    // Seed sample memories
    for (final memory in SampleData.initialMemories) {
      await repository.addMemory(memory);
    }

    // Seed sample daily notes
    for (final note in SampleData.initialSymptomNotes) {
      await repository.addSymptomNote(note);
    }

    await repository.setDemoMode(true);
  }
}
