--BRAYAM EDWIN QUISPE APAZA

CREATE DATABASE Tienda2
USE Tienda2

CREATE TABLE Personas (
    PersonaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    ApellidoPaterno NVARCHAR(100) NOT NULL,
    ApellidoMaterno NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE,
    Direccion NVARCHAR(255),
    Email NVARCHAR(255) UNIQUE,
    Telefono NVARCHAR(20)
);

CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    PersonaID INT FOREIGN KEY REFERENCES Personas(PersonaID),
    Usuario NVARCHAR(50) NOT NULL,
    Contrasenia NVARCHAR(128) NOT NULL,
    FechaRegistro DATETIME NOT NULL,
);


CREATE TABLE Productoss (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(255) NOT NULL,
    Descripcion NVARCHAR(MAX),
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL CHECK (Stock >= 0)
);

CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    PersonaID INT NOT NULL,
    FOREIGN KEY (PersonaID) REFERENCES Personas(PersonaID)
);

CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaVenta DATE NOT NULL,
    TotalVenta DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE VentaDetalle (
    VentaDetalleID INT IDENTITY(1,1) PRIMARY KEY,
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Productoss(ProductoID)
);

INSERT INTO Personas ( Nombre, ApellidoPaterno, ApellidoMaterno,FechaNacimiento,Direccion, Email, Telefono)
VALUES
    ('Juan', 'P�rez','Vasquez','1992/12/07', 'Calle 123, Ciudad A', 'juan@email.com', '123-456-7890'),
    ('Ana', 'Garc�a','Perez','1994/10/02', 'Avenida XYZ, Ciudad B', 'ana123@email.com', '987-654-3210'),
    ('Carlos', 'L�pez','Rolando','2003/03/15', 'Calle 456, Ciudad A', 'carlosFgaa@email.com', '955-555-5555'),
    ('Laura', 'Rodr�guez','Quispe','1999/08/29', 'Avenida ABC, Ciudad C', 'laura@email.com', '911-222-3333'),
    ('Pedro', 'S�nchez','Apaza','1992/09/14', 'Calle 789, Ciudad B', 'pedro@email.com', '977-888-0999'),
	('Mar�a', 'L�pez', 'Mart�nez', '1990/03/22', 'Avenida 123, Ciudad C', 'maria@email.com', '555-666-7777'),
	('Juan', 'G�mez', 'Garc�a', '1989/11/07', 'Calle 456, Ciudad D', 'juanito@email.com', '911-222-3333'),
	('Laura', 'Hern�ndez', 'Rodr�guez', '1982/06/30', 'Plaza 789, Ciudad E', 'laura123@email.com', '999-888-7777'),
	('Carlos', 'P�rez', 'G�mez', '1994/08/18', 'Ronda 012, Ciudad F', 'carlos@email.com', '944-555-2236'),
	('Sof�a', 'Gonz�lez', 'Guti�rrez', '1993/02/14', 'Bulevar 345, Ciudad G', 'sofia@email.com', '123-222-1111'),
	('Diego', 'Rodr�guez', 'G�mez', '1998/09/29', 'Avenida 678, Ciudad H', 'diego@email.com', '222-333-3244'),
	('Ana', 'Mart�nez', 'L�pez', '1993/05/11', 'Callej�n 901, Ciudad I', 'ana@email.com', '966-555-1544'),
	('Javier', 'G�mez', 'Hern�ndez', '1980/12/04', 'Plaza 234, Ciudad J', 'javier@email.com', '777-666-5555'),
	('Elena', 'Guti�rrez', 'P�rez', '1994/10/26', 'Bulevar 567, Ciudad K', 'elen12a@email.com', '988-999-0110'),
	('Miguel', 'Hern�ndez', 'Gonz�lez', '1998/07/19', 'Ronda 890, Ciudad L', 'miguel@email.com', '999-000-1111'),
	('Luis', 'G�mez', 'Mart�nez', '2000/04/02', 'Calle 123, Ciudad M', 'luisAQ@email.com', '900-411-2222'),
	('Luc�a', 'P�rez', 'G�mez', '2003/01/15', 'Avenida 456, Ciudad N', 'lucia@email.com', '911-222-9933'),
	('Pablo', 'Rodr�guez', 'Mart�nez', '2000/06/28', 'Plaza 789, Ciudad O', 'pabloITO@email.com', '922-333-4754'),
	('Laura', 'L�pez', 'Hern�ndez', '1976/03/10', 'Bulevar 012, Ciudad P', 'ABClaura@email.com', '933-444-5555'),
	('Santiago', 'G�mez', 'P�rez', '1982/08/23', 'Callej�n 345, Ciudad Q', 'santiagoZZ@email.com', '944-555-6606');

-- Crear la funci�n para obtener la edad
CREATE FUNCTION CalcularEdad (@FechaNacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Edad INT
    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE()) - 
                CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @FechaNacimiento, GETDATE()), @FechaNacimiento) > GETDATE() 
                THEN 1 ELSE 0 END

    RETURN @Edad
END;

SELECT p.Nombre, p.ApellidoPaterno, p.ApellidoMaterno, dbo.CalcularEdad(p.FechaNacimiento) as Edad
FROM Personas p
JOIN Personas c ON p.PersonaID = c.PersonaID


-- Crear la funci�n para obtener nombres y apellidos
CREATE FUNCTION ObtenerNombresApellidos()
RETURNS TABLE
AS
RETURN
    SELECT Nombre, ApellidoPaterno, ApellidoMaterno
    FROM Personas;
SELECT * FROM ObtenerNombresApellidos();


