program crearUsuario;
type
  str=string[30];
  int=integer;
  usuario = record
    nombre:str;
    password:str;
  end;

  datosUsuario = File of usuario;

  function compararTam(a:usuario; s:str):boolean;
  begin
    compararTam := ((length(a.nombre) >= 8)) AND ((length(a.nombre)) <= 20);
  end;

  procedure leerUsuario(var d:datosUsuario; var u:usuario);
  begin
    if (compararTam(u,'nombre'))then begin
      write('Ingrese contrasenia entre 8 y 20 caracteres: ');
      readln(u.password);
      if (compararTam(u,'password')) then begin
         Write(d, u);
         writeln('Usuario ', u.nombre,' creado con exito');
         end
      else writeln('Contrasenia incorrecta, elija de nuevo');
      end
    else writeln('Nombre incorrecto, escoja de nuevo');
    write('Ingrese nombre de usuario entre 8 y 20 caracteres: ');
    readln(u.nombre);
  end;

var
  userData:datosUsuario;
  user:usuario;
  i:int;
  seleccion:char;
begin
  i:=0;
  AssignFile(userData, 'userData.bin');
  Reset(userData);
  Seek(userData, FileSize(userData));
  writeln('Bienvenido usuario.');
  writeln('');
  writeln('Seleccione tarea:');
  writeln('1- Crear usuario.');
  writeln('2- Salir');
  readln(seleccion);
  while (seleccion <> '2') do begin
  if (seleccion = '1') then begin
       write('Ingrese usuario, para salir, ingrese usuario "-1":');
       readln(user.nombre);
       while(user.nombre <> '-1' ) do begin
          leerUsuario(userData, user);
       end;
  end
  else if (seleccion ='@') then begin
      Seek(userData,0);
      while (not EOF(userData)) do begin
        Read(userData, user);
        writeln('Usuario: ',user.nombre,' contrasena: ',user.password,' numero en tabla: ',FilePos(userData));
        end;


  end
  else writeln('Gracias');
  writeln('');
  writeln('Seleccione tarea:');
  writeln('1- Crear usuario.');
  writeln('2- Salir');
  readln(seleccion);
  end;
     Close(userData);
end.
