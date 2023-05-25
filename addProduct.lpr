program addProduct;
uses
  SysUtils;
type
    str = String[30];
    int=integer;

    producto = record  //registro de productos del supermercado
      nombre:str;
      codigo:int;
      valor:int;
      deleted:boolean;
    end;

    usuario = record //registro del usuario para comprobar acceso
      user:str;
      pass:str;
    end;

    datosProductos = File of producto;
    datosUsuario = File of usuario;

procedure agregarProducto(var archivo:datosProductos; p:producto);
begin
   Seek(archivo, FileSize(archivo));
   write('Ingrese nombre producto, para salir ingrese nombre "-": ');
   readln(p.nombre);
   while(p.nombre <> '-') do begin
       write('Ingrese codigo: ');
       readln(p.codigo);
       write('Ingrese valor: ');
       readln(p.valor);
       p.deleted:=false;
       Write(archivo, p);
       writeln('Carga exitosa');
       write('Ingrese nombre producto, para salir ingrese nombre "-": ');
       readln(p.nombre);
     end;
end;

function compararUsuario(var u:usuario; var data:datosUsuario; ingresante:str; passIngresante:str):boolean;
var
  found:boolean;
begin
   Seek(data, 0);
   while not EOF(data) do begin
      Read(data, u);
      if ((u.user = ingresante) AND (u.pass = passIngresante)) then
      begin
        found:=true;
      end
      else found:=false;
   end;
   compararUsuario:=found;
end;
procedure mostrarProducto(var prod:datosProductos; var p:producto);
begin
   Read(prod,p);
   writeln('');

   writeln('Indice de producto: ',(FilePos(prod)-1));
   writeln('Nombre: ',p.nombre);
   writeln('Valor: ',p.valor);
   writeln('Codigo: ',p.codigo);

   writeln('');
end;
procedure mostrarProductoEspecifico(var prod:datosProductos; var p:producto; i:int);
begin
   Seek(prod, i);
   mostrarProducto(prod, p);
end;

procedure listarProductos(var prod:datosProductos; p:producto);
begin
   Seek(prod, 0);
   while not EOF(prod) do begin
        mostrarProducto(prod, p);
   end;
   writeln('Cantidad de productos: ',FileSize(prod));
end;
procedure guardar(var datos:datosProductos; i:int; p:producto);
begin
   Seek(datos, (i));
   Write(datos,p);
end;

var

  datos:datosProductos;
  userData:datosUsuario;
  u: usuario;
  p: producto;
  userName:str;
  userPassword:str;
  i:int;
  seleccion1:int;
  seleccion2:int;
  seleccion3:int;
  indiceProducto:int;
  sesionIniciada:boolean;
  nuevaModificacionNombre:str;
  nuevaModificacion:int;

begin
   AssignFile(datos, 'productos_disponibles.bin');  //asignar archivo a la variable "datos"
   AssignFile(userData, 'crearUsuario/userData.bin');  //asignar archivo a la variable "userData"

   if (FileExists('productos_disponibles.bin')) then begin
   Reset(datos);   //si el archivo existe, cargar archivo datos de productos
   end
   else Rewrite(datos); //si el archivo de datos de productos no existe, lo crea

   if (FileExists('crearUsuario/userData.bin')) then begin
   Reset(userData); //si el archivo existe, cargar archivo de datos de usuario
   end
   else Rewrite(userData); //si el archivo de datos de usuario no existe, lo crea

   sesionIniciada:=false;

   writeln('Todos los derechos reservados. Aplicación creada por Alvez, Fernando Leonel, analista programador jr.');
   writeln('');
   writeln('Bienvenido usuario.');
   writeln('Que desea hacer?');
   writeln('1- Ingresar.');
   writeln('2- Salir');
   readln(seleccion1);
   repeat
   if ((sesionIniciada = false) AND (seleccion1 <> 2)) then begin
   write('Por favor, introduzca usuario: ');
   readln(userName);
   write('Por favor, introduzca contrasenia: ');
   readln(userPassword);
   end;
   if (compararUsuario( u,userData, userName, userPassword)) then begin
      writeln('');
      writeln('Bienvenido ',u.user,'!');
      writeln('');
      writeln('Que desea hacer?');
      writeln('1- Agregar producto.');
      writeln('2- Modificar producto');
      writeln('3- Eliminar producto');
      writeln('4- Listar productos cargados');
      writeln('5- Salir');
      readln(seleccion2);
      case (seleccion2) of
           1:
             begin
                 agregarProducto(datos, p);
             end;
           2:
             begin
                writeln('Que producto desea modificar? (ingrese indice entre 0 y ',(FileSize(datos)-1),')');
                writeln('Para conocer el indice, vea el menu anterior');
                readln(indiceProducto);
                mostrarProductoEspecifico(datos, p, (indiceProducto));
                writeln('Que desea modificar?');
                writeln('1- Nombre');
                writeln('2- Valor');
                writeln('3- Codigo');
                readln(seleccion3);
                case seleccion3 of
                     1: begin
                          write('Ingrese nuevo nombre: ');
                          readln(nuevaModificacionNombre);
                          p.nombre:=nuevaModificacionNombre;
                          guardar(datos,indiceProducto, p);
                        end;

                     2: begin
                          write('Ingrese nuevo valor: ');
                          readln(nuevaModificacion);
                          p.valor:=nuevaModificacion;
                          guardar(datos,indiceProducto, p);
                        end;

                     3: begin
                          write('Ingrese nuevo codigo: ');
                          readln(nuevaModificacion);
                          p.codigo:=nuevaModificacion;
                          guardar(datos,indiceProducto, p);
                        end;
                end;
             end;
           3:
             begin
                writeln('WIP');
             end;
           4:
             begin
                listarProductos(datos, p);
             end;
      end;
   sesionIniciada:=true;
   end
   else begin
             writeln('');
             writeln('Usuario incorrecto, ingrese nuevamente. Si no tiene usuario, cree uno usando la app "crear usuario".');
             writeln('');
        end;
   until ((seleccion1 = 2) OR (seleccion2 = 5));
   Close(datos);
   Close(userData);
end.
