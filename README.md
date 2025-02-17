# tompok-on-wheels #

Tompok On Wheels is a comprehensive pet transportation service platform developed as part of the TTP subject at Universiti Teknologi PETRONAS (UTP). The platform comprises three main applications:

1. **Pet Owner Mobile App (iOS/Android):** Designed for pet owners seeking services, this app offers features such as pet profile management, booking services, tracking pets, reviewing services, processing payments, and facilitating communication with service providers and Tompokkers.

2. **Tompokker Mobile App (iOS/Android):** Tailored for Tompokkers (pet transporters), this app focuses on managing bookings, sharing real-time locations, navigating routes, and handling payments through an integrated wallet system.

3. **Service Provider Web App:** Aimed at professional pet service businesses—including groomers, boarding facilities, and veterinarians—this web application includes modules for managing bookings, tracking services, communication, financial transactions, and handling customer reviews.

## Key Features

- **Real-Time Functionality:** Integration with Firebase ensures instant location sharing among all applications, enabling accurate tracking of pets and service providers during service sessions. The real-time database synchronizes booking updates, service status changes, and communication messages across all devices.

- **Robust Backend Infrastructure:** A FastAPI-powered REST API server processes requests from all three applications, handling user authentication, data validation, service coordination, and transaction processing. This architecture ensures scalability, maintainability, and robust security protocols for sensitive operations.

- **Secure Authentication:** JWT-based authentication secures communication between the Flutter applications and the FastAPI backend. Upon successful login, users receive a token containing encrypted information, ensuring secure subsequent requests.

- **Reliable Data Storage:** A PostgreSQL database serves as the persistent data store, managing complex relationships between entities such as user profiles, pet information, booking records, transaction histories, and reviews. The database design ensures data integrity and high performance for concurrent operations.

## Technology Stack

- **Frontend:** Flutter framework for cross-platform mobile applications (iOS and Android) and a web application for service providers.

- **Backend:** FastAPI-powered REST API server written in Python.

- **Database:** PostgreSQL for reliable and efficient data storage.

- **Real-Time Services:** Firebase for real-time data synchronization and location tracking.

## Getting Started

To set up the project locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/bumperr/tompok-on-wheels.git
   cd tompok-on-wheels
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

For the backend server:

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Start the FastAPI server:**
   ```bash
   uvicorn main:app --reload
   ```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that your code adheres to the project's coding standards and includes appropriate tests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

*Note: This project is developed for educational purposes as part of the TTP subject at Universiti Teknologi PETRONAS.* 
