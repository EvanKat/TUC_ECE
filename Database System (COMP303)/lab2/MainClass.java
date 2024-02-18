package tuc.ece.jdbc_main;

import java.sql.*;
import java.util.Random;

public class MainClass {
    Connection conn;

    public MainClass() {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver found");
        }catch (ClassNotFoundException e){
//            e.printStackTrace();
            System.out.println("Driver not found");
        }
    }

    public void dbConnect(String host, String dbName, String username, String password) {
        try {
            int port = 5432;
            String postgresURL = "jdbc:postgresql://" + host + ":" + port + "/" + dbName;
            // connect to db
            conn = DriverManager.getConnection(postgresURL, username, password);
            System.out.println("Successfully connected to " + dbName);
        }catch (SQLException e){
            System.out.println("Error connecting to " + dbName);
        }
    }

    public void dbClose() {
        try{
            conn.close();
        }catch (SQLException e) {
            System.out.println("Error closing connection");
            e.printStackTrace();
        }
    }

    public void semester_lab_grade_12(String amka, String academic_season, Integer academic_year) {

        String query =
                "SELECT j.amka, name, surname, title, wg.grade " +
                "From \"Semester\" se " +
                "INNER JOIN " +
                "\"CourseRun\" cr " +
                "ON semester_id = semesterrunsin " +
                "NATURAL JOIN " +
                "\"LabModule\" lm " +
                "NATURAL JOIN " +
                "\"Workgroup\" wg " +
                "NATURAL JOIN " +
                "\"Joins\" j " +
                "INNER JOIN " +
                "\"Person\" p " +
                "ON j.amka = p.amka " +
                "WHERE academic_year = ? and academic_season = ?::semester_season_type and j.amka = ? ";

        try {
            // declare statement
            PreparedStatement pst = conn.prepareStatement(query);

            // set variables
            pst.setInt(1, academic_year);
            pst.setString(2, academic_season);
            pst.setString(3, amka);

            // declare query
            ResultSet rs = pst.executeQuery();

            ResultSetMetaData rsmd = rs.getMetaData();

            // Print headers
            System.out.println();
            System.out.print(rsmd.getColumnName(1) + "\t");
            System.out.print(rsmd.getColumnName(2) + "\t");
            System.out.print(rsmd.getColumnName(3) + "\t");
            System.out.print(rsmd.getColumnName(4) + "\t");
            System.out.println(rsmd.getColumnName(5));

            // print query results
            while (rs.next()) {
                System.out.print(rs.getString(1) + " ");
                System.out.print(rs.getString(2) + " ");
                System.out.print(rs.getString(3) + " ");
                System.out.print(rs.getString(4) + " ");
                System.out.println(rs.getInt(5));
            }

            pst.close();
        } catch (SQLException e){
            System.out.println("Error executing guery");
            e.printStackTrace();
        }

    }

    public void add_new_LabModule_13(String course_code, int serial_number, int num_of_lm, int max_teams) {
        Random rand = new Random();

        // i
        double prob_project = 0.2;
        double prob_lab_exercise = 0.8;
        // ii
        int min_members = 2;
        int max_members = 6;
        // iii
        double standard_deviation = 2.0;
        double mean = 6.0;
        int grade_min = 0;
        int grade_max = 10;


        // sql queries
        String lm_query =
                "INSERT INTO \"LabModule\" (module_no, serial_number, course_code, percentage, max_members, title, type) " +
                "values(?, ?, ?, ?, ?, ?, ?::\"labmodule_type\");";

        String wg_query =
                "INSERT INTO \"Workgroup\" (\"wgID\", module_no, serial_number, course_code, grade) " +
                "values(?, ?, ?, ?, ?);";

        String j_query =
                "insert into \"Joins\" (\"wgID\", module_no, course_code, serial_number, amka) " +
                        "select  ( ((row_number() over (order by random())) + ? - 1) / ? )::integer, lm.module_no, lm.course_code, lm.serial_number, r.amka " +
                        "from \"Register\" r, \"LabModule\" lm " +
                        "where lm.module_no = ? and r.register_status = 'approved' and r.course_code = lm.course_code and r.serial_number = lm.serial_number " +
                        "limit (? * ?);";

        String query =
                "SELECT module_no from \"LabModule\" ORDER BY module_no DESC LIMIT 1;";


        try {
            // declare statement
            Statement st = conn.createStatement();

            // execute query and get results
            ResultSet resultSet = st.executeQuery(query);

            // get the highest number and start counting from that
            int max_module_no = 0;
            while (resultSet.next())
                max_module_no = resultSet.getInt(1);

            // declare prepared statement
            PreparedStatement pst = conn.prepareStatement(lm_query);
            PreparedStatement pst1 = conn.prepareStatement(wg_query);
            PreparedStatement pst2 = conn.prepareStatement(j_query);

            int total_members = 0;
            // Create LabModule(s)
            for (int i=0; i<num_of_lm; i++){
                pst.setInt(1, i+1+max_module_no);
                pst.setInt(2, serial_number);
                pst.setString(3, course_code);
                pst.setInt(4, 10);
                total_members = rand.nextInt(min_members, max_members+1);
                pst.setInt(5, total_members);
                pst.setNull(6, Types.VARCHAR);
                if (rand.nextDouble() <= prob_project)
                    pst.setString(7, "project");
                else
                    pst.setString(7, "lab_exercise");

                pst.executeUpdate();

                // Create Workgroup(s)
                for (int j=0; j<max_teams; j++) {
                    pst1.setInt(1, j+1);
                    pst1.setInt(2, i+1+max_module_no);
                    pst1.setInt(3, serial_number);
                    pst1.setString(4, course_code);
                    pst1.setInt(5, (int)(rand.nextGaussian() * standard_deviation + mean)%(grade_max-grade_min + 1) + grade_min);

                    pst1.executeUpdate();
                }

                // Create Joins - match students to Workgroup(s)
                pst2.setInt(1, total_members);
                pst2.setInt(2, total_members);
                pst2.setInt(3, i + 1 + max_module_no);
                pst2.setInt(4, max_teams);
                pst2.setInt(5, total_members);

                pst2.executeUpdate();

            }

            System.out.println("Created " + num_of_lm + " LabModule(s)");
            System.out.println("Created " + max_teams * num_of_lm + " Workgroup(s)");

            st.close();
            pst.close();
            pst1.close();
            pst2.close();

        } catch (SQLException e){
            System.out.println("Error executing guery");
            System.out.println(e.getMessage());
//            e.printStackTrace();
        }
    }

    public void create_LabModule_for_semester_subject_14(String field_code, int num_of_lm, int max_teams) {

        String query = "SELECT * FROM \"CourseRun\" WHERE left(course_code, 3) = ? and labuses IS NOT NULL;";

        try {
            // declare statement
            PreparedStatement pst = conn.prepareStatement(query);

            // set variables
            pst.setString(1, field_code);

            // declare query
            ResultSet rs = pst.executeQuery();

            // pass data to 1.3 method
            while (rs.next()) {
                add_new_LabModule_13(rs.getString(1), rs.getInt(2), num_of_lm, max_teams);
            }

            pst.close();

        } catch (SQLException e) {
            System.out.println("Error executing guery");
            System.out.println(e.getMessage());
//            e.printStackTrace();
        }

    }

    public static void main(String[] args){
        MainClass app = new MainClass();

        // This class can ONLY execute queries on the Phase B database, not on the Phase A database,
        // because there are incompatible types, such as wgID vs wg_id, student_amka vs amka, etc

        // Please modify the parameters below to connect to a database
        app.dbConnect("localhost", "cs303_phase_b", "postgres", "apo123456");

//        app.semester_lab_grade_12("26030108171", "spring", 2022);

//        app.add_new_LabModule_13( "ΗΡΥ 203", 12, 2, 3);

//        app.create_LabModule_for_semester_subject_14("ΠΛΗ", 1, 2);

        app.dbClose();

    }
}
