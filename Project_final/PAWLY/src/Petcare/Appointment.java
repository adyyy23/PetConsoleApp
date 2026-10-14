package Petcare;

import java.sql.*;
import java.time.LocalDate;

public class Appointment {
    private int petId;
    private LocalDate appointmentDate;
    private String appointmentTime;
    private String purpose;

    public Appointment(int petId, LocalDate appointmentDate, String appointmentTime, String purpose) {
        this.petId = petId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.purpose = purpose;
    }

    // Save appointment to database
    public void saveAppointmentToDatabase() {
        String query = "INSERT INTO appointments (petId, appointmentDate, appointmentTime, purpose) VALUES (?, ?, ?, ?)";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, this.petId);
            stmt.setDate(2, java.sql.Date.valueOf(this.appointmentDate));
            stmt.setString(3, this.appointmentTime);
            stmt.setString(4, this.purpose);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Display appointments from database
    public static void displayAppointmentsFromDatabase() {
        String query = "SELECT * FROM appointments";
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") +
                        ", Pet ID: " + rs.getInt("petId") +
                        ", Appointment Date: " + rs.getDate("appointmentDate") +
                        ", Time: " + rs.getString("appointmentTime") +
                        ", Purpose: " + rs.getString("purpose"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
