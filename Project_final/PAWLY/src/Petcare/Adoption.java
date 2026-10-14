package Petcare;

import java.sql.*;

public class Adoption {
    private int petId;
    private String status; // "Available", "Adopted", or "Removed"
    private String history; // Additional information about the pet's adoption record

    public Adoption(int petId, String status, String history) {
        this.petId = petId;
        this.status = status;
        this.history = history;
    }

    // Save adoption record to the database
    public void saveToDatabase() {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String query = "INSERT INTO adoption_records (pet_id, status, history) VALUES (?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, petId);
            stmt.setString(2, status);
            stmt.setString(3, history);
            stmt.executeUpdate();
            System.out.println("Adoption record saved successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update the adoption status
    public void updateStatus(String newStatus) {
        try (Connection connection = DatabaseConnection.getConnection()) {
            String query = "UPDATE adoption_records SET status = ? WHERE pet_id = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, newStatus);
            stmt.setInt(2, petId);
            stmt.executeUpdate();
            System.out.println("Adoption status updated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
