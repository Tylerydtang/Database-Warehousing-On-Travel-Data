# Database Warehousing on Travel Data

This repository contains a project focused on creating a database warehouse to manage and analyze travel data. The aim is to facilitate data storage, retrieval, and analysis for various travel-related metrics, providing valuable insights for businesses and researchers in the travel industry.

## Table of Contents

- [Overview](#overview)
- [Dataset](#dataset)
- [Technologies Used](#technologies-used)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

In the travel industry, managing vast amounts of data efficiently is crucial for decision-making and strategic planning. This project focuses on designing and implementing a database warehouse that allows for effective storage and analysis of travel data, including bookings, customer preferences, and travel trends.

## Dataset

The dataset includes various attributes related to travel, such as:

- **Booking ID:** Unique identifier for each booking.
- **Customer Information:** Details about the customer, including name, contact information, and demographic data.
- **Travel Destination:** The location where the travel occurs.
- **Travel Dates:** Start and end dates of the travel.
- **Cost:** Total cost of the travel booking.
- **Rating:** Customer rating of their travel experience.

### Source

[Dataset Link](#) (provide a link if applicable)

## Technologies Used

- MySQL
- SQLAlchemy
- Python
- Pandas
- Jupyter Notebook

## Database Schema

The database is structured to optimize data retrieval and analysis. Key components include:

- **Customers Table:** Stores customer information.
- **Bookings Table:** Records details about each booking, linked to customers.
- **Destinations Table:** Contains information about travel destinations.
- **Reviews Table:** Captures customer feedback and ratings for their travel experiences.

## Installation

To run this project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/yuanditang/Database-Warehousing-On-Travel-Data.git
   ```

2. Navigate to the project directory:
   ```bash
   cd Database-Warehousing-On-Travel-Data
   ```

3. Install the required packages:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

1. Open the Jupyter Notebook file (`travel_data_analysis.ipynb`).
2. Run the cells to create the database schema, populate it with sample data, and perform analyses.
3. Modify the code as needed to explore different aspects of the travel data.

## Contributing

Contributions are welcome! If you have suggestions or improvements, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
