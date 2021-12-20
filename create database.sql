DROP DATABASE if EXISTS restaurant_ver_1;

CREATE DATABASE restaurant_ver_1;

USE restaurant_ver_1;


CREATE TABLE customer(
	IDcustomer VARCHAR(10) NOT NULL UNIQUE,
	firstName VARCHAR (25),
	lastName VARCHAR (25),
	address VARCHAR (50),
	phoneNumber VARCHAR (11),
	
	PRIMARY KEY (IDcustomer)
);

CREATE TABLE transactions(
	transactionNumber INT NOT NULL UNIQUE,
	transactionDate DATETIME,
	IDcustomer VARCHAR(10),
	
	FOREIGN KEY (IDcustomer) REFERENCES customer(IDcustomer),
	PRIMARY KEY (transactionNumber)
);

CREATE TABLE orders(
	orderNumber INT NOT NULL UNIQUE,
	orderDate DATE,
	orderCondition VARCHAR (25),
	transactionNumber INT,
		
	FOREIGN KEY (transactionNumber) REFERENCES transactions(transactionNumber),
	PRIMARY KEY (orderNumber)
);

CREATE TABLE diningTable(           
	tableNumber INT UNIQUE NOT NULL UNIQUE,
	orderNumber INT,
	capacity INT,
	tableStatus VARCHAR (25),
	
	FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
	PRIMARY KEY (tableNumber)
);

CREATE TABLE reservation(
	reservationNumber INT NOT NULL UNIQUE,
	tableNumber INT,
	IDcustomer VARCHAR(10),
	reservationDate DATETIME,
	reservationStatus VARCHAR(3),
	
	FOREIGN KEY (tableNumber) REFERENCES diningTable(tableNumber),
	FOREIGN KEY (IDcustomer) REFERENCES customer(IDcustomer),
	PRIMARY KEY (reservationNumber)
);

CREATE TABLE membership(
  	IDmember VARCHAR(10) NOT NULL UNIQUE,
	startDate DATE,
	expireDate DATE,
	discount DOUBLE,
	memberLevel VARCHAR(25),
  	IDcustomer VARCHAR(10),
	
   FOREIGN KEY (IDcustomer) REFERENCES customer(IDcustomer),
	PRIMARY KEY (IDmember)
);
    
CREATE TABLE menu(
	menuCode VARCHAR(6) NOT NULL UNIQUE,
	menuName VARCHAR(50),
	price DECIMAL(10, 2),
	
	PRIMARY KEY (menuCode)
);

CREATE TABLE ingredient(
	ingredientID VARCHAR(7) NOT NULL UNIQUE,
	ingredientName VARCHAR (25),
	quantity INT,
	restockDate DATE,
	expiredDate DATE,
	price DECIMAL,
	
	PRIMARY KEY (ingredientID)
);

CREATE TABLE supplier(
	IDsupplier VARCHAR (25) NOT NULL UNIQUE,
	ingredientID VARCHAR(7),
	supplierName VARCHAR (50),
	phoneNumber VARCHAR (11),
	address VARCHAR (100),
	
	FOREIGN KEY (ingredientID) REFERENCES ingredient(ingredientID),
	PRIMARY KEY (IDsupplier)
);

CREATE TABLE personel(
	employeeID INT NOT NULL UNIQUE,
	birthDate DATE,
	firstName VARCHAR (25),
	lastName VARCHAR (25),
	salary DECIMAL(10, 2),
	typeOFJob VARCHAR (20),
	occupation VARCHAR (50),

	PRIMARY KEY (employeeID)
);

CREATE TABLE delivery(
	deliveryNumber INT NOT NULL UNIQUE,
	employeeID INT,
	orderNumber INT,
	arrival TIME,
	deliveryStatus VARCHAR(25),
	comments VARCHAR (100),
	
	FOREIGN KEY (employeeID) REFERENCES personel(employeeID),
	FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
	PRIMARY KEY (deliveryNumber)
);

CREATE TABLE recipe(
	menuCode VARCHAR(6),
	ingredientID VARCHAR(7),
	quantity INT,
	
	FOREIGN KEY (menuCode) REFERENCES menu(menuCode),
	FOREIGN KEY (ingredientID) REFERENCES ingredient(ingredientID),
	PRIMARY KEY (menuCode, ingredientID)
);

CREATE TABLE orderDetail (
	orderNumber INT,
	menuCode VARCHAR(6),
	quantity INT,
	
	FOREIGN KEY (orderNumber) REFERENCES orders(orderNumber),
	FOREIGN KEY (menuCode) REFERENCES menu(menuCode),
	PRIMARY KEY (orderNumber, menuCode)
);

