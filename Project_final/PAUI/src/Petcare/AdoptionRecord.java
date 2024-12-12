package Petcare;

import java.sql.*;

public class AdoptionRecord {
    private int petId;
    private boolean availableForAdoption;
    private String adoptionHistory;

    public AdoptionRecord(int petId, boolean availableForAdoption, String adoptionHistory) {
        this.petId = petId;
        this.availableForAdoption = availableForAdoption;
        this.adoptionHistory = adoptionHistory;
    }

    // Save adoption record to database
    public void saveAdoptionRecord() {
        String query = "INSERT INTO adoption_records (petId, availableForAdoption, adoptionHistory) VALUES (?, ?, ?)";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, this.petId);
            stmt.setBoolean(2, this.availableForAdoption);
            stmt.setString(3, this.adoptionHistory);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
