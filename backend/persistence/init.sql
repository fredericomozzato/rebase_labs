CREATE DATABASE relabs_test;

CREATE TABLE IF NOT EXISTS patients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  cpf CHAR(14) NOT NULL UNIQUE,
  email VARCHAR(50) NOT NULL UNIQUE,
  birthdate DATE NOT NULL,
  address VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS doctors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL UNIQUE,
  crm CHAR(10) NOT NULL UNIQUE,
  crm_state CHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS tests (
  id SERIAL PRIMARY KEY,
  token CHAR(6) NOT NULL UNIQUE,
  date DATE NOT NULL,
  patient_id INTEGER,
  doctor_id INTEGER,
  
  CONSTRAINT fk_patient 
    FOREIGN KEY(patient_id)
      REFERENCES patients(id),
  CONSTRAINT fk_doctor
    FOREIGN KEY(doctor_id)
      REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS test_types (
  id SERIAL PRIMARY KEY,
  type VARCHAR(20) NOT NULL,
  type_range VARCHAR(10) NOT NULL,
  result INTEGER NOT NULL,
  test_id INTEGER,
  
  CONSTRAINT fk_test
    FOREIGN KEY(test_id)
      REFERENCES tests(id)
);
