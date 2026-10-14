package Petcare;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Pet {
    private String name;
    private int age;
    private String animalType;
    private String category;
    private java.sql.Date lastCheckup;
    private java.sql.Date lastVaccination;
    private String disease;

    // Constructor
    public Pet(String name, int age, String animalType, String category, java.sql.Date lastCheckup, java.sql.Date lastVaccination, String disease) {
        this.name = name;
        this.age = age;
        this.animalType = animalType;
        this.category = category;
        this.lastCheckup = lastCheckup;
        this.lastVaccination = lastVaccination;
        this.disease = disease;
    }

    // Save pet to database
    public void saveToDatabase() {
        String query = "INSERT INTO pets (name, age, animalType, category, lastCheckup, lastVaccination, disease) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, this.name);
            stmt.setInt(2, this.age);
            stmt.setString(3, this.animalType);
            stmt.setString(4, this.category);
            stmt.setDate(5, this.lastCheckup);
            stmt.setDate(6, this.lastVaccination);
            stmt.setString(7, this.disease);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // View pets from database
    public static void viewPetsFromDatabase() {
        String query = "SELECT * FROM pets";
        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") +
                        ", Name: " + rs.getString("name") +
                        ", Age: " + rs.getInt("age") +
                        ", Animal: " + rs.getString("animalType") +
                        ", Category: " + rs.getString("category") +
                        ", Last Check-up: " + rs.getDate("lastCheckup") +
                        ", Last Vaccination: " + rs.getDate("lastVaccination") +
                        ", Disease: " + rs.getString("disease"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update pet information in the database
    public static void updatePetInDatabase(int petId, String newName, int newAge) {
        String query = "UPDATE pets SET name = ?, age = ? WHERE id = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, newName);
            stmt.setInt(2, newAge);
            stmt.setInt(3, petId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
