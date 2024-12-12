package Petcare;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        boolean running = true;
        while (running) {
            // Display menu
            System.out.println("\n=== Pet Care App Menu ===");
            System.out.println("1. Add Pet");
            System.out.println("2. Add Reminder");
            System.out.println("3. Add Appointment");
            System.out.println("4. View Pet Details");
            System.out.println("5. Check Reminders/Appointments");
            System.out.println("6. Update Pet Info");
            System.out.println("7. Manage Adoption Records");
            System.out.println("8. Delete Record");
            System.out.println("0. Exit");

            System.out.print("Enter your choice: ");
            int choice = getValidChoice(scanner);

            switch (choice) {
                case 1 -> addPet(scanner);
                case 2 -> addReminder(scanner);
                case 3 -> addAppointment(scanner);
                case 4 -> viewPets();
                case 5 -> checkRemindersAndAppointments(scanner);
                case 6 -> updatePetInfo(scanner);
                case 7 -> manageAdoptionRecords(scanner);
                case 8 -> deleteRecord(scanner);
                case 0 -> {
                    System.out.println("Exiting program.");
                    running = false;  // Exit the loop and terminate program
                }
                default -> System.out.println("Invalid choice. Please enter a valid option.");
            }
        }

        scanner.close();
    }

    private static int getValidChoice(Scanner scanner) {
        while (!scanner.hasNextInt()) {
            System.out.println("Invalid input. Please enter a number.");
            scanner.next(); // Consume the invalid input
        }
        return scanner.nextInt();
    }

    // Helper method for valid date input
    private static LocalDate getValidDateInput(Scanner scanner, String prompt) {
        LocalDate date = null;
        while (date == null) {
            System.out.print(prompt);
            String dateInput = scanner.next();
            try {
                date = LocalDate.parse(dateInput);
            } catch (Exception e) {
                System.out.println("Invalid date format. Please use YYYY-MM-DD.");
            }
        }
        return date;
    }

    // Helper method for valid time input
    private static String getValidTimeInput(Scanner scanner, String prompt) {
        String time = "";
        while (true) {
            System.out.print(prompt);
            time = scanner.nextLine();
            if (time.matches("\\d{2}:\\d{2}:\\d{2}")) {
                break;
            } else {
                System.out.println("Invalid time format. Please use HH:mm:ss.");
            }
        }
        return time;
    }

    // Add a new pet
    private static void addPet(Scanner scanner) {
        System.out.print("Enter Pet Name: ");
        String name = scanner.next();
        System.out.print("Enter Pet Age: ");
        int age = scanner.nextInt();
        System.out.print("Enter Animal Type (e.g., Dog, Cat): ");
        String animal = scanner.next();
        System.out.print("Enter Category (e.g., Breed, Stray): ");
        String category = scanner.next();

        // Input and validate last check-up date
        LocalDate lastCheckup = getValidDateInput(scanner, "Last Check-up Date (YYYY-MM-DD): ");

        // Input and validate last vaccination date
        LocalDate lastVaccination = getValidDateInput(scanner, "Last Vaccination Date (YYYY-MM-DD): ");

        System.out.print("Enter Disease (or 'None'): ");
        String disease = scanner.next();

        // Convert LocalDate to java.sql.Date
        java.sql.Date sqlLastCheckup = java.sql.Date.valueOf(lastCheckup);
        java.sql.Date sqlLastVaccination = java.sql.Date.valueOf(lastVaccination);

        // Assuming Pet class and saveToDatabase method exist
        Pet pet = new Pet(name, age, animal, category, sqlLastCheckup, sqlLastVaccination, disease.equals("None") ? null : disease);
        pet.saveToDatabase();

        System.out.println("Pet added successfully!");
    }

    private static void addReminder(Scanner scanner) {
        try (Connection connection = DatabaseConnection.getConnection()) {  // Get connection
            System.out.print("Enter Pet ID for reminder: ");
            int petId = scanner.nextInt();

            System.out.println("Reminder Type: 1. Feeding  2. Walking");
            int reminderType = getValidChoice(scanner);

            System.out.print("Enter Reminder Schedule (e.g., 2024-12-15): ");
            LocalDate schedule = getValidDateInput(scanner, "Enter Schedule Date (YYYY-MM-DD): ");

            String suggestion = "";
            if (reminderType == 1) {
                System.out.print("Enter suggested feeding grams for the pet: ");
                int grams = scanner.nextInt();
                suggestion = "Suggested Feeding Grams: " + grams + "g";
            } else if (reminderType == 2) {
                System.out.print("Enter suggested walking time (in minutes): ");
                int minutes = scanner.nextInt();
                suggestion = "Suggested Walking Time: " + minutes + " minutes";
            }

            // Create a Reminder object
            Reminder reminder = new Reminder(petId, java.sql.Date.valueOf(schedule), suggestion);

            // Pass the connection to save the reminder to the database
            reminder.saveReminderToDatabase(connection);  // Now passing the connection

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Add an appointment
    private static void addAppointment(Scanner scanner) {
        System.out.print("Enter Pet ID: ");
        int petId = getValidChoice(scanner);

        LocalDate appointmentDate = getValidDateInput(scanner, "Enter Appointment Date (YYYY-MM-DD): ");
        String appointmentTime = getValidTimeInput(scanner, "Enter Appointment Time (HH:mm:ss): "); // Use valid time input
        System.out.print("Enter Appointment Purpose (vaccination or check-up): ");
        String purpose = scanner.nextLine();

        // Create an Appointment object with the provided details
        Appointment appointment = new Appointment(petId, appointmentDate, appointmentTime, purpose);

        // Save the appointment to the database
        appointment.saveAppointmentToDatabase();
        System.out.println("Appointment added successfully!");
    }

    // View pet details
    private static void viewPets() {
        // Display pet details from the database
        Pet.viewPetsFromDatabase();  // Updated method name
    }

    // Check reminders and appointments
    private static void checkRemindersAndAppointments(Scanner scanner) {
        System.out.println("1. Check Reminders  2. Check Appointments");
        int choice = getValidChoice(scanner);

        if (choice == 1) {
            // Assuming Reminder class and fetchRemindersFromDatabase method exist
            Reminder.displayRemindersFromDatabase();
        } else if (choice == 2) {
            // Assuming Appointment class and fetchAppointmentsFromDatabase method exist
            Appointment.displayAppointmentsFromDatabase();
        } else {
            System.out.println("Invalid choice. Please try again.");
        }
    }

    // Update pet information
    private static void updatePetInfo(Scanner scanner) {
        System.out.print("Enter Pet ID to update: ");
        int petId = scanner.nextInt();

        System.out.print("Enter new name (or press Enter to skip): ");
        scanner.nextLine(); // Consume the remaining newline
        String newName = scanner.nextLine();

        // Add more fields as needed, such as age, animal type, etc.
        System.out.print("Enter new age (or 0 to skip): ");
        int newAge = scanner.nextInt();

        // Assuming Pet class and updatePetInDatabase method exist
        Pet.updatePetInDatabase(petId, newName, newAge);

        System.out.println("Pet information updated.");
    }

    // Manage adoption records
    private static void manageAdoptionRecords(Scanner scanner) {
        System.out.print("Enter Pet ID for adoption record: ");
        int petId = scanner.nextInt();

        System.out.print("Is the pet available for adoption? (yes/no): ");
        String availableForAdoption = scanner.next().toLowerCase();

        System.out.print("Enter adoption history (or 'None'): ");
        scanner.nextLine();  // Consume newline
        String adoptionHistory = scanner.nextLine();

        // Assuming AdoptionRecord class and saveAdoptionRecord method exist
        AdoptionRecord adoptionRecord = new AdoptionRecord(petId, availableForAdoption.equals("yes"), adoptionHistory);
        adoptionRecord.saveAdoptionRecord();

        System.out.println("Adoption record managed successfully.");
    }

    // Delete a record
    private static void deleteRecord(Scanner scanner) {
        System.out.println("=== Delete Record ===");
        System.out.println("1. Delete Pet");
        System.out.println("2. Delete Reminder");
        System.out.println("3. Delete Appointment");
        System.out.print("Enter choice to delete (1/2/3): ");
        int deleteChoice = getValidChoice(scanner);

        switch (deleteChoice) {
            case 1 -> {
                System.out.print("Enter Pet ID to delete: ");
                int petId = scanner.nextInt();
                deleteFromDatabase("pets", petId);
            }
            case 2 -> {
                System.out.print("Enter Reminder ID to delete: ");
                int reminderId = scanner.nextInt();
                deleteFromDatabase("reminders", reminderId);
            }
            case 3 -> {
                System.out.print("Enter Appointment ID to delete: ");
                int appointmentId = scanner.nextInt();
                deleteFromDatabase("appointments", appointmentId);
            }
            default -> System.out.println("Invalid option.");
        }
    }

    private static void deleteFromDatabase(String table, int id) {
        String query = "DELETE FROM " + table + " WHERE id = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
            System.out.println("Record deleted successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
