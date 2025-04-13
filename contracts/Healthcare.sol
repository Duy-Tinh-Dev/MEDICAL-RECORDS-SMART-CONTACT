// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    struct Patient {
        address patientAddress;
        string patientId;
        bool exists;
    }
    
    struct Doctor {
        address doctorAddress;
        string doctorId;
        string name;
        string specialization;
        bool exists;
    }
    
    struct MedicalRecord {
        string recordId;
        string patientId;
        string data; // Đây có thể là hash/IPFS hash của dữ liệu y tế thực tế
        uint256 timestamp;
        address addedBy;
    }
    
    mapping(address => Patient) public patients;
    mapping(string => Patient) public patientsByID;
    mapping(address => Doctor) public doctors;
    mapping(string => Doctor) public doctorsByID;
    mapping(string => MedicalRecord[]) public patientRecords;
    mapping(string => mapping(address => bool)) public accessPermissions;
    
    event PatientRegistered(address patient, string patientId);
    event DoctorRegistered(address doctor, string doctorId);
    event RecordAdded(string patientId, string recordId);
    event AccessGranted(string patientId, address doctor);
    event AccessRevoked(string patientId, address doctor);
    
    // Modifier để kiểm tra người gọi là bệnh nhân
    modifier onlyPatient(string memory patientId) {
        require(patients[msg.sender].exists && keccak256(bytes(patients[msg.sender].patientId)) == keccak256(bytes(patientId)), "Not authorized");
        _;
    }
    
    // Modifier để kiểm tra người gọi là bác sĩ được cấp quyền
    modifier hasAccess(string memory patientId) {
        require(
            doctors[msg.sender].exists && accessPermissions[patientId][msg.sender] || 
            patients[msg.sender].exists && keccak256(bytes(patients[msg.sender].patientId)) == keccak256(bytes(patientId)), 
            "Access denied"
        );
        _;
    }
    
    // Đăng ký bệnh nhân mới
    function registerPatient(string memory patientId) public {
        require(!patients[msg.sender].exists, "Patient already registered");
        
        patients[msg.sender] = Patient(msg.sender, patientId, true);
        patientsByID[patientId] = Patient(msg.sender, patientId, true);
        
        emit PatientRegistered(msg.sender, patientId);
    }
    
    // Đăng ký bác sĩ mới
    function registerDoctor(string memory doctorId, string memory name, string memory specialization) public {
        require(!doctors[msg.sender].exists, "Doctor already registered");
        
        doctors[msg.sender] = Doctor(msg.sender, doctorId, name, specialization, true);
        doctorsByID[doctorId] = Doctor(msg.sender, doctorId, name, specialization, true);
        
        emit DoctorRegistered(msg.sender, doctorId);
    }
    
    // Thêm hồ sơ y tế mới
    function addMedicalRecord(string memory patientId, string memory recordId, string memory data) public {
        // Bác sĩ có quyền hoặc bệnh nhân tự thêm
        require(
            (doctors[msg.sender].exists && accessPermissions[patientId][msg.sender]) || 
            (patients[msg.sender].exists && keccak256(bytes(patients[msg.sender].patientId)) == keccak256(bytes(patientId))), 
            "Not authorized"
        );
        
        MedicalRecord memory record = MedicalRecord(recordId, patientId, data, block.timestamp, msg.sender);
        patientRecords[patientId].push(record);
        
        emit RecordAdded(patientId, recordId);
    }
    
    // Bệnh nhân cấp quyền cho bác sĩ
    function grantAccess(string memory patientId, address doctorAddress) public onlyPatient(patientId) {
        require(doctors[doctorAddress].exists, "Doctor does not exist");
        accessPermissions[patientId][doctorAddress] = true;
        
        emit AccessGranted(patientId, doctorAddress);
    }
    
    // Bệnh nhân thu hồi quyền của bác sĩ
    function revokeAccess(string memory patientId, address doctorAddress) public onlyPatient(patientId) {
        require(doctors[doctorAddress].exists, "Doctor does not exist");
        accessPermissions[patientId][doctorAddress] = false;
        
        emit AccessRevoked(patientId, doctorAddress);
    }
    
    // Lấy danh sách hồ sơ y tế của bệnh nhân
    function getMedicalRecords(string memory patientId) public view hasAccess(patientId) returns (MedicalRecord[] memory) {
        return patientRecords[patientId];
    }
    
    // Kiểm tra xem một bác sĩ có quyền truy cập hay không
    function checkAccess(string memory patientId, address doctorAddress) public view returns (bool) {
        return accessPermissions[patientId][doctorAddress];
    }
}