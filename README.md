# 💳 Invoice Management System (Flutter + Firebase)

A modular **Flutter application** powered by **Firebase**, designed to manage invoice payments with SDK-style components. Features include payment logging, receipt generation, invoice status tracking, full payment history logs, and comprehensive reporting.

---

## 📦 Core SDK Modules

### 🔹 1. Payment Logging SDK
**Functionality:** Log payments made against invoices.  
**Inputs:**  
- `Invoice ID`  
- `Payment Amount`  
- `Payment Method` (e.g., cash, credit)  
**Output:**  
- Updated payment record saved in Firestore

---

### 🔹 2. Payment Receipt Generator
**Functionality:** Generate a receipt for each payment (PDF or digital object).  
**Inputs:**  
- `Invoice ID`  
- `Payment Details` (amount, method, date)  
**Output:**  
- Receipt file (PDF or JSON)

---

### 🔹 3. Invoice Status Tracking SDK
**Functionality:** Track and update the status of invoices.  
**Inputs:**  
- `Invoice ID`  
- `Status` (Paid, Unpaid, Overdue, etc.)  
**Output:**  
- Updated status in Firestore

---

### 🔹 4. Payment History Log
**Functionality:** Maintain a complete log of all payments for any invoice.  
**Inputs:**  
- `Invoice ID`  
- `Payment Details`  
**Output:**  
- Structured history stored and retrieved from Firestore

---

### 🔹 5. Invoice Summary Report SDK
**Functionality:** Generate reports summarizing invoices.  
**Inputs:**  
- `Date Range`  
- `Status`  
- `Client ID`  
**Output:**  
- Tabular or graphical report object

---

## 🔧 Tech Stack

- **Flutter** (Dart)
- **Firebase Firestore** – real-time NoSQL backend
- **Firebase Authentication** (if user login is used)
- **PDF** generation with `pdf` and `printing` packages
- **State Management** (e.g., `Provider`, `Riverpod`, etc.)

---

## 🚀 Getting Started

### 1. Clone the Repo

```bash
git clone https://github.com/Khaledmhmdd/cost_Mangement_App.git
cd cost_Mangement_App
flutter pub get
flutter run

