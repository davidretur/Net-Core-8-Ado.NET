CREATE DATABASE AnniesTech

USE AnniesTech

CREATE TABLE Roles(
RolId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(50)
)

INSERT INTO Roles VALUES ('Administrador')
INSERT INTO Roles VALUES ('Usuario')

CREATE PROCEDURE ListarRoles
AS BEGIN 
SELECT * FROM Roles
END

CREATE TABLE Usuarios(
UsuarioId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Nombre VARCHAR(50),
Apellido Varchar(50),
Correo VARCHAR(100) UNIQUE,
Contrasenia VARCHAR(MAX),
RolId INT,
NombreUsuario VARCHAR(50) UNIQUE,
Estado BIT,
Token VARCHAR(MAX),
FechaExpiracion DATETIME
)

CREATE PROCEDURE RegistrarUsuario
@Nombre VARCHAR(50),
@Apellido Varchar(50),
@Correo VARCHAR(100),
@Contrasenia VARCHAR(MAX),
@RolId INT = 2,
@NombreUsuario VARCHAR(50),
@Estado BIT = 0,
@Token VARCHAR(MAX),
@FechaExpiracion DATETIME
AS BEGIN
INSERT INTO Usuarios VALUES(@Nombre,@Apellido,@correo,@Contrasenia,@RolId,@NombreUsuario,@Estado,@Token,@FechaExpiracion)
END

CREATE PROCEDURE ActivarCuenta
@Token VARCHAR(MAX),
@Fecha DATETIME
AS BEGIN

DECLARE @Correo VARCHAR(100)
DECLARE @FechaExpiracion DATETIME

SET @Correo = (SELECT Correo FROM Usuarios WHERE Token= @Token)
SET @FechaExpiracion = (SELECT FechaExpiracion FROM Usuarios WHERE Token= @Token)
IF @FechaExpiracion<@Fecha
BEGIN
UPDATE Usuario SET Estado = 1 WHERE Token= @Token
UPDATE Usuario SET Token = NULL WHERE Correo= @Correo
SELECT 1 AS Resultado
END
ELSE
BEGIN
	SELECT 0 AS Resultado
	END
END

CREATE PROCEDURE ValidarUsuario
@Correo VARCHAR(100) 
AS BEGIN
SELECT * FROM  Usuario WHERE Correo = @Correo
END

CREATE PROCEDURE ActualizarToken
@Correo VARCHAR(100),
@Fecha DATETIME,
@Token VARCHAR(MAX)
AS BEGIN
UPDATE Usuarios SET Token= @Token, FechaExpiracion = @Fecha WHERE Correo = @Correo
END

CREATE PROCEDURE ActualizarPerfil
@UsuarioId INT,
@Nombre VARCHAR(50),
@Apellido VARCHAR(50),
@Correo VARCHAR(100)
AS BEGIN
UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, Correo = @Correo WHERE UsuarioId=@UsuarioId
END

CREATE PROCEDURE ActualizarUsuario
@UsuarioId INT,
@Nombre VARCHAR(50),
@Apellido VARCHAR(50),
@RolId INT,
@Estado BIT
AS BEGIN
UPDATE Usuarios SET Nombre = @Nombre, Apellido = @Apellido, RolId = @RolId, Estado = @Estado WHERE UsuarioId=@UsuarioId
END

CREATE PROCEDURE EliminarUsuario
@UsuarioId INT
AS BEGIN
DELETE FROM Usuarios WHERE UsuarioId = @UsuarioId
END


CREATE TABLE Post(
PostId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Titulo VARCHAR(500),
Contenido VARCHAR(MAX),
Categoria VARCHAR(100),
FechaCreacion DATETIME
)

CREATE PROCEDURE InsertarPost
@Titulo VARCHAR(500),
@Contenido VARCHAR(MAX),
@Categoria VARCHAR(100),
@FechaCreacion DATETIME
AS
BEGIN
 INSERT INTO Post
 VALUES
 (@Titulo,@Contenido, @Categoria, @FechaCreacion)
 END

 CREATE PROCEDURE ActualizarPost
 @PostId INT,
 @Titulo VARCHAR(500),
 @Contenido VARCHAR(MAX),
 @Categoria VARCHAR(100)
 AS
 BEGIN
  UPDATE Post SET Titulo = @Titulo, Contenido= @Contenido, Categoria = @Categoria WHERE PostId = @PostId
  END

  CREATE PROCEDURE ObtenerPostId
  @PostId INT
  AS BEGIN
  SELECT * FROM Post WHERE PostId = @PostId
  END

  CREATE PROCEDURE EliminarPost
  @PostId INT
  AS BEGIN
  DELETE Post WHERE PostId = @PostId;
  END

  CREATE PROCEDURE ObtenerTodosLosPost
  AS BEGIN
  SELECT * FROM Post
  END

  CREATE PROCEDURE ObtenerPostPorCategoria
  @Categoria VARCHAR(50)
  AS
  BEGIN
  SELECT * FROM Post WHERE Categoria = @Categoria
  END

  CREATE PROCEDURE ObtenerPostPorTitulo
  @Titulo VARCHAR(500)
  AS
  BEGIN
  SELECT * FROM Post WHERE Titulo LIKE '%'+@Titulo+'%'
  END

  CREATE TABLE Comentario(
  ComentarioId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  Contenido VARCHAR(MAX),
  FechaCreacion DATETIME,
  UsuarioId INT,
  PostId INT,
  ComentarioPadreId INT NULL
  CONSTRAINT FK_Comentario_UsuarioId FOREIGN KEY(UsuarioId) REFERENCES Usuarios(UsuarioId) ON DELETE CASCADE,
  CONSTRAINT FK_Comentario_PostId FOREIGN KEY(PostId) REFERENCES Post(PostId) ON DELETE CASCADE,
  CONSTRAINT FK_Comentario_ComentarioPadreId FOREIGN KEY(ComentarioPadreId) REFERENCES Comentario(ComentarioId) ON DELETE NO ACTION
  )

  CREATE TRIGGER TR_EliminarComentariosHijos ON Comentario
  AFTER DELETE
  AS BEGIN
  DELETE FROM Comentario WHERE ComentarioPadreId IN (SELECT ComentarioId FROM DELETED)
  END

  CREATE OR ALTER PROCEDURE ObtenerComentariosPorPostId
  @PostId INT
  AS
  BEGIN
  SELECT c.ComentarioId, c.Contenido, c.FechaCreacion, c.UsuarioId, c.PostId, u.NombreUsuario  FROM Comentario c
  INNER JOIN Usuarios u ON u.UsuarioId = C.UsuarioId
  WHERE c.PostId = @PostId AND c.ComentarioPadreId IS NULL
  END

    CREATE PROCEDURE ObtenerComentariosHijosPorComentarioId
  @ComentarioId INT
  AS
  BEGIN
  SELECT c.ComentarioId, c.Contenido, c.FechaCreacion, c.UsuarioId, c.PostId, u.NombreUsuario  FROM Comentario c
  INNER JOIN Usuarios u ON u.UsuarioId = C.UsuarioId
  WHERE c.ComentarioPadreId = @ComentarioId
  END

  CREATE PROCEDURE AgregarComentario
  @Contenido VARCHAR(MAX),
  @FechaCreacion DATETIME,
  @UsuarioId INT,
  @PostId INT,
  @ComentarioPadreId INT= NULL
  AS
  BEGIN
  INSERT INTO Comentario
  VALUES 
  ( @Contenido,@FechaCreacion,@UsuarioId,@PostId,@ComentarioPadreId)
  END