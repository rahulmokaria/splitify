# Splitify

Splitify is a handy Android application developed for effortless expense management and seamless bill splitting.

## Features

### Expense Management

- **Track Expenses and Income**: Easily add and monitor your daily expenses and income.
- **Categorize Transactions**: Organize expenses by categories to see where your money is being spent.
- **Detailed Reports**: View detailed reports and summaries to get insights into your spending habits and financial health.

### Bill Sharing with Friends

- **Effortless Sharing**: Share individual expenses or entire bills with friends through the app.
- **Track Settlements**: Keep track of who has paid and who owes what.
- **Real-time Updates**: See real-time updates on who has settled their share and who hasn't.

### Bill Splitting in Groups

- **Group Management**: Create and manage groups to split bills among multiple people.
- **Automatic Calculations**: The app automatically calculates each person's share and handles any adjustments if someone has paid more or less.
- **Settlement Tracking**: Easily track and settle up the splits within the group. View detailed transaction histories and make payments directly through the app.

## Tech Stack

- **Frontend**: Flutter, Dart
- **Backend**: Node.js, JavaScript
- **Database**: MongoDB

## Getting Started

To get started with the project, follow these steps:

1. **Clone the repositories:**

   - Clone the frontend repository:
     ```sh
     git clone https://github.com/rahulmokaria/splitify.git
     ```
   - Clone the backend repository:
     ```sh
     git clone https://github.com/rahulmokaria/splitify-backend.git
     ```

2. **Set up the frontend:**

   - Navigate to the frontend project directory:
     ```sh
     cd splitify
     ```
   - Install the dependencies:
     ```sh
     flutter pub get
     ```
   - Create a `.env` file in the root directory and add your server's address:
     ```env
     URL=your_server_address
     ```
   - Run the application:
     ```sh
     flutter run
     ```

3. **Set up the backend:**

   - Navigate to the backend project directory:
     ```sh
     cd ../splitify-backend
     ```
   - Install the dependencies:
     ```sh
     npm install
     ```
   - Start the server:
     ```sh
     npm start
     ```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.
