-- ============================================
-- Car Inspection Application Database Schema
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS car_inspection_db;
USE car_inspection_db;

-- ============================================
-- Drop existing tables (in reverse order of dependencies)
-- ============================================
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS test_drive;
DROP TABLE IF EXISTS tyres;
DROP TABLE IF EXISTS exterior_body;
DROP TABLE IF EXISTS electrical_electronics;
DROP TABLE IF EXISTS ac_heater;
DROP TABLE IF EXISTS interior;
DROP TABLE IF EXISTS suspension_steering;
DROP TABLE IF EXISTS brakes;
DROP TABLE IF EXISTS engine_transmission;
DROP TABLE IF EXISTS body_frame_checklist;
DROP TABLE IF EXISTS inspection_reports;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS inspection_requests;
DROP TABLE IF EXISTS users;

-- ============================================
-- Table: users
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('customer', 'inspector', 'admin') NOT NULL DEFAULT 'customer',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: inspection_requests
-- ============================================
CREATE TABLE inspection_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    inspector_id INT NULL,
    status ENUM('pending', 'assigned', 'scheduled', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    preferred_date DATE,
    preferred_time TIME,
    scheduled_date DATETIME NULL,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (inspector_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_inspector (inspector_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: vehicles
-- ============================================
CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_request_id INT NOT NULL,
    make VARCHAR(100),
    model VARCHAR(100),
    year INT,
    registration_no VARCHAR(50),
    chassis_no VARCHAR(100),
    engine_no VARCHAR(100),
    engine_capacity VARCHAR(50),
    mileage INT,
    fuel_type ENUM('Petrol', 'Diesel', 'Hybrid', 'Electric', 'CNG'),
    transmission_type ENUM('Automatic', 'Manual'),
    color VARCHAR(50),
    registered_city VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (inspection_request_id) REFERENCES inspection_requests(id) ON DELETE CASCADE,
    INDEX idx_inspection_request (inspection_request_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: inspection_reports
-- ============================================
CREATE TABLE inspection_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_request_id INT UNIQUE NOT NULL,
    inspector_id INT NOT NULL,
    inspection_date DATE,
    overall_rating DECIMAL(3,1),
    inspector_comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (inspection_request_id) REFERENCES inspection_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (inspector_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_inspection_request (inspection_request_id),
    INDEX idx_inspector (inspector_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: body_frame_checklist
-- ============================================
CREATE TABLE body_frame_checklist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    radiator_core_support VARCHAR(100),
    radiator_core_support_image VARCHAR(255),
    right_strut_tower_apron VARCHAR(100),
    right_strut_tower_apron_image VARCHAR(255),
    left_strut_tower_apron VARCHAR(100),
    left_strut_tower_apron_image VARCHAR(255),
    right_front_rail VARCHAR(100),
    right_front_rail_image VARCHAR(255),
    left_front_rail VARCHAR(100),
    left_front_rail_image VARCHAR(255),
    cowl_panel_firewall VARCHAR(100),
    right_a_pillar VARCHAR(100),
    left_a_pillar VARCHAR(100),
    right_b_pillar VARCHAR(100),
    left_b_pillar VARCHAR(100),
    right_c_pillar VARCHAR(100),
    left_c_pillar VARCHAR(100),
    boot_floor VARCHAR(100),
    boot_floor_image VARCHAR(255),
    boot_lock_pillar VARCHAR(100),
    boot_lock_pillar_image VARCHAR(255),
    rear_sub_frame VARCHAR(100),
    rear_sub_frame_image VARCHAR(255),
    front_sub_frame VARCHAR(100),
    front_sub_frame_image VARCHAR(255),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: engine_transmission
-- ============================================
CREATE TABLE engine_transmission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    engine_oil_level VARCHAR(100),
    engine_oil_level_image VARCHAR(255),
    engine_oil_leakage VARCHAR(100),
    engine_oil_leakage_image VARCHAR(255),
    transmission_oil_leakage VARCHAR(100),
    transmission_oil_leakage_image VARCHAR(255),
    coolant_leakage VARCHAR(100),
    brake_oil_leakage VARCHAR(100),
    belts_fan VARCHAR(100),
    belts_fan_image VARCHAR(255),
    wires_harness VARCHAR(100),
    wires_harness_image VARCHAR(255),
    engine_blow VARCHAR(100),
    engine_noise VARCHAR(100),
    engine_vibration VARCHAR(100),
    cold_start VARCHAR(100),
    engine_mounts VARCHAR(100),
    pulleys VARCHAR(100),
    hoses VARCHAR(100),
    hoses_image VARCHAR(255),
    exhaust_sound VARCHAR(100),
    radiator VARCHAR(100),
    radiator_image VARCHAR(255),
    suction_fan VARCHAR(100),
    starter_operation VARCHAR(100),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: brakes
-- ============================================
CREATE TABLE brakes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    front_right_disc VARCHAR(100),
    front_right_disc_image VARCHAR(255),
    front_left_disc VARCHAR(100),
    front_left_disc_image VARCHAR(255),
    front_right_brake_pad VARCHAR(100),
    front_right_brake_pad_image VARCHAR(255),
    front_left_brake_pad VARCHAR(100),
    front_left_brake_pad_image VARCHAR(255),
    parking_hand_brake VARCHAR(100),
    parking_hand_brake_image VARCHAR(255),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: suspension_steering
-- ============================================
CREATE TABLE suspension_steering (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    steering_wheel_play VARCHAR(100),
    right_ball_joint VARCHAR(100),
    right_ball_joint_image VARCHAR(255),
    left_ball_joint VARCHAR(100),
    left_ball_joint_image VARCHAR(255),
    right_z_links VARCHAR(100),
    right_z_links_image VARCHAR(255),
    left_z_links VARCHAR(100),
    left_z_links_image VARCHAR(255),
    right_tie_rod_end VARCHAR(100),
    right_tie_rod_end_image VARCHAR(255),
    left_tie_rod_end VARCHAR(100),
    left_tie_rod_end_image VARCHAR(255),
    front_right_boots VARCHAR(100),
    front_right_boots_image VARCHAR(255),
    front_left_boots VARCHAR(100),
    front_left_boots_image VARCHAR(255),
    front_right_bushes VARCHAR(100),
    front_right_bushes_image VARCHAR(255),
    front_left_bushes VARCHAR(100),
    front_left_bushes_image VARCHAR(255),
    front_right_shock VARCHAR(100),
    front_right_shock_image VARCHAR(255),
    front_left_shock VARCHAR(100),
    front_left_shock_image VARCHAR(255),
    rear_right_bushes VARCHAR(100),
    rear_right_bushes_image VARCHAR(255),
    rear_left_bushes VARCHAR(100),
    rear_left_bushes_image VARCHAR(255),
    rear_right_shock VARCHAR(100),
    rear_right_shock_image VARCHAR(255),
    rear_left_shock VARCHAR(100),
    rear_left_shock_image VARCHAR(255),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: interior
-- ============================================
CREATE TABLE interior (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    steering_wheel_condition VARCHAR(100),
    steering_wheel_condition_image VARCHAR(255),
    steering_wheel_buttons VARCHAR(100),
    horn VARCHAR(100),
    lights_lever VARCHAR(100),
    wiper_washer_lever VARCHAR(100),
    right_side_mirror VARCHAR(100),
    left_side_mirror VARCHAR(100),
    rear_view_mirror_dimmer VARCHAR(100),
    right_seat_adjuster_recliner VARCHAR(100),
    left_seat_adjuster_recliner VARCHAR(100),
    right_seat_adjuster_track VARCHAR(100),
    left_seat_adjuster_track VARCHAR(100),
    right_seat_belt VARCHAR(100),
    left_seat_belt VARCHAR(100),
    rear_seat_belts VARCHAR(100),
    glove_box VARCHAR(100),
    front_right_power_window VARCHAR(100),
    front_left_power_window VARCHAR(100),
    rear_right_power_window VARCHAR(100),
    rear_left_power_window VARCHAR(100),
    auto_lock_button VARCHAR(100),
    window_safety_lock VARCHAR(100),
    interior_lightings VARCHAR(100),
    dash_controls_ac VARCHAR(100),
    dash_controls_defog VARCHAR(100),
    dash_controls_hazzard VARCHAR(100),
    dash_controls_others VARCHAR(100),
    audio_video VARCHAR(100),
    rear_view_camera VARCHAR(100),
    rear_view_camera_image VARCHAR(255),
    trunk_release_lever VARCHAR(100),
    fuel_cap_release_lever VARCHAR(100),
    bonnet_release_lever VARCHAR(100),
    sun_roof_control VARCHAR(100),
    sun_roof_control_image VARCHAR(255),
    roof_poshish VARCHAR(100),
    floor_mat VARCHAR(100),
    front_right_seat_poshish VARCHAR(100),
    front_left_seat_poshish VARCHAR(100),
    rear_seat_poshish VARCHAR(100),
    dashboard_condition VARCHAR(100),
    dashboard_condition_image VARCHAR(255),
    spare_tire VARCHAR(100),
    spare_tire_image VARCHAR(255),
    tools VARCHAR(100),
    tools_image VARCHAR(255),
    jack VARCHAR(100),
    jack_image VARCHAR(255),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: ac_heater
-- ============================================
CREATE TABLE ac_heater (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    ac_fitted VARCHAR(100),
    ac_operational VARCHAR(100),
    blower VARCHAR(100),
    cooling VARCHAR(100),
    cooling_image VARCHAR(255),
    heating VARCHAR(100),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: electrical_electronics
-- ============================================
CREATE TABLE electrical_electronics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    computer_checkup VARCHAR(100),
    computer_checkup_image VARCHAR(255),
    battery_warning_light VARCHAR(100),
    oil_pressure_warning_light VARCHAR(100),
    temperature_warning_light VARCHAR(100),
    airbag_warning_light VARCHAR(100),
    power_steering_warning_light VARCHAR(100),
    abs_warning_light VARCHAR(100),
    key_fob_battery_light VARCHAR(100),
    battery_voltage INT,
    battery_terminals_condition VARCHAR(100),
    battery_terminals_image VARCHAR(255),
    battery_charging VARCHAR(100),
    alternator_operation VARCHAR(100),
    alternator_operation_image VARCHAR(255),
    gauges VARCHAR(100),
    gauges_image VARCHAR(255),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: exterior_body
-- ============================================
CREATE TABLE exterior_body (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    trunk_lock VARCHAR(100),
    front_windshield VARCHAR(100),
    front_windshield_image VARCHAR(255),
    rear_windshield VARCHAR(100),
    rear_windshield_image VARCHAR(255),
    front_right_door_window VARCHAR(100),
    front_left_door_window VARCHAR(100),
    rear_right_door_window VARCHAR(100),
    rear_left_door_window VARCHAR(100),
    windscreen_wiper VARCHAR(100),
    sun_roof_glass VARCHAR(100),
    sun_roof_glass_image VARCHAR(255),
    right_headlight_working VARCHAR(100),
    left_headlight_working VARCHAR(100),
    right_headlight_condition VARCHAR(100),
    left_headlight_condition VARCHAR(100),
    right_taillight_working VARCHAR(100),
    left_taillight_working VARCHAR(100),
    right_taillight_condition VARCHAR(100),
    left_taillight_condition VARCHAR(100),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: tyres
-- ============================================
CREATE TABLE tyres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    front_right_tyre_brand VARCHAR(100),
    front_right_tyre_condition VARCHAR(100),
    front_right_tyre_image VARCHAR(255),
    front_left_tyre_brand VARCHAR(100),
    front_left_tyre_condition VARCHAR(100),
    front_left_tyre_image VARCHAR(255),
    rear_right_tyre_brand VARCHAR(100),
    rear_right_tyre_condition VARCHAR(100),
    rear_right_tyre_image VARCHAR(255),
    rear_left_tyre_brand VARCHAR(100),
    rear_left_tyre_condition VARCHAR(100),
    rear_left_tyre_image VARCHAR(255),
    tyre_size VARCHAR(50),
    rims VARCHAR(50),
    wheel_caps VARCHAR(100),
    rating_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: test_drive
-- ============================================
CREATE TABLE test_drive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT NOT NULL,
    engine_pick VARCHAR(100),
    drive_shaft_noise VARCHAR(100),
    gear_shifting VARCHAR(100),
    brake_pedal_operation VARCHAR(100),
    abs_operation VARCHAR(100),
    front_suspension VARCHAR(100),
    rear_suspension VARCHAR(100),
    steering_operation VARCHAR(100),
    steering_wheel_alignment VARCHAR(100),
    ac_operation VARCHAR(100),
    heater_operation VARCHAR(100),
    speedometer VARCHAR(100),
    test_drive_done_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES inspection_reports(id) ON DELETE CASCADE,
    INDEX idx_report (report_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: notifications
-- ============================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('inspection_requested', 'inspector_assigned', 'inspection_scheduled', 'inspection_completed', 'report_ready') NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    related_inspection_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (related_inspection_id) REFERENCES inspection_requests(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_is_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insert sample admin user
-- Password: admin123 (hashed with bcrypt)
-- ============================================
INSERT INTO users (email, password, full_name, phone, role, is_active) VALUES
('admin@carinspection.com', '$2a$10$rKZLvVZwXqK5YJXxVxVxVeK5YJXxVxVxVeK5YJXxVxVxVeK5YJXxVx', 'Admin User', '+92-300-1234567', 'admin', TRUE);

-- Note: The password hash above is a placeholder. 
-- You should generate a proper bcrypt hash for 'admin123' when setting up the application.

-- ============================================
-- End of Schema
-- ============================================
