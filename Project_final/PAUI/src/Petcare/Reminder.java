package Petcare;

import java.sql.*;

public class Reminder {
    private int petId;
    private java.sql.Date scheduleDate;
    private String suggestion;

    // Constructor
    public Reminder(int petId, java.sql.Date scheduleDate, String suggestion) {
        this.petId = petId;
        this.scheduleDate = scheduleDate;
        this.suggestion = suggestion;
    }

    // Save the reminder to the database
    public void saveReminderToDatabase(Connection connection) {
        String query = "INSERT INTO reminders (pet_id, schedule_date, suggestion) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, petId);
            stmt.setDate(2, scheduleDate);
            stmt.setString(3, suggestion);

            stmt.executeUpdate();
            System.out.println("Reminder added successfully!");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error while saving reminder to database.");
        }
    }

    // Fetch and display all reminders from the database
    public static void displayRemindersFromDatabase() {
        String query = "SELECT * FROM reminders";
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                int petId = rs.getInt("pet_id");
                Date scheduleDate = rs.getDate("schedule_date");
                String suggestion = rs.getString("suggestion");

                System.out.println("Pet ID: " + petId + ", Schedule: " + scheduleDate + ", Suggestion: " + suggestion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error while fetching reminders from database.");
        }
    }
}
