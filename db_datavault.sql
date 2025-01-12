-- Хабы (ключевые сущности)
CREATE TABLE HubCitizen (
    citizen_key UUID PRIMARY KEY,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL
);

CREATE TABLE HubDriverLicense (
    license_key UUID PRIMARY KEY,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL
);

CREATE TABLE HubProcessStep (
    process_step_key UUID PRIMARY KEY,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL
);

-- Линки (связи между хабами)
CREATE TABLE LinkCitizenDriverLicense (
    citizen_key UUID NOT NULL REFERENCES HubCitizen(citizen_key),
    license_key UUID NOT NULL REFERENCES HubDriverLicense(license_key),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (citizen_key, license_key)
);

CREATE TABLE LinkCitizenProcess (
    citizen_key UUID NOT NULL REFERENCES HubCitizen(citizen_key),
    process_step_key UUID NOT NULL REFERENCES HubProcessStep(process_step_key),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (citizen_key, process_step_key)
);

CREATE TABLE LinkStepDependencies (
    process_step_key UUID NOT NULL REFERENCES HubProcessStep(process_step_key),
    depends_on_step_key UUID NOT NULL REFERENCES HubProcessStep(process_step_key),
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (process_step_key, depends_on_step_key)
);

-- Сателлиты (атрибуты сущностей)
CREATE TABLE SatCitizen (
    citizen_key UUID NOT NULL REFERENCES HubCitizen(citizen_key),
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    passport_number VARCHAR(50) UNIQUE,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (citizen_key, load_date)
);

CREATE TABLE SatDriverLicense (
    license_key UUID NOT NULL REFERENCES HubDriverLicense(license_key),
    license_number VARCHAR(50) NOT NULL UNIQUE,
    category VARCHAR(10) NOT NULL,
    issued_date DATE,
    expiry_date DATE,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (license_key, load_date)
);

CREATE TABLE SatProcessStep (
    process_step_key UUID NOT NULL REFERENCES HubProcessStep(process_step_key),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    estimated_duration INTERVAL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (process_step_key, load_date)
);

CREATE TABLE SatProcessProgress (
    citizen_key UUID NOT NULL REFERENCES HubCitizen(citizen_key),
    process_step_key UUID NOT NULL REFERENCES HubProcessStep(process_step_key),
    status VARCHAR(50) NOT NULL CHECK (status IN ('not started', 'in progress', 'completed')),
    updated_at TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(255) NOT NULL,
    PRIMARY KEY (citizen_key, process_step_key, load_date)
);
